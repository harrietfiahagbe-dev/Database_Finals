# NPIMS — National Passport and Immigration Management System

Flask + MySQL web app for the Phase 8 application layer.

## Setup

1. Install MySQL and create a user that can access database `NPIMS`.

2. Import the schema (tables, seeds, procedures, views, demo logins, and instructor ALTER/UPDATE query demos):

```bash
mysql -u root -p < NPIMS_DB.sql
```

The single `NPIMS_DB.sql` file is the full course script (includes intentional ALTER, UPDATE, DELETE, and SELECT demonstrations alongside Phase 8 `app_account` web logins).

Or run `NPIMS_DB.sql` in MySQL Workbench.

3. Copy env and configure:

```bash
copy .env.example .env
```

Set `MYSQL_PASSWORD` and a long random `SECRET_KEY` (not the example placeholder).

4. Install dependencies:

```bash
pip install -r requirements.txt
```

## Run (demo deploy)

Preferred for sharing on your LAN (Waitress, binds `0.0.0.0`):

```bash
python run.py
```

Open `http://127.0.0.1:5000/` on this machine, or `http://YOUR-LAN-IP:5000/` from classmates.

Dev-only (Flask reloader; set `FLASK_DEBUG=1` in `.env`):

```bash
python app.py
```

Without `FLASK_DEBUG=1`, a weak `SECRET_KEY` will refuse to start.

## Demo logins

Password for all seeded accounts: `password123`

| Type | Login ID | Notes |
|------|----------|--------|
| Citizen | `100000002` | Ama Boateng (email also works) |
| Citizen | `100000001` | Kwame Mensah |
| Staff (supervisor) | `1` | Kwame Mensah |
| Staff (senior officer) | `2` | Akosua Asare |
| Staff (officer) | `3` | Kofi Owusu |
| Staff (admin/director) | `30` | Beatrice Amankwah |

## Notes

- Payments are recorded via `sp_register_payment` (no live payment gateway).
- Travel logs go through `sp_log_travel_record`.
- Passport approval uses `sp_approve_passport` (supervisor+; fee/biometric checkboxes).
- Senior officers **verify** passports by setting status to `processing` before supervisor approval.
- Citizen dashboard summary stats come from `vw_citizen_summary`; detail tables query own rows by `nat_idcard`.
- Staff lists: `/staff/citizens`, `/staff/passports`, `/staff/visas`, `/staff/payments`, `/staff/travel` with search/filters.
- Admin CRUD: border posts and officers at `/staff/posts` and `/staff/officers` (new officers get `app_account` with `password123`).
- Public eligibility/fees page: `/eligibility`.

### Access control (Phase 8 vs Phase 7)

- **Phase 8 app:** one MySQL application user; roles enforced in Flask (`@staff_required`) from officer `position`.
- **Phase 7 schema:** MySQL roles (`citizen_role`, `officer_role`, …) and GRANTs remain for the database phase. This demo does **not** reconnect with dual MySQL role accounts.

### CRUD limits

- Citizens: staff read; supervisor+ may update email/address. No citizen delete (FK risk).
- Passports/visas/payments: no hard delete. Passport status path: pending → processing → approved/rejected (issued via existing data/procs).
- Border posts: delete only when no officer/travel FKs (MySQL error shown if blocked).
- Delete of citizens/passports/visas/payments is N/A where `RESTRICT` applies.
