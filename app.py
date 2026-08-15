"""NPIMS Flask application — wired to MySQL."""

import os
from datetime import datetime, date, timedelta
from functools import wraps

try:
    from dotenv import load_dotenv

    load_dotenv()
except ImportError:
    pass

from flask import (
    Flask,
    flash,
    redirect,
    render_template,
    request,
    session,
    url_for,
)
from werkzeug.security import check_password_hash, generate_password_hash

import db
from db import MySQLError

app = Flask(__name__)
app.config["SECRET_KEY"] = os.getenv("SECRET_KEY", "replace-this-with-a-secure-secret")
app.config["SESSION_COOKIE_HTTPONLY"] = True
app.config["SESSION_COOKIE_SAMESITE"] = "Lax"

WEAK_SECRETS = {
    "",
    "replace-this-with-a-secure-secret",
    "change-me-to-a-long-random-string",
    "testing123",
}

POSITION_TO_ROLE = {
    "officer": "officer",
    "senior officer": "senior_officer",
    "supervisor": "supervisor",
    "director": "admin",
}

ROLE_RANK = {
    "citizen": 0,
    "officer": 1,
    "senior_officer": 2,
    "supervisor": 3,
    "admin": 4,
}

PASSPORT_FEES = {"ordinary": 150.00, "official": 250.00, "diplomatic": 300.00}
VISA_FEES = {
    "tourist": 100.00,
    "work": 150.00,
    "student": 120.00,
    "diplomatic": 200.00,
    "transit": 80.00,
}
PAYMENT_METHODS = {"mobile money", "card"}
PASSPORT_VALIDITY_YEARS = {"ordinary": 10, "official": 5, "diplomatic": 5}
VISA_VALIDITY_DAYS = {
    "tourist": 90,
    "work": 365,
    "student": 365,
    "diplomatic": 365,
    "transit": 14,
}
DESTINATION_COUNTRIES = (
    "United Kingdom",
    "United States",
    "Canada",
    "Germany",
    "France",
    "Italy",
    "Spain",
    "Netherlands",
    "Belgium",
    "Ireland",
    "Switzerland",
    "Sweden",
    "Norway",
    "Denmark",
    "Portugal",
    "United Arab Emirates",
    "Saudi Arabia",
    "Qatar",
    "South Africa",
    "Nigeria",
    "Kenya",
    "Côte d'Ivoire",
    "Togo",
    "Benin",
    "Burkina Faso",
    "China",
    "India",
    "Japan",
    "Australia",
    "Brazil",
)
POST_TYPES = {"air", "land", "sea"}
OFFICER_POSITIONS = set(POSITION_TO_ROLE.keys())
ENTRY_EXIT = {"entry", "exit"}


def _valid_email(email):
    if not email:
        return True
    email = email.strip()
    if "@" not in email or email.startswith("@") or email.endswith("@"):
        return False
    local, _, domain = email.partition("@")
    return bool(local) and "." in domain and " " not in email


def _parse_date(value, label="Date"):
    if not value:
        return None, f"{label} is required."
    try:
        return date.fromisoformat(value), None
    except ValueError:
        return None, f"{label} is invalid."


def _add_years(start, years):
    try:
        return start.replace(year=start.year + years)
    except ValueError:
        return start.replace(year=start.year + years, month=2, day=28)


def _proposed_passport_dates(passport_type):
    issue = date.today()
    years = PASSPORT_VALIDITY_YEARS.get(passport_type, 10)
    return issue, _add_years(issue, years)


def _proposed_visa_dates(visa_type):
    issue = date.today()
    days = VISA_VALIDITY_DAYS.get(visa_type, 90)
    return issue, issue + timedelta(days=days)


# ── Auth helpers ──────────────────────────────────────────────────────────────

def login_required(view):
    @wraps(view)
    def wrapped(*args, **kwargs):
        if "account_type" not in session:
            flash("Please log in to continue.", "error")
            return redirect(url_for("login", next=request.path))
        return view(*args, **kwargs)

    return wrapped


def citizen_required(view):
    @wraps(view)
    def wrapped(*args, **kwargs):
        if session.get("account_type") != "citizen":
            flash("Citizen access required.", "error")
            return redirect(url_for("login", next=request.path))
        return view(*args, **kwargs)

    return wrapped


def staff_required(min_role="officer"):
    def decorator(view):
        @wraps(view)
        def wrapped(*args, **kwargs):
            if session.get("account_type") != "staff":
                flash("Staff access required.", "error")
                return redirect(url_for("login", next=request.path))
            if ROLE_RANK.get(session.get("role"), 0) < ROLE_RANK.get(min_role, 1):
                flash("You do not have permission for that action.", "error")
                return redirect(url_for("staff") + "#queue")
            return view(*args, **kwargs)

        return wrapped

    return decorator


def _safe_next(raw):
    """Allow only relative in-app paths."""
    if not raw:
        return None
    raw = raw.strip()
    if not raw.startswith("/") or raw.startswith("//"):
        return None
    if raw.startswith("/login") or raw.startswith("/signup"):
        return None
    return raw


def _post_login_redirect(account_type, intent=None, next_url=None):
    nxt = _safe_next(next_url)
    if nxt:
        return redirect(nxt)
    if account_type == "staff":
        return redirect(url_for("staff") + "#queue")
    if intent == "passport":
        return redirect(url_for("passport"))
    if intent == "visa":
        return redirect(url_for("visa"))
    return redirect(url_for("citizen"))


def _is_locked(account):
    locked = account.get("locked_until")
    if locked and locked > datetime.now():
        return True
    return False


def _record_failed_login(login_id):
    db.execute(
        "UPDATE app_account SET failed_attempts = failed_attempts + 1 WHERE login_id = %s",
        (login_id,),
    )
    row = db.query(
        "SELECT failed_attempts FROM app_account WHERE login_id = %s",
        (login_id,),
        one=True,
    )
    if row and row["failed_attempts"] >= 5:
        db.execute(
            "UPDATE app_account SET locked_until = DATE_ADD(NOW(), INTERVAL 15 MINUTE) "
            "WHERE login_id = %s",
            (login_id,),
        )


def _clear_failed_login(login_id):
    db.execute(
        "UPDATE app_account SET failed_attempts = 0, locked_until = NULL WHERE login_id = %s",
        (login_id,),
    )


def _next_passport_id():
    row = db.query(
        "SELECT passport_id FROM passport WHERE passport_id LIKE 'G%%' "
        "ORDER BY passport_id DESC LIMIT 1",
        one=True,
    )
    if not row:
        return "G0100100"
    digits = "".join(c for c in row["passport_id"] if c.isdigit())
    n = int(digits or "1000000") + 1
    return f"G{n:07d}"


def _next_visa_id():
    row = db.query("SELECT COALESCE(MAX(visa_id), 0) AS m FROM visa", one=True)
    return int(row["m"]) + 1


def _mysql_message(exc):
    msg = str(exc)
    if hasattr(exc, "msg") and exc.msg:
        msg = exc.msg
    if "45000" in str(getattr(exc, "sqlstate", "")) or "45000" in msg:
        return msg.split(": ")[-1] if ": " in msg else msg
    if "Access denied" in msg or getattr(exc, "errno", None) == 1045:
        return "Cannot connect to MySQL. Check MYSQL_PASSWORD in .env and that the NPIMS database is imported."
    if "Unknown database" in msg:
        return "Database NPIMS not found. Import NPIMS_DB.sql."
    return msg


def _resolve_login_account(raw_id, preferred_type="citizen"):
    """Resolve national ID, officer ID, or citizen email to an app_account row.

    Returns (account_row, account_type, login_id) or (None, None, None).
    """
    raw_id = (raw_id or "").strip()
    if not raw_id:
        return None, None, None

    # Citizen email → national ID
    if "@" in raw_id:
        cit = db.query(
            "SELECT nat_idcard FROM citizen WHERE LOWER(email) = LOWER(%s)",
            (raw_id,),
            one=True,
        )
        if not cit:
            return None, None, None
        login_id = str(cit["nat_idcard"])
        account = db.query(
            "SELECT * FROM app_account WHERE login_id = %s AND account_type = 'citizen'",
            (login_id,),
            one=True,
        )
        if account:
            return account, "citizen", login_id
        return None, None, None

    # National ID or officer ID (digits). Prefer toggle, then try the other type.
    order = [preferred_type]
    other = "staff" if preferred_type == "citizen" else "citizen"
    if other not in order:
        order.append(other)

    for account_type in order:
        account = db.query(
            "SELECT * FROM app_account WHERE login_id = %s AND account_type = %s",
            (raw_id, account_type),
            one=True,
        )
        if account:
            return account, account_type, account["login_id"]
    return None, None, None


# ── Public routes ─────────────────────────────────────────────────────────────

@app.route("/")
def landing():
    return render_template("landing.html", user=session)


@app.route("/signup", methods=["GET", "POST"])
def signup():
    intent = request.args.get("intent") or request.form.get("intent")
    next_url = request.args.get("next") or request.form.get("next")
    if request.method == "POST":
        nat_id = (request.form.get("national_id") or "").strip()
        fname = (request.form.get("fname") or "").strip()
        lname = (request.form.get("lname") or "").strip()
        dob = request.form.get("date_of_birth") or None
        gender = request.form.get("gender")
        email = (request.form.get("email") or "").strip() or None
        address = (request.form.get("home_address") or "").strip()
        password = request.form.get("password") or ""
        confirm = request.form.get("confirm_password") or ""

        if not (nat_id.isdigit() and len(nat_id) == 9):
            flash("National ID must be exactly 9 digits.", "error")
            return render_template(
                "auth.html", mode="signup", intent=intent, next=next_url
            )

        if not fname or not lname:
            flash("First and last name are required.", "error")
            return render_template(
                "auth.html", mode="signup", intent=intent, next=next_url
            )

        if gender not in ("M", "F"):
            flash("Select a valid gender.", "error")
            return render_template(
                "auth.html", mode="signup", intent=intent, next=next_url
            )

        if not address:
            flash("Home address is required.", "error")
            return render_template(
                "auth.html", mode="signup", intent=intent, next=next_url
            )

        if not dob:
            flash("Date of birth is required.", "error")
            return render_template(
                "auth.html", mode="signup", intent=intent, next=next_url
            )
        dob_parsed, dob_err = _parse_date(dob, "Date of birth")
        if dob_err:
            flash(dob_err, "error")
            return render_template(
                "auth.html", mode="signup", intent=intent, next=next_url
            )
        if dob_parsed >= date.today():
            flash("Date of birth must be in the past.", "error")
            return render_template(
                "auth.html", mode="signup", intent=intent, next=next_url
            )

        if email and not _valid_email(email):
            flash("Enter a valid email address.", "error")
            return render_template(
                "auth.html", mode="signup", intent=intent, next=next_url
            )

        if password != confirm or len(password) < 6:
            flash("Passwords must match and be at least 6 characters.", "error")
            return render_template(
                "auth.html", mode="signup", intent=intent, next=next_url
            )

        try:
            if db.query(
                "SELECT 1 FROM citizen WHERE nat_idcard = %s", (int(nat_id),), one=True
            ):
                flash("That national ID is already registered.", "error")
                return render_template(
                    "auth.html", mode="signup", intent=intent, next=next_url
                )

            if db.query(
                "SELECT 1 FROM app_account WHERE login_id = %s", (nat_id,), one=True
            ):
                flash("An account already exists for that ID.", "error")
                return render_template(
                    "auth.html", mode="signup", intent=intent, next=next_url
                )

            db.execute(
                "INSERT INTO citizen (nat_idcard, fname, lname, gender, email, "
                "home_address, dob) VALUES (%s,%s,%s,%s,%s,%s,%s)",
                (int(nat_id), fname, lname, gender, email, address, dob_parsed),
            )
            db.execute(
                "INSERT INTO app_account (account_type, login_id, password_hash) "
                "VALUES ('citizen', %s, %s)",
                (nat_id, generate_password_hash(password)),
            )
        except MySQLError as e:
            flash(_mysql_message(e), "error")
            return render_template(
                "auth.html", mode="signup", intent=intent, next=next_url
            )

        session.clear()
        session["account_type"] = "citizen"
        session["citizen_id"] = int(nat_id)
        session["role"] = "citizen"
        session["name"] = f"{fname} {lname}"
        flash("Account created. Welcome!", "success")
        return _post_login_redirect("citizen", intent=intent, next_url=next_url)

    return render_template(
        "auth.html", mode="signup", intent=intent, next=next_url
    )


@app.route("/login", methods=["GET", "POST"])
def login():
    intent = request.args.get("intent") or request.form.get("intent")
    next_url = request.args.get("next") or request.form.get("next")
    if request.method == "POST":
        preferred_type = request.form.get("account_type", "citizen")
        if preferred_type not in ("citizen", "staff"):
            preferred_type = "citizen"
        raw_id = (request.form.get("login_id") or "").strip()
        password = request.form.get("password") or ""

        try:
            account, account_type, login_id = _resolve_login_account(raw_id, preferred_type)
            if not account:
                flash("Invalid credentials.", "error")
                return render_template(
                    "auth.html", mode="login", intent=intent, next=next_url
                )

            if _is_locked(account):
                flash(
                    "Account locked after too many failed attempts. Try again later.",
                    "error",
                )
                return render_template(
                    "auth.html", mode="login", intent=intent, next=next_url
                )

            if not check_password_hash(account["password_hash"], password):
                _record_failed_login(account["login_id"])
                flash("Invalid credentials.", "error")
                return render_template(
                    "auth.html", mode="login", intent=intent, next=next_url
                )

            _clear_failed_login(account["login_id"])
            session.clear()

            if account_type == "staff":
                officer = db.query(
                    "SELECT * FROM immigration_officer WHERE officer_id = %s",
                    (int(login_id),),
                    one=True,
                )
                if not officer:
                    flash("Staff record not found.", "error")
                    return render_template(
                        "auth.html", mode="login", intent=intent, next=next_url
                    )
                session["account_type"] = "staff"
                session["officer_id"] = officer["officer_id"]
                session["role"] = POSITION_TO_ROLE.get(officer["position"], "officer")
                session["name"] = f"{officer['fname']} {officer['lname']}"
                session["position"] = officer["position"]
                flash(f"Welcome, {session['name']}.", "success")
                return _post_login_redirect("staff", next_url=next_url)

            citizen = db.query(
                "SELECT * FROM citizen WHERE nat_idcard = %s",
                (int(login_id),),
                one=True,
            )
            if not citizen:
                flash("Citizen record not found.", "error")
                return render_template(
                    "auth.html", mode="login", intent=intent, next=next_url
                )
            session["account_type"] = "citizen"
            session["citizen_id"] = citizen["nat_idcard"]
            session["role"] = "citizen"
            session["name"] = f"{citizen['fname']} {citizen['lname']}"
            flash(f"Welcome back, {citizen['fname']}.", "success")
            return _post_login_redirect(
                "citizen", intent=intent, next_url=next_url
            )
        except (MySQLError, ValueError) as e:
            flash(_mysql_message(e) if isinstance(e, MySQLError) else "Invalid credentials.", "error")
            return render_template(
                "auth.html", mode="login", intent=intent, next=next_url
            )

    return render_template(
        "auth.html", mode="login", intent=intent, next=next_url
    )


@app.route("/logout")
def logout():
    session.clear()
    flash("You have been logged out.", "success")
    return redirect(url_for("landing"))


# ── Citizen routes ────────────────────────────────────────────────────────────

@app.route("/citizen")
@login_required
@citizen_required
def citizen():
    cid = session["citizen_id"]
    person = db.query(
        "SELECT *, fn_calculate_age(dob) AS age FROM citizen WHERE nat_idcard = %s",
        (cid,),
        one=True,
    )
    summary_rows = db.query(
        "SELECT * FROM vw_citizen_summary WHERE nat_idcard = %s",
        (cid,),
    )
    summary = summary_rows[0] if summary_rows else None
    if summary_rows:
        # Prefer an issued passport status from the view if present
        issued = next(
            (r for r in summary_rows if (r.get("passport_status") or "").lower() == "issued"),
            None,
        )
        if issued:
            summary = issued
    passports = db.query(
        "SELECT * FROM passport WHERE nat_idcard = %s ORDER BY passport_id DESC",
        (cid,),
    )
    visas = db.query(
        "SELECT v.* FROM visa v "
        "JOIN passport p ON v.passport_id = p.passport_id "
        "WHERE p.nat_idcard = %s ORDER BY v.visa_id DESC",
        (cid,),
    )
    payments = db.query(
        "SELECT * FROM payment WHERE nat_idcard = %s ORDER BY payment_date DESC, payment_id DESC",
        (cid,),
    )
    paid_passports = {
        p["passport_id"]
        for p in payments
        if p.get("passport_id") and p["status"] == "completed"
    }
    paid_visas = {
        p["visa_id"] for p in payments if p.get("visa_id") and p["status"] == "completed"
    }
    for p in passports:
        p["needs_payment"] = (
            p["status"] in ("pending", "processing")
            and p["passport_id"] not in paid_passports
        )
    for v in visas:
        v["needs_payment"] = (
            v["status"] == "pending" and v["visa_id"] not in paid_visas
        )
    active = next((p for p in passports if p["status"] == "issued"), None)
    total_paid = float(summary["total_paid"]) if summary else float(
        sum((p["amount"] or 0) for p in payments if p["status"] == "completed")
    )
    view_passport_status = (
        (summary.get("passport_status") if summary else None)
        or (active["status"] if active else None)
        or "None"
    )
    return render_template(
        "citizen.html",
        person=person,
        passports=passports,
        visas=visas,
        payments=payments,
        active_passport=active,
        total_paid=total_paid,
        view_passport_status=view_passport_status,
        summary=summary,
        user=session,
    )


@app.route("/passport", methods=["GET", "POST"])
@login_required
@citizen_required
def passport():
    cid = session["citizen_id"]
    blocked = db.query(
        "SELECT passport_id, status FROM passport "
        "WHERE nat_idcard = %s AND status IN ('pending', 'processing') LIMIT 1",
        (cid,),
        one=True,
    )
    def passport_form():
        proposed_issue, proposed_expiry = _proposed_passport_dates("ordinary")
        return render_template(
            "passport.html",
            user=session,
            blocked=blocked,
            proposed_issue=proposed_issue.isoformat(),
            proposed_expiry=proposed_expiry.isoformat(),
            passport_validity_years=PASSPORT_VALIDITY_YEARS,
        )

    if request.method == "POST":
        if blocked:
            flash(
                f"You already have passport {blocked['passport_id']} in "
                f"{blocked['status']}. Finish or wait for that one first.",
                "error",
            )
            return passport_form()
        ptype = request.form.get("passport_type", "ordinary")
        if ptype not in PASSPORT_FEES:
            flash("Select a valid passport type.", "error")
            return passport_form()
        issue_d, expiry_d = _proposed_passport_dates(ptype)

        pid = _next_passport_id()
        try:
            db.execute(
                "INSERT INTO passport (passport_id, status, passport_type, issue_date, "
                "expiry_date, nat_idcard) VALUES (%s, 'pending', %s, %s, %s, %s)",
                (pid, ptype, issue_d, expiry_d, cid),
            )
        except MySQLError as e:
            flash(_mysql_message(e), "error")
            return passport_form()

        flash(f"Passport application {pid} submitted.", "success")
        return redirect(url_for("payment", kind="passport", ref=pid))

    return passport_form()


@app.route("/visa", methods=["GET", "POST"])
@login_required
@citizen_required
def visa():
    cid = session["citizen_id"]
    eligible = db.query(
        "SELECT passport_id, passport_type, expiry_date, status FROM passport "
        "WHERE nat_idcard = %s AND status = 'issued' "
        "AND expiry_date IS NOT NULL AND expiry_date >= DATE_ADD(CURDATE(), INTERVAL 6 MONTH) "
        "ORDER BY expiry_date DESC",
        (cid,),
    )

    if request.method == "POST":
        passport_id = request.form.get("passport_id")
        visa_type = request.form.get("visa_type")
        destination = (request.form.get("destination") or "").strip()

        def visa_form():
            proposed_issue, proposed_expiry = _proposed_visa_dates(
                visa_type if visa_type in VISA_FEES else "tourist"
            )
            return render_template(
                "visa.html",
                eligible=eligible,
                user=session,
                destinations=DESTINATION_COUNTRIES,
                visa_validity_days=VISA_VALIDITY_DAYS,
                proposed_issue=proposed_issue.isoformat(),
                proposed_expiry=proposed_expiry.isoformat(),
            )

        if not all([passport_id, visa_type, destination]):
            flash("Please fill in all required fields.", "error")
            return visa_form()

        if visa_type not in VISA_FEES:
            flash("Select a valid visa type.", "error")
            return visa_form()

        if destination not in DESTINATION_COUNTRIES:
            flash("Select a valid destination country.", "error")
            return visa_form()

        issue_d, expiry_d = _proposed_visa_dates(visa_type)

        own = any(p["passport_id"] == passport_id for p in eligible)
        if not own:
            flash("Select one of your eligible passports.", "error")
            return visa_form()

        vid = _next_visa_id()
        try:
            db.execute(
                "INSERT INTO visa (visa_id, visa_type, passport_id, destination, "
                "issue_date, expiry_date, status) VALUES (%s,%s,%s,%s,%s,%s,'pending')",
                (vid, visa_type, passport_id, destination, issue_d, expiry_d),
            )
        except MySQLError as e:
            flash(_mysql_message(e), "error")
            return visa_form()

        flash(f"Visa application #{vid} submitted.", "success")
        return redirect(url_for("payment", kind="visa", ref=str(vid)))

    proposed_issue, proposed_expiry = _proposed_visa_dates("tourist")
    return render_template(
        "visa.html",
        eligible=eligible,
        user=session,
        destinations=DESTINATION_COUNTRIES,
        visa_validity_days=VISA_VALIDITY_DAYS,
        proposed_issue=proposed_issue.isoformat(),
        proposed_expiry=proposed_expiry.isoformat(),
    )


@app.route("/payment", methods=["GET", "POST"])
@login_required
@citizen_required
def payment():
    cid = session["citizen_id"]
    kind = request.args.get("kind") or request.form.get("kind")
    ref = request.args.get("ref") or request.form.get("ref")

    amount = 150.00
    if kind == "passport":
        row = db.query(
            "SELECT * FROM passport WHERE passport_id = %s AND nat_idcard = %s",
            (ref, cid),
            one=True,
        )
        if not row:
            flash("Passport application not found.", "error")
            return redirect(url_for("citizen"))
        amount = PASSPORT_FEES.get(row["passport_type"], 150.00)
    elif kind == "visa":
        row = db.query(
            "SELECT v.* FROM visa v JOIN passport p ON v.passport_id = p.passport_id "
            "WHERE v.visa_id = %s AND p.nat_idcard = %s",
            (int(ref), cid),
            one=True,
        )
        if not row:
            flash("Visa application not found.", "error")
            return redirect(url_for("citizen"))
        amount = VISA_FEES.get(row["visa_type"], 100.00)
    else:
        flash("Nothing to pay for.", "error")
        return redirect(url_for("citizen"))

    if request.method == "POST":
        method = request.form.get("payment_method", "mobile money")
        if method not in PAYMENT_METHODS:
            flash("Select a valid payment method.", "error")
            return render_template(
                "payment.html",
                kind=kind,
                ref=ref,
                amount=amount,
                user=session,
            )
        passport_id = ref if kind == "passport" else None
        visa_id = int(ref) if kind == "visa" else None
        try:
            db.callproc(
                "sp_register_payment",
                (
                    cid,
                    passport_id,
                    visa_id,
                    float(amount),
                    "completed",
                    date.today().isoformat(),
                    method,
                ),
            )
        except MySQLError as e:
            flash(_mysql_message(e), "error")
            return render_template(
                "payment.html",
                kind=kind,
                ref=ref,
                amount=amount,
                user=session,
            )
        flash("Payment recorded successfully.", "success")
        return redirect(url_for("citizen"))

    return render_template(
        "payment.html", kind=kind, ref=ref, amount=amount, user=session
    )


@app.route("/track", methods=["GET", "POST"])
@login_required
@citizen_required
def track():
    cid = session["citizen_id"]
    results = {"passports": [], "visas": []}
    q = (request.args.get("q") or request.form.get("q") or "").strip()

    if q:
        results["passports"] = db.query(
            "SELECT * FROM passport WHERE nat_idcard = %s AND passport_id = %s",
            (cid, q),
        )
        if q.isdigit():
            results["visas"] = db.query(
                "SELECT v.* FROM visa v "
                "JOIN passport p ON v.passport_id = p.passport_id "
                "WHERE p.nat_idcard = %s AND v.visa_id = %s",
                (cid, int(q)),
            )
    else:
        results["passports"] = db.query(
            "SELECT * FROM passport WHERE nat_idcard = %s ORDER BY passport_id DESC",
            (cid,),
        )
        results["visas"] = db.query(
            "SELECT v.* FROM visa v "
            "JOIN passport p ON v.passport_id = p.passport_id "
            "WHERE p.nat_idcard = %s ORDER BY v.visa_id DESC",
            (cid,),
        )

    return render_template("track.html", results=results, q=q, user=session)


@app.route("/help")
def help_page():
    return render_template("help.html", user=session)


# ── Staff routes ──────────────────────────────────────────────────────────────

def _staff_redirect(default="staff"):
    nxt = request.form.get("next") or request.args.get("next")
    mapping = {
        "queue": "staff",
        "passports": "staff_passports",
        "visas": "staff_visas",
        "travel": "staff_travel_page",
    }
    endpoint = mapping.get(nxt, default if default != "queue" else "staff")
    if endpoint == "staff":
        return redirect(url_for("staff"))
    return redirect(url_for(endpoint))


@app.route("/staff")
@login_required
@staff_required("officer")
def staff():
    pending_passports = db.query(
        "SELECT p.*, c.fname, c.lname FROM passport p "
        "JOIN citizen c ON p.nat_idcard = c.nat_idcard "
        "WHERE p.status IN ('pending', 'processing') "
        "ORDER BY p.passport_id DESC LIMIT 50"
    )
    pending_visas = db.query(
        "SELECT v.*, c.fname, c.lname, p.nat_idcard FROM visa v "
        "JOIN passport p ON v.passport_id = p.passport_id "
        "JOIN citizen c ON p.nat_idcard = c.nat_idcard "
        "WHERE v.status = 'pending' ORDER BY v.visa_id DESC LIMIT 50"
    )
    stats = {
        "pending_passports": db.query(
            "SELECT COUNT(*) AS n FROM passport WHERE status IN ('pending','processing')",
            one=True,
        )["n"],
        "pending_visas": db.query(
            "SELECT COUNT(*) AS n FROM visa WHERE status = 'pending'", one=True
        )["n"],
        "today_travel": db.query(
            "SELECT COUNT(*) AS n FROM travel_record WHERE DATE(timestamp) = CURDATE()",
            one=True,
        )["n"],
        "posts": db.query("SELECT COUNT(*) AS n FROM border_post", one=True)["n"],
    }
    return render_template(
        "staff.html",
        pending_passports=pending_passports,
        pending_visas=pending_visas,
        stats=stats,
        user=session,
        role_rank=ROLE_RANK.get(session.get("role"), 0),
        active_nav="queue",
    )


@app.route("/staff/citizens", methods=["GET"])
@login_required
@staff_required("officer")
def staff_citizens():
    q = (request.args.get("q") or "").strip()
    gender = request.args.get("gender") or ""
    sql = "SELECT * FROM citizen WHERE 1=1"
    params = []
    if q:
        if q.isdigit():
            sql += " AND nat_idcard = %s"
            params.append(int(q))
        else:
            sql += " AND (fname LIKE %s OR lname LIKE %s)"
            params.extend([f"%{q}%", f"%{q}%"])
    if gender in ("M", "F"):
        sql += " AND gender = %s"
        params.append(gender)
    sql += " ORDER BY nat_idcard LIMIT 100"
    rows = db.query(sql, tuple(params))
    return render_template(
        "staff_citizens.html",
        rows=rows,
        q=q,
        gender=gender,
        user=session,
        role_rank=ROLE_RANK.get(session.get("role"), 0),
        active_nav="citizens",
    )


@app.route("/staff/citizens/<int:nat_idcard>", methods=["POST"])
@login_required
@staff_required("supervisor")
def staff_citizen_update(nat_idcard):
    email = (request.form.get("email") or "").strip() or None
    address = (request.form.get("home_address") or "").strip()
    if not address:
        flash("Home address is required.", "error")
        return redirect(url_for("staff_citizens"))
    if email and not _valid_email(email):
        flash("Enter a valid email address.", "error")
        return redirect(url_for("staff_citizens"))
    try:
        n = db.execute(
            "UPDATE citizen SET email = %s, home_address = %s WHERE nat_idcard = %s",
            (email, address, nat_idcard),
        )
        if not n:
            flash("Citizen not found.", "error")
        else:
            flash(f"Citizen {nat_idcard} updated.", "success")
    except MySQLError as e:
        flash(_mysql_message(e), "error")
    return redirect(url_for("staff_citizens"))


@app.route("/staff/passports")
@login_required
@staff_required("officer")
def staff_passports():
    q = (request.args.get("q") or "").strip()
    status = request.args.get("status") or ""
    passport_type = request.args.get("passport_type") or ""
    sql = (
        "SELECT p.*, c.fname, c.lname FROM passport p "
        "JOIN citizen c ON p.nat_idcard = c.nat_idcard WHERE 1=1"
    )
    params = []
    if q:
        if q.isdigit():
            sql += " AND p.nat_idcard = %s"
            params.append(int(q))
        else:
            sql += " AND p.passport_id LIKE %s"
            params.append(f"%{q}%")
    if status:
        sql += " AND p.status = %s"
        params.append(status)
    if passport_type:
        sql += " AND p.passport_type = %s"
        params.append(passport_type)
    sql += " ORDER BY p.passport_id DESC LIMIT 100"
    rows = db.query(sql, tuple(params))
    return render_template(
        "staff_passports.html",
        rows=rows,
        q=q,
        status=status,
        passport_type=passport_type,
        user=session,
        role_rank=ROLE_RANK.get(session.get("role"), 0),
        active_nav="passports",
    )


@app.route("/staff/visas")
@login_required
@staff_required("officer")
def staff_visas():
    q = (request.args.get("q") or "").strip()
    status = request.args.get("status") or ""
    visa_type = request.args.get("visa_type") or ""
    sql = (
        "SELECT v.*, c.fname, c.lname FROM visa v "
        "JOIN passport p ON v.passport_id = p.passport_id "
        "JOIN citizen c ON p.nat_idcard = c.nat_idcard WHERE 1=1"
    )
    params = []
    if q:
        if q.isdigit():
            sql += " AND v.visa_id = %s"
            params.append(int(q))
        else:
            sql += " AND v.destination LIKE %s"
            params.append(f"%{q}%")
    if status:
        sql += " AND v.status = %s"
        params.append(status)
    if visa_type:
        sql += " AND v.visa_type = %s"
        params.append(visa_type)
    sql += " ORDER BY v.visa_id DESC LIMIT 100"
    rows = db.query(sql, tuple(params))
    return render_template(
        "staff_visas.html",
        rows=rows,
        q=q,
        status=status,
        visa_type=visa_type,
        user=session,
        role_rank=ROLE_RANK.get(session.get("role"), 0),
        active_nav="visas",
    )


@app.route("/staff/payments")
@login_required
@staff_required("officer")
def staff_payments():
    q = (request.args.get("q") or "").strip()
    status = request.args.get("status") or ""
    payment_method = request.args.get("payment_method") or ""
    sql = "SELECT * FROM payment WHERE 1=1"
    params = []
    if q:
        if q.isdigit():
            sql += " AND (nat_idcard = %s OR visa_id = %s)"
            params.extend([int(q), int(q)])
        else:
            sql += " AND passport_id LIKE %s"
            params.append(f"%{q}%")
    if status:
        sql += " AND status = %s"
        params.append(status)
    if payment_method:
        sql += " AND payment_method = %s"
        params.append(payment_method)
    sql += " ORDER BY payment_date DESC, payment_id DESC LIMIT 100"
    rows = db.query(sql, tuple(params))
    return render_template(
        "staff_payments.html",
        rows=rows,
        q=q,
        status=status,
        payment_method=payment_method,
        user=session,
        role_rank=ROLE_RANK.get(session.get("role"), 0),
        active_nav="payments",
    )


@app.route("/staff/travel", methods=["GET"])
@login_required
@staff_required("officer")
def staff_travel_page():
    posts = db.query("SELECT * FROM border_post ORDER BY border_name")
    nat_idcard = (request.args.get("nat_idcard") or "").strip()
    passport_id = (request.args.get("passport_id") or "").strip()
    entry_exit = request.args.get("entry_exit") or ""
    date_from = request.args.get("date_from") or ""
    date_to = request.args.get("date_to") or ""
    post_id = request.args.get("post_id") or ""
    sql = (
        "SELECT t.*, bp.border_name FROM travel_record t "
        "JOIN border_post bp ON t.post_id = bp.post_id WHERE 1=1"
    )
    params = []
    if nat_idcard.isdigit():
        sql += " AND t.nat_idcard = %s"
        params.append(int(nat_idcard))
    if passport_id:
        sql += " AND t.passport_id = %s"
        params.append(passport_id)
    if entry_exit in ("entry", "exit"):
        sql += " AND t.entry_exit = %s"
        params.append(entry_exit)
    if date_from:
        sql += " AND DATE(t.timestamp) >= %s"
        params.append(date_from)
    if date_to:
        sql += " AND DATE(t.timestamp) <= %s"
        params.append(date_to)
    if post_id.isdigit():
        sql += " AND t.post_id = %s"
        params.append(int(post_id))
    sql += " ORDER BY t.timestamp DESC LIMIT 100"
    rows = db.query(sql, tuple(params))
    return render_template(
        "staff_travel.html",
        rows=rows,
        posts=posts,
        nat_idcard=nat_idcard,
        passport_id=passport_id,
        entry_exit=entry_exit,
        date_from=date_from,
        date_to=date_to,
        post_id=post_id,
        user=session,
        role_rank=ROLE_RANK.get(session.get("role"), 0),
        active_nav="travel",
    )


@app.route("/staff/travel/log", methods=["POST"])
@login_required
@staff_required("officer")
def staff_travel_log():
    nat_raw = (request.form.get("nat_idcard") or "").strip()
    passport_id = (request.form.get("passport_id") or "").strip()
    entry_exit = request.form.get("entry_exit")
    destination = (request.form.get("destination_country") or "").strip()
    post_raw = (request.form.get("post_id") or "").strip()

    if not (nat_raw.isdigit() and len(nat_raw) == 9):
        flash("National ID must be exactly 9 digits.", "error")
        return redirect(url_for("staff_travel_page"))
    if not passport_id:
        flash("Passport ID is required.", "error")
        return redirect(url_for("staff_travel_page"))
    if entry_exit not in ENTRY_EXIT:
        flash("Entry/exit must be entry or exit.", "error")
        return redirect(url_for("staff_travel_page"))
    if not destination:
        flash("Destination country is required.", "error")
        return redirect(url_for("staff_travel_page"))
    if not post_raw.isdigit():
        flash("Select a valid border post.", "error")
        return redirect(url_for("staff_travel_page"))

    nat_idcard = int(nat_raw)
    post_id = int(post_raw)
    passport = db.query(
        "SELECT passport_id, status FROM passport "
        "WHERE passport_id = %s AND nat_idcard = %s",
        (passport_id, nat_idcard),
        one=True,
    )
    if not passport:
        flash("Passport not found for that national ID.", "error")
        return redirect(url_for("staff_travel_page"))
    if passport["status"] not in ("issued", "approved"):
        flash(
            f"Passport {passport_id} is {passport['status']} — only issued/approved may travel.",
            "error",
        )
        return redirect(url_for("staff_travel_page"))

    try:
        db.callproc(
            "sp_log_travel_record",
            (
                nat_idcard,
                passport_id,
                post_id,
                session["officer_id"],
                entry_exit,
                destination,
            ),
        )
        flash("Travel record logged.", "success")
    except (MySQLError, KeyError, ValueError) as e:
        flash(_mysql_message(e) if isinstance(e, MySQLError) else str(e), "error")
    return redirect(url_for("staff_travel_page"))


@app.route("/staff/posts", methods=["GET", "POST"])
@login_required
@staff_required("officer")
def staff_posts():
    role_rank = ROLE_RANK.get(session.get("role"), 0)
    if request.method == "POST":
        if role_rank < ROLE_RANK["admin"]:
            flash("Admin access required.", "error")
            return redirect(url_for("staff_posts"))
        action = request.form.get("action")
        try:
            if action in ("create", "update"):
                post_id_raw = (request.form.get("post_id") or "").strip()
                border_name = (request.form.get("border_name") or "").strip()
                post_type = request.form.get("post_type")
                region = (request.form.get("region") or "").strip() or None
                if not post_id_raw.isdigit():
                    flash("Post ID must be a number.", "error")
                    return redirect(url_for("staff_posts"))
                if not border_name:
                    flash("Border post name is required.", "error")
                    return redirect(url_for("staff_posts"))
                if post_type not in POST_TYPES:
                    flash("Post type must be air, land, or sea.", "error")
                    return redirect(url_for("staff_posts"))
                post_id = int(post_id_raw)
                if action == "create":
                    db.execute(
                        "INSERT INTO border_post (post_id, border_name, post_type, region) "
                        "VALUES (%s,%s,%s,%s)",
                        (post_id, border_name, post_type, region),
                    )
                    flash("Border post created.", "success")
                else:
                    n = db.execute(
                        "UPDATE border_post SET border_name=%s, post_type=%s, region=%s "
                        "WHERE post_id=%s",
                        (border_name, post_type, region, post_id),
                    )
                    if not n:
                        flash("Border post not found.", "error")
                    else:
                        flash("Border post updated.", "success")
            elif action == "delete":
                post_id_raw = (request.form.get("post_id") or "").strip()
                if not post_id_raw.isdigit():
                    flash("Invalid post ID.", "error")
                    return redirect(url_for("staff_posts"))
                n = db.execute(
                    "DELETE FROM border_post WHERE post_id=%s",
                    (int(post_id_raw),),
                )
                if not n:
                    flash("Border post not found.", "error")
                else:
                    flash("Border post deleted.", "success")
            else:
                flash("Unknown action.", "error")
        except MySQLError as e:
            flash(_mysql_message(e), "error")
        return redirect(url_for("staff_posts"))

    edit_id = request.args.get("edit")
    edit_post = None
    if edit_id and edit_id.isdigit():
        edit_post = db.query(
            "SELECT * FROM border_post WHERE post_id=%s", (int(edit_id),), one=True
        )
    rows = db.query("SELECT * FROM border_post ORDER BY post_id")
    return render_template(
        "staff_posts.html",
        rows=rows,
        edit_post=edit_post,
        user=session,
        role_rank=role_rank,
        active_nav="posts",
    )


@app.route("/staff/officers", methods=["GET", "POST"])
@login_required
@staff_required("officer")
def staff_officers():
    role_rank = ROLE_RANK.get(session.get("role"), 0)
    posts = db.query("SELECT * FROM border_post ORDER BY border_name")
    if request.method == "POST":
        if role_rank < ROLE_RANK["admin"]:
            flash("Admin access required.", "error")
            return redirect(url_for("staff_officers"))
        action = request.form.get("action")
        try:
            oid_raw = (request.form.get("officer_id") or "").strip()
            fname = (request.form.get("fname") or "").strip()
            lname = (request.form.get("lname") or "").strip()
            position = request.form.get("position")
            phone = (request.form.get("phone_number") or "").strip()
            post_raw = (request.form.get("post_id") or "").strip()
            if not oid_raw.isdigit():
                flash("Officer ID must be a number.", "error")
                return redirect(url_for("staff_officers"))
            if not fname or not lname:
                flash("First and last name are required.", "error")
                return redirect(url_for("staff_officers"))
            if position not in OFFICER_POSITIONS:
                flash("Select a valid officer position.", "error")
                return redirect(url_for("staff_officers"))
            if not phone:
                flash("Phone number is required.", "error")
                return redirect(url_for("staff_officers"))
            if not post_raw.isdigit():
                flash("Select a valid border post.", "error")
                return redirect(url_for("staff_officers"))
            oid = int(oid_raw)
            post_id = int(post_raw)
            if action == "create":
                db.execute(
                    "INSERT INTO immigration_officer "
                    "(officer_id, fname, lname, position, phone_number, post_id) "
                    "VALUES (%s,%s,%s,%s,%s,%s)",
                    (oid, fname, lname, position, phone, post_id),
                )
                if not db.query(
                    "SELECT 1 FROM app_account WHERE login_id=%s", (str(oid),), one=True
                ):
                    db.execute(
                        "INSERT INTO app_account (account_type, login_id, password_hash) "
                        "VALUES ('staff', %s, %s)",
                        (str(oid), generate_password_hash("password123")),
                    )
                flash(f"Officer {oid} created (login password: password123).", "success")
            elif action == "update":
                n = db.execute(
                    "UPDATE immigration_officer SET fname=%s, lname=%s, position=%s, "
                    "phone_number=%s, post_id=%s WHERE officer_id=%s",
                    (fname, lname, position, phone, post_id, oid),
                )
                if not n:
                    flash("Officer not found.", "error")
                else:
                    flash(f"Officer {oid} updated.", "success")
            else:
                flash("Unknown action.", "error")
        except (MySQLError, ValueError) as e:
            flash(_mysql_message(e) if isinstance(e, MySQLError) else str(e), "error")
        return redirect(url_for("staff_officers"))

    edit_id = request.args.get("edit")
    edit_officer = None
    if edit_id and edit_id.isdigit():
        edit_officer = db.query(
            "SELECT * FROM immigration_officer WHERE officer_id=%s",
            (int(edit_id),),
            one=True,
        )
    rows = db.query(
        "SELECT o.*, bp.border_name FROM immigration_officer o "
        "LEFT JOIN border_post bp ON o.post_id = bp.post_id "
        "ORDER BY o.officer_id"
    )
    return render_template(
        "staff_officers.html",
        rows=rows,
        posts=posts,
        edit_officer=edit_officer,
        user=session,
        role_rank=role_rank,
        active_nav="officers",
    )


@app.route("/staff/reports")
@login_required
@staff_required("officer")
def staff_reports():
    role = session.get("role")
    role_rank = ROLE_RANK.get(role, 0)
    reports = {
        "expiring": db.query(
            "SELECT passport_id, nat_idcard, passport_type, expiry_date, "
            "DATEDIFF(expiry_date, CURDATE()) AS days_left FROM passport "
            "WHERE status = 'issued' AND expiry_date IS NOT NULL "
            "AND expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 90 DAY) "
            "ORDER BY expiry_date LIMIT 50"
        )
    }
    if role_rank >= ROLE_RANK["supervisor"]:
        reports["officer_perf"] = db.query(
            "SELECT * FROM vw_officer_performance LIMIT 30"
        )
        reports["border_traffic"] = db.query(
            "SELECT * FROM vw_border_traffic LIMIT 30"
        )
        reports["citizen_summary"] = db.query(
            "SELECT * FROM vw_citizen_summary LIMIT 30"
        )
        reports["citizens_by_apps"] = db.query(
            "SELECT c.nat_idcard, c.fname, c.lname, "
            "COUNT(DISTINCT p.passport_id) AS passport_count, "
            "COUNT(DISTINCT v.visa_id) AS visa_count, "
            "(COUNT(DISTINCT p.passport_id) + COUNT(DISTINCT v.visa_id)) AS total_apps "
            "FROM citizen c "
            "LEFT JOIN passport p ON c.nat_idcard = p.nat_idcard "
            "LEFT JOIN visa v ON p.passport_id = v.passport_id "
            "GROUP BY c.nat_idcard, c.fname, c.lname "
            "ORDER BY total_apps DESC LIMIT 30"
        )
    if role_rank >= ROLE_RANK["admin"]:
        reports["payments"] = db.query(
            "SELECT * FROM vw_payment_overview ORDER BY payment_date DESC LIMIT 30"
        )
        reports["monthly_revenue"] = db.query(
            "SELECT YEAR(payment_date) AS yr, MONTH(payment_date) AS mo, "
            "SUM(amount) AS total, COUNT(*) AS n FROM payment "
            "WHERE status = 'completed' "
            "GROUP BY YEAR(payment_date), MONTH(payment_date) "
            "ORDER BY yr DESC, mo DESC LIMIT 24"
        )
    return render_template(
        "staff_reports.html",
        reports=reports,
        user=session,
        role_rank=role_rank,
        active_nav="reports",
    )


@app.route("/staff/passport/<passport_id>/status", methods=["POST"])
@login_required
@staff_required("senior_officer")
def staff_passport_status(passport_id):
    new_status = request.form.get("status")
    if new_status not in ("processing", "rejected"):
        flash("Invalid status.", "error")
        return _staff_redirect("passports")
    allowed_from = ("pending",) if new_status == "processing" else ("pending", "processing")
    try:
        n = db.execute(
            "UPDATE passport SET status = %s "
            "WHERE passport_id = %s AND status IN ({})".format(
                ",".join(["%s"] * len(allowed_from))
            ),
            (new_status, passport_id, *allowed_from),
        )
        if not n:
            flash(
                f"Cannot set passport {passport_id} to {new_status} from its current status.",
                "error",
            )
        elif new_status == "processing":
            flash(
                f"Passport {passport_id}: documents marked verified (status → processing).",
                "success",
            )
        else:
            flash(f"Passport {passport_id} set to {new_status}.", "success")
    except MySQLError as e:
        flash(_mysql_message(e), "error")
    return _staff_redirect("passports")


@app.route("/staff/passport/<passport_id>/approve", methods=["POST"])
@login_required
@staff_required("supervisor")
def staff_passport_approve(passport_id):
    fee_paid = request.form.get("fee_paid") == "on"
    biometric = request.form.get("biometric_captured") == "on"
    if not fee_paid or not biometric:
        flash("Fee paid and biometric captured are both required to approve.", "error")
        return _staff_redirect("passports")
    current = db.query(
        "SELECT status FROM passport WHERE passport_id = %s",
        (passport_id,),
        one=True,
    )
    if not current:
        flash("Passport not found.", "error")
        return _staff_redirect("passports")
    if current["status"] not in ("pending", "processing"):
        flash(
            f"Passport {passport_id} is already {current['status']} — cannot approve.",
            "error",
        )
        return _staff_redirect("passports")
    try:
        db.callproc("sp_approve_passport", (passport_id, fee_paid, biometric))
        flash(f"Passport {passport_id} approved.", "success")
    except MySQLError as e:
        flash(_mysql_message(e), "error")
    return _staff_redirect("passports")


@app.route("/staff/visa/<int:visa_id>/status", methods=["POST"])
@login_required
@staff_required("supervisor")
def staff_visa_status(visa_id):
    new_status = request.form.get("status")
    if new_status not in ("approved", "rejected"):
        flash("Invalid status.", "error")
        return _staff_redirect("visas")
    try:
        n = db.execute(
            "UPDATE visa SET status = %s WHERE visa_id = %s AND status = 'pending'",
            (new_status, visa_id),
        )
        if not n:
            flash(
                f"Visa #{visa_id} is not pending — cannot change status.",
                "error",
            )
        else:
            flash(f"Visa #{visa_id} set to {new_status}.", "success")
    except MySQLError as e:
        flash(_mysql_message(e), "error")
    return _staff_redirect("visas")


@app.route("/eligibility")
def eligibility():
    return render_template("eligibility.html", user=session)


@app.errorhandler(404)
def not_found(_e):
    return render_template("error.html", code=404, title="Page not found", user=session), 404


@app.errorhandler(500)
def server_error(_e):
    return render_template("error.html", code=500, title="Something went wrong", user=session), 500


def create_app():
    secret = app.config.get("SECRET_KEY") or ""
    debug = os.getenv("FLASK_DEBUG", "0") == "1"
    if not debug and secret in WEAK_SECRETS:
        raise RuntimeError(
            "Set a strong SECRET_KEY in .env before running without FLASK_DEBUG=1."
        )
    return app


if __name__ == "__main__":
    create_app()
    debug = os.getenv("FLASK_DEBUG", "0") == "1"
    app.run(host="127.0.0.1", port=int(os.getenv("PORT", "5000")), debug=debug)
