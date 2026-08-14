DROP DATABASE IF EXISTS NPIMS;
CREATE DATABASE NPIMS CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE NPIMS;
SET NAMES utf8mb4;
create table citizen(
	nat_idcard int primary key,
	fname varchar (50) not null,
	lname varchar (50) not null,
	gender char(1),
	email varchar (100) unique,
	home_address varchar (100) not null
);

alter table citizen
add constraint check_gender check(gender in ('M','F'));

describe citizen;
insert into citizen 
values
(100000001, 'Kwame',    'Mensah',    'M', 'kwame.mensah@gmail.com',    'GA-492-8931'),
(100000002, 'Ama',      'Boateng',   'F', 'ama.boateng@gmail.com',     'GA-215-6602'),
(100000003, 'Kofi',     'Owusu',     'M', 'kofi.owusu@yahoo.com',      'AK-039-5817'),
(100000004, 'Akosua',   'Asante',    'F', 'akosua.asante@gmail.com',  'WP-104-2246'),
(100000005, 'Yaw',      'Appiah',    'M', null,                        'CP-077-9013'),
(100000006, 'Efua',     'Darko',     'F', 'efua.darko@outlook.com',    'BA-062-3358'),
(100000007, 'Kwabena',  'Osei',      'M', 'kwabena.osei@gmail.com',    'VR-018-7724'),
(100000008, 'Abena',    'Frimpong',  'F', 'abena.frimpong@gmail.com',  'NR-051-4409'),
(100000009, 'Kojo',     'Amponsah',  'M', 'kojo.amponsah@yahoo.com',   'GA-183-4021'),
(100000010, 'Adwoa',    'Gyasi',     'F', null,                        'GA-306-1187'),
(100000011, 'Kwesi',    'Baffour',   'M', 'kwesi.baffour@gmail.com',   'GA-441-9256'),
(100000012, 'Akua',     'Sarpong',   'F', 'akua.sarpong@gmail.com',    'AK-227-6630'),
(100000013, 'Kwaku',    'Antwi',     'M', 'kwaku.antwi@gmail.com',     'ER-095-3172'),
(100000014, 'Afua',     'Oduro',     'F', 'afua.oduro@outlook.com',    'UW-014-8845'),
(100000015, 'Nana',     'Yeboah',    'M', 'nana.yeboah@gmail.com',     'UE-028-5591'),
(100000016, 'Esi',      'Kusi',      'F', 'esi.kusi@gmail.com',        'GA-378-2264'),
(100000017, 'Kobby',    'Ansah',     'M', null,                        'GA-509-7738'),
(100000018, 'Yaa',      'Adjei',     'F', 'yaa.adjei@yahoo.com',       'CP-133-4460'),
(100000019, 'Kwadwo',   'Boadi',     'M', 'kwadwo.boadi@gmail.com',    'BA-201-9084'),
(100000020, 'Abenaa',   'Nkrumah',   'F', 'abenaa.nkrumah@gmail.com',  'GA-264-3315'),
(100000021, 'Kwame',    'Danso',     'M', 'kwame.danso@gmail.com',     'GA-350-6672'),
(100000022, 'Adjoa',    'Owusu',     'F', 'adjoa.owusu@gmail.com',     'AK-118-2249'),
(100000023, 'Kojo',     'Agyemang',  'M', 'kojo.agyemang@gmail.com',   'GA-467-8801'),
(100000024, 'Naa',      'Tetteh',    'F', 'naa.tetteh@gmail.com',      'GA-192-5536'),
(100000025, 'Kwabena',  'Fosu',      'M', null,                        'AK-076-1923'),
(100000026, 'Abena',    'Amoako',    'F', 'abena.amoako@yahoo.com',    'AK-243-7708'),
(100000027, 'Yaw',      'Kyei',      'M', 'yaw.kyei@gmail.com',        'CP-089-4415'),
(100000028, 'Akosua',   'Bediako',   'F', 'akosua.bediako@gmail.com',  'ER-156-6290'),
(100000029, 'Kwesi',    'Amankwah',  'M', 'kwesi.amankwah@gmail.com',  'BA-034-9967'),
(100000030, 'Adwoa',    'Sackey',    'F', 'adwoa.sackey@gmail.com',    'GA-411-2853');

select * from citizen ;
select count(*) from citizen;
select nat_idcard,fname
from citizen 
where gender ='F';

update citizen 
set home_address = "CR-756-9087"
where nat_idcard =100000030;

update citizen 
set email = "kwabena.fosu@gmail.com"
where fname="Kwabena" and lname = "Fosu";

ALTER TABLE citizen ADD COLUMN dob DATE NULL;

UPDATE citizen SET dob = '1990-03-15' WHERE nat_idcard = 100000001;
UPDATE citizen SET dob = '1992-07-22' WHERE nat_idcard = 100000002;
UPDATE citizen SET dob = '1988-11-08' WHERE nat_idcard = 100000003;
UPDATE citizen SET dob = '1995-01-30' WHERE nat_idcard = 100000004;
UPDATE citizen SET dob = '1991-06-12' WHERE nat_idcard = 100000010;
UPDATE citizen SET dob = '1987-09-03' WHERE nat_idcard = 100000005;
UPDATE citizen SET dob = '1993-12-18' WHERE nat_idcard = 100000006;
UPDATE citizen SET dob = '1986-05-27' WHERE nat_idcard = 100000007;
UPDATE citizen SET dob = '1994-08-14' WHERE nat_idcard = 100000008;
UPDATE citizen SET dob = '1989-02-21' WHERE nat_idcard = 100000009;
UPDATE citizen SET dob = '1991-11-05' WHERE nat_idcard = 100000011;
UPDATE citizen SET dob = '1985-07-30' WHERE nat_idcard = 100000012;
UPDATE citizen SET dob = '1996-04-09' WHERE nat_idcard = 100000013;
UPDATE citizen SET dob = '1990-10-16' WHERE nat_idcard = 100000014;
UPDATE citizen SET dob = '1988-01-25' WHERE nat_idcard = 100000015;
UPDATE citizen SET dob = '1992-03-08' WHERE nat_idcard = 100000016;
UPDATE citizen SET dob = '1997-06-22' WHERE nat_idcard = 100000017;
UPDATE citizen SET dob = '1993-09-11' WHERE nat_idcard = 100000018;
UPDATE citizen SET dob = '1989-12-04' WHERE nat_idcard = 100000019;
UPDATE citizen SET dob = '1991-05-19' WHERE nat_idcard = 100000020;
UPDATE citizen SET dob = '1987-08-07' WHERE nat_idcard = 100000021;
UPDATE citizen SET dob = '1994-02-28' WHERE nat_idcard = 100000022;
UPDATE citizen SET dob = '1986-11-13' WHERE nat_idcard = 100000023;
UPDATE citizen SET dob = '1992-07-01' WHERE nat_idcard = 100000024;
UPDATE citizen SET dob = '1995-04-17' WHERE nat_idcard = 100000025;
UPDATE citizen SET dob = '1990-01-09' WHERE nat_idcard = 100000026;
UPDATE citizen SET dob = '1988-06-24' WHERE nat_idcard = 100000027;
UPDATE citizen SET dob = '1993-10-31' WHERE nat_idcard = 100000028;
UPDATE citizen SET dob = '1996-08-15' WHERE nat_idcard = 100000029;
UPDATE citizen SET dob = '1991-12-20' WHERE nat_idcard = 100000030;

SELECT COUNT(*) FROM citizen WHERE dob IS NULL;

create table passport (
	passport_id varchar(20) unique primary key ,
	status varchar(20) not null default 'pending'
	       check (status in ('pending', 'processing' ,'approved' , 'issued', 'rejected')),
	passport_type varchar (50) not null default 'ordinary'
			check (passport_type in ('ordinary','official','diplomatic')),
	issue_date date,
	expiry_date date,
	check (expiry_date IS NULL OR issue_date IS NULL OR expiry_date > issue_date),
	nat_idcard int not null 
			   references citizen(nat_idcard)
			   on delete restrict
);

alter table passport 
modify column passport_id varchar(20) not null;



DELIMITER $$
CREATE TRIGGER trg_one_pending_passport
BEFORE INSERT ON Passport
FOR EACH ROW
BEGIN
    IF NEW.status IN ('pending', 'processing') THEN
        IF EXISTS (
            SELECT 1
            FROM Passport
            WHERE nat_idcard = NEW.nat_idcard
          	AND status IN ('pending', 'processing')
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            	'Citizen already has a passport being processed.';
        END IF;
    END IF;
END$$
DELIMITER ;


insert into passport
 values
('G0100001', 'issued',    'ordinary',    '2022-01-15', '2032-01-14', 100000001),
( 'G0100002', 'issued',    'ordinary',    '2021-03-22', '2031-03-21', 100000002),
( 'G0100003', 'issued',    'official',    '2020-06-10', '2025-06-09', 100000003),
( 'G0100004', 'issued',    'ordinary',    '2023-02-05', '2033-02-04', 100000004),
( 'G0100005', 'rejected',  'ordinary',    null,          null,         100000005),
( 'G0100006', 'issued',    'ordinary',    '2019-11-30', '2029-11-29', 100000006),
('G0100007', 'issued',    'diplomatic',  '2022-08-19', '2027-08-18', 100000007),
( 'G0100008', 'approved',  'ordinary',    null,          null,         100000008),
( 'G0100009', 'issued',    'ordinary',    '2021-12-01', '2031-11-30', 100000009),
('G0100010', 'pending',   'ordinary',    null,          null,         100000010),
( 'G0100011', 'issued',    'ordinary',    '2020-04-17', '2030-04-16', 100000011),
( 'G0100012', 'issued',    'official',    '2018-09-25', '2023-09-24', 100000012),
( 'G0100013', 'issued',    'ordinary',    '2023-05-14', '2033-05-13', 100000013),
( 'G0100014', 'processing','ordinary',    null,          null,         100000014),
('G0100015', 'issued',    'ordinary',    '2022-10-02', '2032-10-01', 100000015),
( 'G0100016', 'issued',    'ordinary',    '2021-07-08', '2031-07-07', 100000016),
( 'G0100017', 'rejected',  'ordinary',    null,          null,         100000017),
( 'G0100018', 'issued',    'diplomatic',  '2020-01-20', '2025-01-19', 100000018),
( 'G0100019', 'issued',    'ordinary',    '2023-03-11', '2033-03-10', 100000019),
( 'G0100020', 'approved',  'ordinary',    null,          null,         100000020),
( 'G0100021', 'issued',    'ordinary',    '2019-06-06', '2029-06-05', 100000021),
( 'G0100022', 'issued',    'official',    '2022-02-28', '2027-02-27', 100000022),
('G0100023', 'issued',    'ordinary',    '2016-03-01', '2021-02-28', 100000023),
( 'G0100023B','processing','ordinary',    null,          null,         100000023),
( 'G0100024', 'issued',    'ordinary',    '2021-09-09', '2031-09-08', 100000024),
( 'G0100025', 'pending',   'ordinary',    null,          null,         100000025),
( 'G0100026', 'issued',    'ordinary',    '2020-12-12', '2030-12-11', 100000026),
( 'G0100027', 'issued',    'diplomatic',  '2022-04-04', '2027-04-03', 100000027),
( 'G0100028', 'issued',    'ordinary',    '2023-01-01', '2033-01-01', 100000028),
( 'G0100029', 'rejected',  'ordinary',    null,          null,         100000029),
( 'G0100030', 'issued',    'ordinary',    '2021-05-19', '2031-05-18', 100000030);

select * from passport;

select count(*) from passport;

select passport_id from passport
where passport_type = "diplomatic";

update passport
set status = 'approved'
where passport_id = 'G0100023B';

update passport
set status = 'issued',
    issue_date = '2026-08-07',
    expiry_date = '2036-08-06'
where passport_id = 'G0100023B';

/*Border Post*/
CREATE TABLE Border_Post (
 post_id INT PRIMARY KEY, 
 border_name VARCHAR(50) NOT NULL UNIQUE, 
 post_type VARCHAR(50) NOT NULL CHECK (post_type IN ('air', 'land', 'sea')) ); 


ALTER TABLE Border_Post
ADD region VARCHAR(50);
describe Border_Post;

INSERT INTO Border_Post (post_id, border_name, post_type) VALUES
(1, 'Kotoka International Airport', 'air'),
(2, 'Kumasi International Airport', 'air'),
(3, 'Tamale International Airport', 'air'),
 (4, 'Ho Airport', 'air'),
(5, 'Sunyani Airport', 'air'),
(6, 'Takoradi Airport', 'air'),
(7, 'Aflao Border', 'land'),
(8, 'Elubo Border', 'land'),
(9, 'Paga Border', 'land'),
(10, 'Hamile Border', 'land'),
(11, 'Sampa Border', 'land'),
(12, 'Dorimon Border', 'land'),
(13, 'Tumu Border', 'land'),
(14, 'Bawku Border', 'land'),
(15, 'Kulungugu Border', 'land'),
(16, 'Half Assini Border', 'land'),
(17, 'Osienibra Border', 'land'),
(18, 'Leklebi-Duga Border', 'land'),
(19, 'Nkwanta Border', 'land'),
(20, 'Wa Border', 'land'),
(21, 'Krokosua Border', 'land'),
(22, 'Yendi Border', 'land'),
(23, 'Tema Port', 'sea'),
(24, 'Takoradi Port', 'sea'),
(25, 'Axim Port', 'sea'),
(26, 'Sinkon Border', 'land'), 
(27, 'Zebilla Border', 'land'), 
(28, 'Kete-Krachi Border', 'land'), 
(29, 'Ada Foah Port', 'sea'), 
(30, 'Ho Border Post', 'land'); 


UPDATE Border_Post SET region = 'Greater Accra' WHERE post_id = 1;  
UPDATE Border_Post SET region = 'Ashanti' WHERE post_id = 2; 
UPDATE Border_Post SET region = 'Northern' WHERE post_id = 3;
UPDATE Border_Post SET region = 'Volta' WHERE post_id = 4; 
UPDATE Border_Post SET region = 'Bono' WHERE post_id = 5; 
UPDATE Border_Post SET region = 'Western' WHERE post_id = 6; 
UPDATE Border_Post SET region = 'Volta' WHERE post_id = 7; 
UPDATE Border_Post SET region = 'Western' WHERE post_id = 8; 
UPDATE Border_Post SET region = 'Upper East' WHERE post_id = 9; 
UPDATE Border_Post SET region = 'Upper West' WHERE post_id = 10; 
UPDATE Border_Post SET region = 'Bono' WHERE post_id = 11; 
UPDATE Border_Post SET region = 'Upper West' WHERE post_id = 12; 
UPDATE Border_Post SET region = 'Upper West' WHERE post_id = 13; 
UPDATE Border_Post SET region = 'Upper East' WHERE post_id = 14; 
UPDATE Border_Post SET region = 'Upper East' WHERE post_id = 15; 
UPDATE Border_Post SET region = 'Western' WHERE post_id = 16; 
UPDATE Border_Post SET region = 'Volta' WHERE post_id = 17; 
UPDATE Border_Post SET region = 'Volta' WHERE post_id = 18; 
UPDATE Border_Post SET region = 'Oti' WHERE post_id = 19; 
UPDATE Border_Post SET region = 'Upper West' WHERE post_id = 20; 
UPDATE Border_Post SET region = 'Ahafo' WHERE post_id = 21;
UPDATE Border_Post SET region = 'Northern' WHERE post_id = 22; 
UPDATE Border_Post SET region = 'Greater Accra' WHERE post_id = 23; 
UPDATE Border_Post SET region = 'Western' WHERE post_id = 24; 
UPDATE Border_Post SET region = 'Western' WHERE post_id = 25; 
UPDATE Border_Post SET region = 'Upper West' WHERE post_id = 26; 
UPDATE Border_Post SET region = 'Upper East' WHERE post_id = 27; 
UPDATE Border_Post SET region = 'Oti' WHERE post_id = 28; 
UPDATE Border_Post SET region = 'Greater Accra' WHERE post_id = 29; 
UPDATE Border_Post SET region = 'Volta' WHERE post_id = 30; 




SELECT * FROM Border_Post; 
SELECT * FROM Border_Post WHERE post_id = 21;
SELECT * FROM Border_Post WHERE region IS NULL; 


/*Visa*/
create table Visa ( visa_id INT PRIMARY KEY, visa_type VARCHAR(30) NOT NULL,  passport_id varchar(20) not null, destination VARCHAR(30) NOT NULL, issue_date DATE NULL, expiry_date DATE NULL, status VARCHAR(30) NOT NULL DEFAULT 'pending', CONSTRAINT chk_visa_type CHECK (visa_type IN ('work', 'student', 'tourist', 'transit', 'diplomatic')), CONSTRAINT chk_visa_dates CHECK (expiry_date > issue_date), CONSTRAINT chk_visa_status CHECK (status IN ('pending', 'approved', 'rejected')), CONSTRAINT fk_visa_passport FOREIGN KEY (passport_id) REFERENCES Passport(passport_id) ON DELETE RESTRICT ON UPDATE CASCADE);

DELIMITER $$
 
CREATE TRIGGER trg_check_passport_validity_update
BEFORE UPDATE ON Visa
FOR EACH ROW
BEGIN
    DECLARE passport_expiry DATE;
 
    SELECT expiry_date
    INTO passport_expiry
    FROM Passport
    WHERE passport_id = NEW.passport_id;
 
    IF passport_expiry < DATE_ADD(NEW.issue_date, INTERVAL 6 MONTH) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Passport must be valid for at least 6 months from the visa issue date.';
    END IF;
END$$
 
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_check_passport_validity_insert
BEFORE INSERT ON Visa
FOR EACH ROW
BEGIN
    DECLARE passport_expiry DATE;
 
    IF NEW.issue_date IS NOT NULL THEN
        SELECT expiry_date
        INTO passport_expiry
        FROM Passport
        WHERE passport_id = NEW.passport_id;
 
        IF passport_expiry < DATE_ADD(NEW.issue_date, INTERVAL 6 MONTH) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Passport must be valid for at least 6 months from the visa issue date.';
        END IF;
    END IF;
END$$
DELIMITER ;

INSERT INTO Visa
VALUES
(1,  'tourist', 	'G0100001',  'United States', '2023-02-01', '2023-08-01', 'approved'), (2,  'student', 	'G0100002',  'Canada',    	'2022-08-15', '2026-08-14', 'approved'), (3,  'tourist', 	'G0100004',  'France',    	'2023-03-10', '2023-09-10', 'approved'), (4,  'work',    	'G0100006',  'United Kingdom','2021-01-20', '2024-01-20', 'approved'), (5,  'diplomatic',  'G0100007',  'Belgium',   	'2023-01-15', '2026-01-15', 'approved'), (6,  'tourist', 	'G0100009',  'South Africa',  '2022-05-10', '2022-11-10', 'approved'), (7,  'student',     'G0100011',  'Germany',   	'2021-06-01', '2025-06-01', 'approved'), (8,  'tourist', 	'G0100013',  'Kenya',     	'2023-07-15', '2024-01-15', 'approved'),(9,  'work',    	'G0100015',  'Qatar',     	'2023-02-20', '2025-02-20', 'approved'), (10, 'tourist',     'G0100016',  'Italy',     	'2022-09-01', '2023-03-01', 'approved'), (11, 'diplomatic',  'G0100018',  'Switzerland',   '2022-04-15', '2024-04-15', 'approved'), (12, 'tourist', 	'G0100019',  'Spain',     	'2023-05-20', '2023-11-20', 'approved'), (13, 'work',        'G0100021',  'United Arab Emirates','2021-10-10','2024-10-10','approved'), (14, 'diplomatic', 'G0100022', 'Nigeria', '2023-01-05', '2024-01-05', 'approved'), (15, 'tourist', 	'G0100024',  'Brazil',    	'2022-01-12', '2022-07-12', 'approved'), (16, 'student',     'G0100026',  'Australia', 	'2021-09-09', '2025-09-09', 'approved'), (17, 'diplomatic',  'G0100027',  'Ethiopia',  	'2023-06-18', '2026-06-18', 'approved'), (18, 'tourist', 	'G0100028',  'Morocco',   	'2023-03-15', '2023-09-15', 'approved'), (19, 'work',    	'G0100030',  'Japan',     	'2022-02-02', '2025-02-02', 'approved'), (20, 'tourist',     'G0100001',  'Togo',      	'2024-01-05', '2024-07-05', 'pending'), (21, 'work',        'G0100002',  'Ireland',   	'2024-03-15', '2027-03-15', 'pending'), (22, 'student', 	'G0100004',  'Netherlands',   '2024-05-01', '2028-05-01', 'pending'), (23, 'tourist', 	'G0100006',  'Egypt',     	'2023-08-12', '2024-02-12', 'rejected'), (24, 'tourist',     'G0100009',  'Singapore', 	'2024-01-18', '2024-07-18', 'pending'), (25, 'work',    	'G0100013',  'China',     	'2024-02-20', '2026-02-20', 'approved'), (26, 'student',     'G0100015',  'Malaysia',  	'2024-06-01', '2028-06-01', 'pending'), (27, 'tourist', 	'G0100019',  'Turkey',    	'2024-04-10', '2024-10-10', 'approved'), (28, 'work',        'G0100024',  'Norway',    	'2023-11-15', '2026-11-15', 'rejected'), (29, 'tourist',     'G0100028',  'India',     	'2024-02-05', '2024-08-05', 'pending'), (30, 'student',     'G0100030',  'United States', '2024-07-01', '2028-07-01', 'approved');

UPDATE Visa SET passport_id = 'G0100004' WHERE visa_id = 1;  
UPDATE Visa SET status = 'approved' WHERE visa_id = 20;


/*Immigration Officer*/
CREATE TABLE Immigration_Officer ( officer_id INT PRIMARY KEY, fname VARCHAR(30) NOT NULL, lname VARCHAR(30) NOT NULL, position VARCHAR(30) NOT NULL, phone_number VARCHAR(30) NOT NULL, post_id INT NOT NULL, CONSTRAINT chk_officer_position CHECK (position IN ('officer', 'senior officer', 'supervisor', 'director')), CONSTRAINT fk_officer_post FOREIGN KEY (post_id) REFERENCES Border_Post(post_id) ON DELETE RESTRICT ON UPDATE CASCADE );


INSERT INTO Immigration_Officer
(officer_id, fname, lname, position, phone_number, post_id)
VALUES (1,  'Kwame', 	'Mensah',   	'supervisor',	'0244001001', 1), (2,  'Akosua',    'Asare',    	'senior officer','0205001002', 2), (3,  'Kofi',  	'Owusu',    	'officer',   	'0556001003', 3), (4,  'Ama',       'Boateng',  	'officer',   	'0244001004', 4), (5,  'Yaw',       'Osei',     	'senior officer','0205001005', 5), (6,  'Abena', 	'Adjei',    	'officer',   	'0556001006', 6), (7,  'Kojo',      'Asante',   	'supervisor',	'0244001007', 7), (8,  'Esi',       'Amoah',    	'officer',   	'0205001008', 8), (9,  'Kwabena',   'Appiah',   	'senior officer','0556001009', 9), (10, 'Adwoa',     'Frimpong', 	'officer',   	'0244001010', 10), (11, 'Kwaku', 	'Darko',    	'officer',   	'0205001011', 11), (12, 'Akua',  	'Gyasi',    	'supervisor',	'0556001012', 12), (13, 'Fiifi', 	'Quaye',    	'officer',   	'0244001013', 13), (14, 'Mavis', 	'Addo',     	'senior officer','0205001014', 14), (15, 'Nana',  	'Agyemang', 	'officer',   	'0556001015', 15), (16, 'Michael',   'Tetteh',   	'officer',   	'0556001016', 16), (17, 'Joana', 	'Kusi',     	'supervisor',	'0244001017', 17), (18, 'Daniel',	'Acheampong',   'officer',   	'0205001018', 18), (19, 'Esther',	'Nkrumah',  	'senior officer','0556001019', 19), (20, 'Samuel',	'Antwi',    	'officer',   	'0244001020', 20),(21, 'Patricia',  'Asiedu',   	'officer',   	'0205001021', 21), (22, 'Emmanuel',  'Bonsu',    	'supervisor',	'0556001022', 22), (23, 'Richard',   'Arthur',   	'senior officer','0556001023', 23), (24, 'Linda', 	'Aidoo',    	'officer',   	'0244001024', 24), (25, 'George',	'Marfo',    	'officer',   	'0205001025', 25), (26, 'Priscilla', 'Sarpong',  	'supervisor',	'0556001026', 26), (27, 'Joseph',	'Baffour',  	'senior officer','0244001027', 27), (28, 'Grace', 	'Acheampong',   'officer',   	'0205001028', 28), (29, 'Martin',	'Ofori',    	'officer',   	'0556001029', 29), (30, 'Beatrice',  'Amankwah', 	'director',  	'0244001030', 30);

SELECT position, COUNT(officer_id) AS number_of_officers FROM Immigration_Officer GROUP BY position ORDER BY number_of_officers DESC;
SELECT  bp.border_name, COUNT(io.officer_id) AS officer_count FROM Border_Post bp JOIN Immigration_Officer io ON bp.post_id = io.post_id GROUP BY bp.post_id, bp.border_name HAVING COUNT(io.officer_id) > 1 ORDER BY officer_count DESC;
SELECT bp.border_name, bp.post_type, COUNT(io.officer_id) AS officer_count FROM Border_Post bp JOIN Immigration_Officer io ON bp.post_id = io.post_id GROUP BY bp.post_id, bp.border_name, bp.post_type ORDER BY officer_count DESC;
SELECT visa_type, COUNT(visa_id) AS number_of_visas FROM Visa GROUP BY visa_type ORDER BY number_of_visas DESC;
SELECT status, COUNT(visa_id) AS number_of_visas FROM Visa GROUP BY status ORDER BY number_of_visas DESC;

/*Phase 8 Flask login accounts (citizens + staff)*/
CREATE TABLE app_account (
  account_id INT AUTO_INCREMENT PRIMARY KEY,
  account_type ENUM('citizen', 'staff') NOT NULL,
  login_id VARCHAR(50) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  failed_attempts INT NOT NULL DEFAULT 0,
  locked_until DATETIME NULL
);

SET @pwd := 'scrypt:32768:8:1$yHkW9ja4eWf3q8p0$47dfc159e40de443855e05fb0fdc158105dc8ad3b1f18bb1785d17e1eeaa294397dc29ade8940d641305feca5a74d8b1db2750b662b892e1cc1ecd11162c6ac5';
INSERT INTO app_account (account_type, login_id, password_hash) VALUES
('citizen', '100000001', @pwd),
('citizen', '100000002', @pwd),
('citizen', '100000003', @pwd),
('citizen', '100000004', @pwd),
('citizen', '100000010', @pwd),
('staff', '1', @pwd),
('staff', '2', @pwd),
('staff', '3', @pwd),
('staff', '7', @pwd),
('staff', '30', @pwd);

CREATE TABLE payment ( payment_id INT PRIMARY KEY AUTO_INCREMENT, 
nat_idcard INT NOT NULL, 
passport_id VARCHAR(20) NULL, 
visa_id INT NULL, amount DECIMAL(10,2) NOT NULL CHECK (amount > 0), 
status VARCHAR(30) NOT NULL CHECK (status IN ('pending', 'completed', 'failed')) DEFAULT 'pending', 
payment_date DATE NOT NULL, payment_method VARCHAR(30) NOT NULL CHECK (payment_method IN ('mobile money','card','cash')),
 CHECK (passport_id IS NOT NULL OR visa_id IS NOT NULL), 
 FOREIGN KEY (nat_idcard) REFERENCES citizen(nat_idcard) ON DELETE RESTRICT, 
 FOREIGN KEY (passport_id) REFERENCES passport(passport_id) ON DELETE RESTRICT, 
 FOREIGN KEY (visa_id) REFERENCES visa(visa_id) ON DELETE RESTRICT );

describe payment;
INSERT INTO payment (nat_idcard, passport_id, visa_id, amount, status, payment_date, payment_method) VALUES
(100000001, 'G0100001', NULL, 150.00, 'completed', '2021-12-20', 'mobile money'),
(100000002, 'G0100002', NULL, 150.00, 'completed', '2021-03-01', 'card'),
(100000003, 'G0100003', NULL, 250.00, 'completed', '2020-05-25', 'cash'),
(100000004, 'G0100004', NULL, 150.00, 'completed', '2023-01-20', 'mobile money'),
(100000005, 'G0100005', NULL, 150.00, 'failed',    '2022-01-10', 'mobile money'),
(100000006, 'G0100006', NULL, 150.00, 'completed', '2019-11-15', 'card'),
(100000007, 'G0100007', NULL, 300.00, 'completed', '2022-08-01', 'card'),
(100000008, 'G0100008', NULL, 150.00, 'completed', '2023-06-10', 'mobile money'),
(100000009, 'G0100009', NULL, 150.00, 'completed', '2021-11-18', 'cash'),
(100000010, 'G0100010', NULL, 150.00, 'pending',   '2024-01-05', 'mobile money'),
(100000011, 'G0100011', NULL, 150.00, 'completed', '2020-04-01', 'card'),
(100000012, 'G0100012', NULL, 250.00, 'completed', '2018-09-10', 'cash'),
(100000013, 'G0100013', NULL, 150.00, 'completed', '2023-04-28', 'mobile money'),
(100000014, 'G0100014', NULL, 150.00, 'pending',   '2024-02-14', 'card'),
(100000015, 'G0100015', NULL, 150.00, 'completed', '2022-09-20', 'mobile money'),
(100000016, 'G0100016', NULL, 150.00, 'completed', '2021-06-25', 'cash'),
(100000017, 'G0100017', NULL, 150.00, 'failed',    '2023-11-01', 'mobile money'),
(100000018, 'G0100018', NULL, 300.00, 'completed', '2020-01-05', 'card'),
(100000019, 'G0100019', NULL, 150.00, 'completed', '2023-02-25', 'mobile money'),
(100000020, 'G0100020', NULL, 150.00, 'completed', '2023-12-01', 'card'),
(100000021, 'G0100021', NULL, 150.00, 'completed', '2019-05-20', 'cash'),
(100000022, 'G0100022', NULL, 250.00, 'completed', '2022-02-10', 'mobile money'),
(100000023, 'G0100023', NULL, 150.00, 'completed', '2016-02-15', 'card'),
(100000023, 'G0100023B', NULL, 150.00, 'pending',  '2024-03-01', 'mobile money'),
(100000024, 'G0100024', NULL, 150.00, 'completed', '2021-08-30', 'cash');

INSERT INTO payment (nat_idcard, passport_id, visa_id, amount, status, payment_date, payment_method) VALUES
(100000007, NULL, 5,  100.00, 'completed', '2023-01-10', 'card'),
(100000015, NULL, 9,  150.00, 'completed', '2023-02-15', 'mobile money'),
(100000018, NULL, 11, 200.00, 'completed', '2022-04-10', 'card'),
(100000027, NULL, 17, 150.00, 'completed', '2023-06-10', 'cash'),
(100000030, NULL, 19, 150.00, 'completed', '2022-01-28', 'mobile money');




Select * from payment;
Select * from payment where status = 'failed';
Select * from payment where payment_method = 'mobile money';
Select payment.payment_id, citizen.fname, citizen.lname, payment.amount, payment.status from payment join citizen on payment.nat_idcard = citizen.nat_idcard where payment.status = 'pending';
Select status, count(*) as Total from payment group by status;
Select payment_method, count(*) as Total from payment group by payment_method;
Select sum(amount) as Total_Mobile_Money from payment where payment_method = 'mobile money';









CREATE TABLE Travel_Record ( record_id INT PRIMARY KEY AUTO_INCREMENT, nat_idcard INT NOT NULL, passport_id VARCHAR(20) NOT NULL, post_id INT NOT NULL, officer_id INT NOT NULL, entry_exit VARCHAR(10) NOT NULL CHECK (entry_exit IN ('entry', 'exit')), `timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, destination_country VARCHAR(50) NOT NULL, FOREIGN KEY (nat_idcard) REFERENCES Citizen(nat_idcard), FOREIGN KEY (passport_id) REFERENCES Passport(passport_id), FOREIGN KEY (post_id) REFERENCES Border_Post(post_id), FOREIGN KEY (officer_id) REFERENCES Immigration_Officer(officer_id) ); 


ALTER TABLE Travel_Record 
ADD purpose_of_travel VARCHAR(50); 



INSERT INTO Travel_Record (nat_idcard, passport_id, post_id, officer_id, entry_exit, `timestamp`, destination_country, purpose_of_travel) VALUES
(100000001, 'G0100001', 1,  1,  'exit',  '2023-02-01 08:15:00', 'United States', 'tourism'),
(100000001, 'G0100001', 1,  1,  'entry', '2023-08-01 14:30:00', 'Ghana', 'return'),
(100000002, 'G0100002', 2,  2,  'exit',  '2022-08-15 09:00:00', 'Canada', 'education'),
(100000003, 'G0100003', 7,  7,  'exit',  '2020-06-12 07:45:00', 'Togo', 'official duty'),
(100000004, 'G0100004', 1,  1,  'exit',  '2023-03-10 11:20:00', 'France', 'tourism'),
(100000004, 'G0100004', 1,  1,  'entry', '2023-09-10 16:00:00', 'Ghana', 'return'),
(100000006, 'G0100006', 23, 23, 'exit',  '2021-01-22 06:30:00', 'United Kingdom', 'work'),
(100000007, 'G0100007', 1,  1,  'exit',  '2023-01-16 10:00:00', 'Belgium', 'diplomatic mission'),
(100000009, 'G0100009', 8,  8,  'exit',  '2022-05-11 13:10:00', 'South Africa', 'tourism'),
(100000009, 'G0100009', 8,  8,  'entry', '2022-11-11 18:45:00', 'Ghana', 'return'),
(100000011, 'G0100011', 1,  1,  'exit',  '2021-06-02 09:30:00', 'Germany', 'education'),
(100000013, 'G0100013', 1,  1,  'exit',  '2023-07-16 12:00:00', 'Kenya', 'tourism'),
(100000015, 'G0100015', 24, 24, 'exit',  '2023-02-21 05:50:00', 'Qatar', 'work'),
(100000016, 'G0100016', 1,  1,  'exit',  '2022-09-02 08:20:00', 'Italy', 'tourism'),
(100000018, 'G0100018', 1,  1,  'exit',  '2022-04-16 10:40:00', 'Switzerland', 'diplomatic mission'),
(100000019, 'G0100019', 1,  1,  'exit',  '2023-05-21 07:10:00', 'Spain', 'tourism'),
(100000021, 'G0100021', 9,  9,  'exit',  '2021-10-11 06:00:00', 'Nigeria', 'business'),
(100000022, 'G0100022', 9,  9,  'entry', '2023-01-06 15:30:00', 'Ghana', 'diplomatic mission'),
(100000024, 'G0100024', 23, 23, 'exit',  '2022-01-13 09:15:00', 'Brazil', 'tourism'),
(100000026, 'G0100026', 1,  1,  'exit',  '2021-09-10 11:00:00', 'Australia', 'education'),
(100000027, 'G0100027', 1,  1,  'exit',  '2023-06-19 13:45:00', 'Ethiopia', 'diplomatic mission'),
(100000028, 'G0100028', 8,  8,  'exit',  '2023-03-16 08:00:00', 'Morocco', 'tourism'),
(100000030, 'G0100030', 1,  1,  'exit',  '2022-02-03 09:30:00', 'Japan', 'work'),
(100000002, 'G0100002', 24, 24, 'exit',  '2024-03-16 10:00:00', 'Ireland', 'work'),
(100000004, 'G0100004', 1,  1,  'exit',  '2024-05-02 14:20:00', 'Netherlands', 'education'),
(100000009, 'G0100009', 25, 25, 'exit',  '2024-01-19 07:00:00', 'Singapore', 'tourism'),
(100000013, 'G0100013', 1,  1,  'exit',  '2024-02-21 12:30:00', 'China', 'business'),
(100000019, 'G0100019', 1,  1,  'exit',  '2024-04-11 09:00:00', 'Turkey', 'tourism'),
(100000028, 'G0100028', 8,  8,  'exit',  '2024-02-06 06:45:00', 'India', 'tourism'),
(100000030, 'G0100030', 1,  1,  'exit',  '2024-07-02 08:00:00', 'United States', 'education');



SELECT * FROM Travel_Record; 
SELECT COUNT(*) FROM Travel_Record; 
SELECT * FROM Travel_Record WHERE entry_exit = 'exit'; 



UPDATE Travel_Record 
SET purpose_of_travel = 'family visit' 
WHERE record_id = 3; 



DELETE FROM Travel_Record WHERE record_id = 30; 
SELECT COUNT(*) FROM Travel_Record; 




/*Displaying officers who logged more travel records than average
*/
select immigration_officer.officer_id, immigration_officer.fname, immigration_officer.lname, 
COUNT(travel_record.record_id) as records_logged
from immigration_officer
join travel_record on immigration_officer.officer_id = travel_record.officer_id
group by immigration_officer.officer_id, immigration_officer.fname, immigration_officer.lname
having count(travel_record.record_id)>(
select AVG(record_count)
from (select count(*) AS record_count from travel_record group by officer_id) AS officer_counts);

/*Displaying border posts, which are ranked by traffic volume*/
select border_post.post_id, border_post.border_name, COUNT(travel_record.record_id) AS 
total_crossings,
RANK() OVER (order by count(travel_record.record_id) DESC) AS traffic_rank
from border_post
join travel_record on border_post.post_id = travel_record.post_id
group by border_post.post_id, border_post.border_name;

/*Displaying total revenue collected per month*/
select DATE_FORMAT(payment_date, '%Y-%m') AS revenue_per_month, SUM(amount) AS total_revenue
FROM payment
where status = 'completed'
group by DATE_FORMAT(payment_date, '%Y-%m')
order by revenue_per_month;


/*Full citizen profile showing each citizen's name, current passport status, and total amount they've paid. */
SELECT Citizen.nat_idcard, Citizen.fname, Citizen.lname, Passport.status AS passport_status,
       COALESCE((SELECT SUM(amount) FROM Payment WHERE nat_idcard = Citizen.nat_idcard), 0) AS total_paid
FROM Citizen
LEFT JOIN Passport ON Citizen.nat_idcard = Passport.nat_idcard;

/*Citizens who registered in the system but have never applied for a passport.*/
 
SELECT Citizen.nat_idcard, Citizen.fname, Citizen.lname, Citizen.email 
FROM Citizen 
LEFT JOIN Passport ON Citizen.nat_idcard = Passport.nat_idcard 
WHERE Passport.passport_id IS NULL;

 /*Citizens who made a payment but whose passport has been pending for 30 or more days. */
SELECT Citizen.nat_idcard, Citizen.fname, Citizen.lname, Payment.amount, Payment.payment_date, Passport.status AS passport_status, 
DATEDIFF(CURDATE(), Payment.payment_date) AS days_since_payment 
FROM Citizen 
JOIN Payment ON Citizen.nat_idcard = Payment.nat_idcard 
JOIN Passport ON Citizen.nat_idcard = Passport.nat_idcard 
WHERE Passport.status = 'pending' 
AND Payment.status = 'completed' 
AND DATEDIFF(CURDATE(), Payment.payment_date) >= 30; 

/*6.Display passports expiring within the next 6 months */
select passport_id, nat_idcard, expiry_date
from passport
where expiry_date between curdate() and date_add(curdate(), interval 6 month);

/*7.Display visas linked to passports with less than 6 months validity */
select v.visa_id, v.visa_type, v.status, p.passport_id, p.expiry_date
from visa v
join passport p on v.passport_id = p.passport_id
where p.expiry_date < date_add(curdate(), interval 6 month);


/*8.Display citizens ranked by number of passports/visas held*/
select
    c.nat_idcard,
    c.fname,
    c.lname,
    count(distinct p.passport_id) as passport_count,
    count(distinct v.visa_id) as visa_count,
    rank() over (
        order by count(distinct p.passport_id) + count(distinct v.visa_id) desc
    ) as citizen_rank
from citizen c
left join passport p on c.nat_idcard = p.nat_idcard
left join visa v on p.passport_id = v.passport_id
group by c.nat_idcard, c.fname, c.lname;


/*VIEWS*/
/*A saved report that can be easilly pulled up showing each immigration officer with along with their name, position, 
how many travel records they have logged individually and how many different citizens they are processed.*/

create view vw_officer_performance AS
select immigration_officer.officer_id, immigration_officer.fname, immigration_officer.position,
COUNT(travel_record.record_id) AS total_records_logged,
COUNT(DISTINCT travel_record.nat_idcard) AS citizens_processed
from immigration_officer
left join travel_record on immigration_officer.officer_id = travel_record.officer_id
group by immigration_officer.officer_id, immigration_officer.fname, 
immigration_officer.lname, immigration_officer.position;

select * from vw_officer_performance;


Create view vw_border_traffic as 
select bp.post_id, bp.border_name, bp.post_type, 
count(tr.record_id) as total_travel_records 
from Border_Post bp 
left join Travel_Record tr 
on bp.post_id = tr.post_id 
group by bp.post_id, bp.border_name, bp.post_type;

select*from vw_border_traffic;

/*A saved report combining each citizen's name, passport status, and total amount paid, 
so it can be pulled up without rewriting the join every time. */
CREATE VIEW vw_citizen_summary AS
SELECT c.nat_idcard, c.fname, c.lname, p.status AS passport_status,
       COALESCE((SELECT SUM(amount) FROM Payment WHERE nat_idcard = c.nat_idcard), 0) AS total_paid
FROM Citizen c
LEFT JOIN Passport p ON c.nat_idcard = p.nat_idcard;

select * from vw_citizen_summary;
/*A saved report listing every payment record with its amount, status, date, and method, ordered by most recent first.*/

CREATE VIEW vw_payment_overview AS SELECT 
Payment.payment_id, Payment.nat_idcard, Payment.passport_id, Payment.amount, Payment.status, Payment.payment_date, Payment.payment_method
FROM Payment 
ORDER BY Payment.payment_date DESC;

select * from vw_payment_overview;









/*PROCEDURES*/
/*A safe way to log a border crossing, it checks that the passport being used hasn't expired, 
and only then records the entry or exit; if the passport is expired or doesn't exist,
 it blocks the record and returns an error instead.*/
DELIMITER //
CREATE PROCEDURE sp_log_travel_record (
    IN p_nat_idcard INT,
    IN p_passport_id VARCHAR(20) ,
    IN p_post_id INT,
    IN p_officer_id INT,
    IN p_entry_exit VARCHAR(10),
    IN p_destination_country VARCHAR(50))
BEGIN
    DECLARE v_expiry DATE;
    SELECT expiry_date INTO v_expiry
    FROM passport
    WHERE passport_id = p_passport_id;
    IF v_expiry IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Passport not found.';
    ELSEIF v_expiry < CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot log travel record: passport has expired.';
    ELSE
        INSERT INTO travel_record (nat_idcard, passport_id, post_id, officer_id, entry_exit, `timestamp`, destination_country)
        VALUES (p_nat_idcard, p_passport_id, p_post_id, p_officer_id, p_entry_exit, NOW(), p_destination_country);
    END IF;
END //
DELIMITER ;


/*A safe way to register a payment, it inserts the payment record, and if the amount matches the required fee,
 it automatically updates the linked passport's status to "processing." */
DELIMITER //

CREATE PROCEDURE sp_register_payment (
    IN p_nat_idcard INT,
    IN p_passport_id VARCHAR(20),
    IN p_visa_id INT,
    IN p_amount DECIMAL(10,2),
    IN p_status VARCHAR(20),
    IN p_payment_date DATE,
    IN p_payment_method VARCHAR(30)
)
BEGIN
    -- Enforce: a payment must be linked to a passport OR a visa, not neither
    IF p_passport_id IS NULL AND p_visa_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Payment must be linked to either a passport or a visa.';
    END IF;

    INSERT INTO Payment (nat_idcard, passport_id, visa_id, amount, status, payment_date, payment_method)
    VALUES (p_nat_idcard, p_passport_id, p_visa_id, p_amount, p_status, p_payment_date, p_payment_method);

    -- Only passport-linked payments trigger the passport status update
    IF p_passport_id IS NOT NULL AND p_status = 'completed' THEN
        UPDATE Passport
        SET status = 'processing'
        WHERE passport_id = p_passport_id
        AND status = 'pending';
    END IF;
END //

DELIMITER ;


DELIMITER //
CREATE PROCEDURE sp_approve_passport(
    IN p_passport_id VARCHAR(20),
    IN p_fee_paid BOOLEAN,
    IN p_biometric_captured BOOLEAN,
    IN p_issue_date DATE
)
BEGIN
    DECLARE v_ptype VARCHAR(50);
    DECLARE v_dob DATE;
    DECLARE v_years INT;
    DECLARE v_expiry DATE;
 
    IF p_fee_paid = TRUE AND p_biometric_captured = TRUE THEN
        IF p_issue_date < CURDATE() THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Issue date cannot be in the past.';
        END IF;
 
        SELECT p.passport_type, c.dob
        INTO v_ptype, v_dob
        FROM passport p
        JOIN citizen c ON p.nat_idcard = c.nat_idcard
        WHERE p.passport_id = p_passport_id;
 
        IF v_ptype IN ('diplomatic', 'official') THEN
            SET v_years = 5;
        ELSEIF v_dob IS NOT NULL AND TIMESTAMPDIFF(YEAR, v_dob, p_issue_date) < 12 THEN
            SET v_years = 5;
        ELSE
            SET v_years = 10;
        END IF;
 
        SET v_expiry = DATE_ADD(p_issue_date, INTERVAL v_years YEAR);
 
        UPDATE passport
        SET status = 'approved',
            issue_date = p_issue_date,
            expiry_date = v_expiry
        WHERE passport_id = p_passport_id;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Passport cannot be approved: fee not paid or biometric capture missing';
    END IF;
END //
DELIMITER ;







/*TRIGGERS*/


/*Automatically updates a passport's status to "processing" whenever its linked payment is 
updated to "completed", enforcing the payment-to-passport rule without anyone doing it manually. */
DELIMITER //
CREATE TRIGGER trg_payment_triggers_processing
AFTER UPDATE ON Payment
FOR EACH ROW
BEGIN
    IF NEW.status = 'completed' AND OLD.status <> 'completed' THEN
        UPDATE Passport
        SET status = 'processing'
        WHERE passport_id = NEW.passport_id;
    END IF;
END //
DELIMITER ;


/*Phase 7*/

DROP USER IF EXISTS
  'kwame.mensah'@'localhost',
  'akosua.asare'@'localhost',
  'kofi.owusu'@'localhost',
  'ama.boateng'@'localhost',
  'yaw.osei'@'localhost',
  'abena.adjei'@'localhost',
  'kojo.asante'@'localhost',
  'esi.amoah'@'localhost',
  'kwabena.appiah'@'localhost',
  'adwoa.frimpong'@'localhost',
  'kwaku.darko'@'localhost',
  'akua.gyasi'@'localhost',
  'fiifi.quaye'@'localhost',
  'mavis.addo'@'localhost',
  'nana.agyemang'@'localhost',
  'michael.tetteh'@'localhost',
  'joana.kusi'@'localhost',
  'daniel.acheampong'@'localhost',
  'esther.nkrumah'@'localhost',
  'samuel.antwi'@'localhost',
  'patricia.asiedu'@'localhost',
  'emmanuel.bonsu'@'localhost',
  'richard.arthur'@'localhost',
  'linda.aidoo'@'localhost',
  'george.marfo'@'localhost',
  'priscilla.sarpong'@'localhost',
  'joseph.baffour'@'localhost',
  'grace.acheampong'@'localhost',
  'martin.ofori'@'localhost',
  'beatrice.amankwah'@'localhost',
  'kwame.mensah.citizen'@'localhost',
  'ama.boateng.citizen'@'localhost',
  'kofi.owusu.citizen'@'localhost',
  'akosua.asante.citizen'@'localhost',
  'yaw.appiah.citizen'@'localhost',
  'efua.darko.citizen'@'localhost',
  'kwabena.osei.citizen'@'localhost',
  'abena.frimpong.citizen'@'localhost',
  'kojo.amponsah.citizen'@'localhost',
  'adwoa.gyasi.citizen'@'localhost',
  'kwesi.baffour.citizen'@'localhost',
  'akua.sarpong.citizen'@'localhost',
  'kwaku.antwi.citizen'@'localhost',
  'afua.oduro.citizen'@'localhost',
  'nana.yeboah.citizen'@'localhost',
  'esi.kusi.citizen'@'localhost',
  'kobby.ansah.citizen'@'localhost',
  'yaa.adjei.citizen'@'localhost',
  'kwadwo.boadi.citizen'@'localhost',
  'abenaa.nkrumah.citizen'@'localhost',
  'kwame.danso.citizen'@'localhost',
  'adjoa.owusu.citizen'@'localhost',
  'kojo.agyemang.citizen'@'localhost',
  'naa.tetteh.citizen'@'localhost',
  'kwabena.fosu.citizen'@'localhost',
  'abena.amoako.citizen'@'localhost',
  'yaw.kyei.citizen'@'localhost',
  'akosua.bediako.citizen'@'localhost',
  'kwesi.amankwah.citizen'@'localhost',
  'adwoa.sackey.citizen'@'localhost';

DROP ROLE IF EXISTS admin_role, supervisor_role, senior_officer_role, officer_role, citizen_role;

CREATE ROLE 'admin_role', 'supervisor_role', 'senior_officer_role', 'officer_role';

GRANT ALL PRIVILEGES ON NPIMS.* TO 'admin_role';

GRANT SELECT, INSERT, UPDATE ON NPIMS.passport TO 'supervisor_role';
GRANT SELECT, INSERT, UPDATE ON NPIMS.visa TO 'supervisor_role';
GRANT SELECT ON NPIMS.vw_officer_performance TO 'supervisor_role';
GRANT SELECT ON NPIMS.vw_citizen_summary TO 'supervisor_role';
GRANT EXECUTE ON PROCEDURE NPIMS.sp_approve_passport TO 'supervisor_role';

GRANT SELECT, INSERT ON NPIMS.travel_record TO 'senior_officer_role';
GRANT SELECT ON NPIMS.citizen TO 'senior_officer_role';
GRANT SELECT ON NPIMS.passport TO 'senior_officer_role';
GRANT SELECT ON NPIMS.visa TO 'senior_officer_role';
GRANT EXECUTE ON PROCEDURE NPIMS.sp_log_travel_record TO 'senior_officer_role';

GRANT SELECT ON NPIMS.citizen TO 'officer_role';
GRANT SELECT ON NPIMS.passport TO 'officer_role';
GRANT INSERT ON NPIMS.travel_record TO 'officer_role';

FLUSH PRIVILEGES;

/*CREATING ROLES FOR OFFICERS GENERAL
ALTERING THE IMM_OFF TABLE TO INCLUDE THE USERNAME FOR THE OFFICERS
*/

ALTER TABLE Immigration_Officer ADD COLUMN mysql_username VARCHAR(50);

/*Step 1c — Create all 30 login accounts + assign roles + link back*/

/*VERIFICATION THAT IT WORKED*/

SELECT officer_id, fname, lname, position, mysql_username FROM Immigration_Officer;

SELECT user, host FROM mysql.user WHERE user LIKE '%.%';

/*Proof RBAC actually works*/

-- mysql -u kofi.owusu -p

USE NPIMS;
UPDATE passport SET status = 'approved' WHERE passport_id = 'G0100001';

/*CREATING CITIZEN ROLE*/

CREATE ROLE 'citizen_role';

GRANT INSERT (passport_id, nat_idcard, passport_type, issue_date, expiry_date) 
ON NPIMS.passport TO 'citizen_role';

GRANT INSERT (visa_id, passport_id, visa_type, destination, issue_date, expiry_date) 
ON NPIMS.visa TO 'citizen_role';

GRANT INSERT (nat_idcard, passport_id, visa_id, amount, payment_date, payment_method) 
ON NPIMS.payment TO 'citizen_role';

GRANT SELECT ON NPIMS.vw_citizen_summary TO 'citizen_role';

FLUSH PRIVILEGES;

ALTER TABLE Citizen ADD COLUMN mysql_username VARCHAR(50);

/*adding under name to citizen coll*/


/*CREATING CITZEN ROLES BASED ON OUR DB*/

-- Should return EMPTY — confirms no username exists in both tables
SELECT c.mysql_username 
FROM Citizen c
INNER JOIN Immigration_Officer o ON c.mysql_username = o.mysql_username;

/*Step 4 — verify no citizen accidentally has an officer role too*/

CREATE USER 'kwame.mensah'@'localhost' IDENTIFIED BY 'KM01!Npims26';
GRANT 'supervisor_role' TO 'kwame.mensah'@'localhost';
SET DEFAULT ROLE 'supervisor_role' TO 'kwame.mensah'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'kwame.mensah' WHERE officer_id = 1;

CREATE USER 'akosua.asare'@'localhost' IDENTIFIED BY 'AA02!Npims26';
GRANT 'senior_officer_role' TO 'akosua.asare'@'localhost';
SET DEFAULT ROLE 'senior_officer_role' TO 'akosua.asare'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'akosua.asare' WHERE officer_id = 2;

CREATE USER 'kofi.owusu'@'localhost' IDENTIFIED BY 'KO03!Npims26';
GRANT 'officer_role' TO 'kofi.owusu'@'localhost';
SET DEFAULT ROLE 'officer_role' TO 'kofi.owusu'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'kofi.owusu' WHERE officer_id = 3;

CREATE USER 'ama.boateng'@'localhost' IDENTIFIED BY 'AB04!Npims26';
GRANT 'officer_role' TO 'ama.boateng'@'localhost';
SET DEFAULT ROLE 'officer_role' TO 'ama.boateng'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'ama.boateng' WHERE officer_id = 4;

CREATE USER 'yaw.osei'@'localhost' IDENTIFIED BY 'YO05!Npims26';
GRANT 'senior_officer_role' TO 'yaw.osei'@'localhost';
SET DEFAULT ROLE 'senior_officer_role' TO 'yaw.osei'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'yaw.osei' WHERE officer_id = 5;

CREATE USER 'abena.adjei'@'localhost' IDENTIFIED BY 'AA06!Npims26';
GRANT 'officer_role' TO 'abena.adjei'@'localhost';
SET DEFAULT ROLE 'officer_role' TO 'abena.adjei'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'abena.adjei' WHERE officer_id = 6;

CREATE USER 'kojo.asante'@'localhost' IDENTIFIED BY 'KA07!Npims26';
GRANT 'supervisor_role' TO 'kojo.asante'@'localhost';
SET DEFAULT ROLE 'supervisor_role' TO 'kojo.asante'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'kojo.asante' WHERE officer_id = 7;

CREATE USER 'esi.amoah'@'localhost' IDENTIFIED BY 'EA08!Npims26';
GRANT 'officer_role' TO 'esi.amoah'@'localhost';
SET DEFAULT ROLE 'officer_role' TO 'esi.amoah'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'esi.amoah' WHERE officer_id = 8;

CREATE USER 'kwabena.appiah'@'localhost' IDENTIFIED BY 'KA09!Npims26';
GRANT 'senior_officer_role' TO 'kwabena.appiah'@'localhost';
SET DEFAULT ROLE 'senior_officer_role' TO 'kwabena.appiah'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'kwabena.appiah' WHERE officer_id = 9;

CREATE USER 'adwoa.frimpong'@'localhost' IDENTIFIED BY 'AF10!Npims26';
GRANT 'officer_role' TO 'adwoa.frimpong'@'localhost';
SET DEFAULT ROLE 'officer_role' TO 'adwoa.frimpong'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'adwoa.frimpong' WHERE officer_id = 10;

CREATE USER 'kwaku.darko'@'localhost' IDENTIFIED BY 'KD11!Npims26';
GRANT 'officer_role' TO 'kwaku.darko'@'localhost';
SET DEFAULT ROLE 'officer_role' TO 'kwaku.darko'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'kwaku.darko' WHERE officer_id = 11;

CREATE USER 'akua.gyasi'@'localhost' IDENTIFIED BY 'AG12!Npims26';
GRANT 'supervisor_role' TO 'akua.gyasi'@'localhost';
SET DEFAULT ROLE 'supervisor_role' TO 'akua.gyasi'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'akua.gyasi' WHERE officer_id = 12;

CREATE USER 'fiifi.quaye'@'localhost' IDENTIFIED BY 'FQ13!Npims26';
GRANT 'officer_role' TO 'fiifi.quaye'@'localhost';
SET DEFAULT ROLE 'officer_role' TO 'fiifi.quaye'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'fiifi.quaye' WHERE officer_id = 13;

CREATE USER 'mavis.addo'@'localhost' IDENTIFIED BY 'MA14!Npims26';
GRANT 'senior_officer_role' TO 'mavis.addo'@'localhost';
SET DEFAULT ROLE 'senior_officer_role' TO 'mavis.addo'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'mavis.addo' WHERE officer_id = 14;

CREATE USER 'nana.agyemang'@'localhost' IDENTIFIED BY 'NA15!Npims26';
GRANT 'officer_role' TO 'nana.agyemang'@'localhost';
SET DEFAULT ROLE 'officer_role' TO 'nana.agyemang'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'nana.agyemang' WHERE officer_id = 15;

CREATE USER 'michael.tetteh'@'localhost' IDENTIFIED BY 'MT16!Npims26';
GRANT 'officer_role' TO 'michael.tetteh'@'localhost';
SET DEFAULT ROLE 'officer_role' TO 'michael.tetteh'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'michael.tetteh' WHERE officer_id = 16;

CREATE USER 'joana.kusi'@'localhost' IDENTIFIED BY 'JK17!Npims26';
GRANT 'supervisor_role' TO 'joana.kusi'@'localhost';
SET DEFAULT ROLE 'supervisor_role' TO 'joana.kusi'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'joana.kusi' WHERE officer_id = 17;

CREATE USER 'daniel.acheampong'@'localhost' IDENTIFIED BY 'DA18!Npims26';
GRANT 'officer_role' TO 'daniel.acheampong'@'localhost';
SET DEFAULT ROLE 'officer_role' TO 'daniel.acheampong'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'daniel.acheampong' WHERE officer_id = 18;

CREATE USER 'esther.nkrumah'@'localhost' IDENTIFIED BY 'EN19!Npims26';
GRANT 'senior_officer_role' TO 'esther.nkrumah'@'localhost';
SET DEFAULT ROLE 'senior_officer_role' TO 'esther.nkrumah'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'esther.nkrumah' WHERE officer_id = 19;

CREATE USER 'samuel.antwi'@'localhost' IDENTIFIED BY 'SA20!Npims26';
GRANT 'officer_role' TO 'samuel.antwi'@'localhost';
SET DEFAULT ROLE 'officer_role' TO 'samuel.antwi'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'samuel.antwi' WHERE officer_id = 20;

CREATE USER 'patricia.asiedu'@'localhost' IDENTIFIED BY 'PA21!Npims26';
GRANT 'officer_role' TO 'patricia.asiedu'@'localhost';
SET DEFAULT ROLE 'officer_role' TO 'patricia.asiedu'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'patricia.asiedu' WHERE officer_id = 21;

CREATE USER 'emmanuel.bonsu'@'localhost' IDENTIFIED BY 'EB22!Npims26';
GRANT 'supervisor_role' TO 'emmanuel.bonsu'@'localhost';
SET DEFAULT ROLE 'supervisor_role' TO 'emmanuel.bonsu'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'emmanuel.bonsu' WHERE officer_id = 22;

CREATE USER 'richard.arthur'@'localhost' IDENTIFIED BY 'RA23!Npims26';
GRANT 'senior_officer_role' TO 'richard.arthur'@'localhost';
SET DEFAULT ROLE 'senior_officer_role' TO 'richard.arthur'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'richard.arthur' WHERE officer_id = 23;

CREATE USER 'linda.aidoo'@'localhost' IDENTIFIED BY 'LA24!Npims26';
GRANT 'officer_role' TO 'linda.aidoo'@'localhost';
SET DEFAULT ROLE 'officer_role' TO 'linda.aidoo'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'linda.aidoo' WHERE officer_id = 24;

CREATE USER 'george.marfo'@'localhost' IDENTIFIED BY 'GM25!Npims26';
GRANT 'officer_role' TO 'george.marfo'@'localhost';
SET DEFAULT ROLE 'officer_role' TO 'george.marfo'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'george.marfo' WHERE officer_id = 25;

CREATE USER 'priscilla.sarpong'@'localhost' IDENTIFIED BY 'PS26!Npims26';
GRANT 'supervisor_role' TO 'priscilla.sarpong'@'localhost';
SET DEFAULT ROLE 'supervisor_role' TO 'priscilla.sarpong'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'priscilla.sarpong' WHERE officer_id = 26;

CREATE USER 'joseph.baffour'@'localhost' IDENTIFIED BY 'JB27!Npims26';
GRANT 'senior_officer_role' TO 'joseph.baffour'@'localhost';
SET DEFAULT ROLE 'senior_officer_role' TO 'joseph.baffour'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'joseph.baffour' WHERE officer_id = 27;

CREATE USER 'grace.acheampong'@'localhost' IDENTIFIED BY 'GA28!Npims26';
GRANT 'officer_role' TO 'grace.acheampong'@'localhost';
SET DEFAULT ROLE 'officer_role' TO 'grace.acheampong'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'grace.acheampong' WHERE officer_id = 28;

CREATE USER 'martin.ofori'@'localhost' IDENTIFIED BY 'MO29!Npims26';
GRANT 'officer_role' TO 'martin.ofori'@'localhost';
SET DEFAULT ROLE 'officer_role' TO 'martin.ofori'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'martin.ofori' WHERE officer_id = 29;

CREATE USER 'beatrice.amankwah'@'localhost' IDENTIFIED BY 'BA30!Npims26';
GRANT 'admin_role' TO 'beatrice.amankwah'@'localhost';
SET DEFAULT ROLE 'admin_role' TO 'beatrice.amankwah'@'localhost';
UPDATE Immigration_Officer SET mysql_username = 'beatrice.amankwah' WHERE officer_id = 30;

/*IMMIGRATION OFFICERS ROLES*/

CREATE USER 'kwame.mensah.citizen'@'localhost' IDENTIFIED BY 'KM0001#Npims26';
GRANT 'citizen_role' TO 'kwame.mensah.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'kwame.mensah.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'kwame.mensah.citizen' WHERE nat_idcard = 100000001;

CREATE USER 'ama.boateng.citizen'@'localhost' IDENTIFIED BY 'AB0002#Npims26';
GRANT 'citizen_role' TO 'ama.boateng.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'ama.boateng.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'ama.boateng.citizen' WHERE nat_idcard = 100000002;

CREATE USER 'kofi.owusu.citizen'@'localhost' IDENTIFIED BY 'KO0003#Npims26';
GRANT 'citizen_role' TO 'kofi.owusu.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'kofi.owusu.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'kofi.owusu.citizen' WHERE nat_idcard = 100000003;

CREATE USER 'akosua.asante.citizen'@'localhost' IDENTIFIED BY 'AA0004#Npims26';
GRANT 'citizen_role' TO 'akosua.asante.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'akosua.asante.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'akosua.asante.citizen' WHERE nat_idcard = 100000004;

CREATE USER 'yaw.appiah.citizen'@'localhost' IDENTIFIED BY 'YA0005#Npims26';
GRANT 'citizen_role' TO 'yaw.appiah.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'yaw.appiah.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'yaw.appiah.citizen' WHERE nat_idcard = 100000005;

CREATE USER 'efua.darko.citizen'@'localhost' IDENTIFIED BY 'ED0006#Npims26';
GRANT 'citizen_role' TO 'efua.darko.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'efua.darko.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'efua.darko.citizen' WHERE nat_idcard = 100000006;

CREATE USER 'kwabena.osei.citizen'@'localhost' IDENTIFIED BY 'KO0007#Npims26';
GRANT 'citizen_role' TO 'kwabena.osei.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'kwabena.osei.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'kwabena.osei.citizen' WHERE nat_idcard = 100000007;

CREATE USER 'abena.frimpong.citizen'@'localhost' IDENTIFIED BY 'AF0008#Npims26';
GRANT 'citizen_role' TO 'abena.frimpong.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'abena.frimpong.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'abena.frimpong.citizen' WHERE nat_idcard = 100000008;

CREATE USER 'kojo.amponsah.citizen'@'localhost' IDENTIFIED BY 'KA0009#Npims26';
GRANT 'citizen_role' TO 'kojo.amponsah.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'kojo.amponsah.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'kojo.amponsah.citizen' WHERE nat_idcard = 100000009;

CREATE USER 'adwoa.gyasi.citizen'@'localhost' IDENTIFIED BY 'AG0010#Npims26';
GRANT 'citizen_role' TO 'adwoa.gyasi.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'adwoa.gyasi.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'adwoa.gyasi.citizen' WHERE nat_idcard = 100000010;

CREATE USER 'kwesi.baffour.citizen'@'localhost' IDENTIFIED BY 'KB0011#Npims26';
GRANT 'citizen_role' TO 'kwesi.baffour.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'kwesi.baffour.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'kwesi.baffour.citizen' WHERE nat_idcard = 100000011;

CREATE USER 'akua.sarpong.citizen'@'localhost' IDENTIFIED BY 'AS0012#Npims26';
GRANT 'citizen_role' TO 'akua.sarpong.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'akua.sarpong.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'akua.sarpong.citizen' WHERE nat_idcard = 100000012;

CREATE USER 'kwaku.antwi.citizen'@'localhost' IDENTIFIED BY 'KA0013#Npims26';
GRANT 'citizen_role' TO 'kwaku.antwi.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'kwaku.antwi.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'kwaku.antwi.citizen' WHERE nat_idcard = 100000013;

CREATE USER 'afua.oduro.citizen'@'localhost' IDENTIFIED BY 'AO0014#Npims26';
GRANT 'citizen_role' TO 'afua.oduro.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'afua.oduro.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'afua.oduro.citizen' WHERE nat_idcard = 100000014;

CREATE USER 'nana.yeboah.citizen'@'localhost' IDENTIFIED BY 'NY0015#Npims26';
GRANT 'citizen_role' TO 'nana.yeboah.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'nana.yeboah.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'nana.yeboah.citizen' WHERE nat_idcard = 100000015;

CREATE USER 'esi.kusi.citizen'@'localhost' IDENTIFIED BY 'EK0016#Npims26';
GRANT 'citizen_role' TO 'esi.kusi.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'esi.kusi.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'esi.kusi.citizen' WHERE nat_idcard = 100000016;

CREATE USER 'kobby.ansah.citizen'@'localhost' IDENTIFIED BY 'KA0017#Npims26';
GRANT 'citizen_role' TO 'kobby.ansah.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'kobby.ansah.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'kobby.ansah.citizen' WHERE nat_idcard = 100000017;

CREATE USER 'yaa.adjei.citizen'@'localhost' IDENTIFIED BY 'YA0018#Npims26';
GRANT 'citizen_role' TO 'yaa.adjei.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'yaa.adjei.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'yaa.adjei.citizen' WHERE nat_idcard = 100000018;

CREATE USER 'kwadwo.boadi.citizen'@'localhost' IDENTIFIED BY 'KB0019#Npims26';
GRANT 'citizen_role' TO 'kwadwo.boadi.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'kwadwo.boadi.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'kwadwo.boadi.citizen' WHERE nat_idcard = 100000019;

CREATE USER 'abenaa.nkrumah.citizen'@'localhost' IDENTIFIED BY 'AN0020#Npims26';
GRANT 'citizen_role' TO 'abenaa.nkrumah.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'abenaa.nkrumah.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'abenaa.nkrumah.citizen' WHERE nat_idcard = 100000020;

CREATE USER 'kwame.danso.citizen'@'localhost' IDENTIFIED BY 'KD0021#Npims26';
GRANT 'citizen_role' TO 'kwame.danso.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'kwame.danso.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'kwame.danso.citizen' WHERE nat_idcard = 100000021;

CREATE USER 'adjoa.owusu.citizen'@'localhost' IDENTIFIED BY 'AO0022#Npims26';
GRANT 'citizen_role' TO 'adjoa.owusu.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'adjoa.owusu.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'adjoa.owusu.citizen' WHERE nat_idcard = 100000022;

CREATE USER 'kojo.agyemang.citizen'@'localhost' IDENTIFIED BY 'KA0023#Npims26';
GRANT 'citizen_role' TO 'kojo.agyemang.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'kojo.agyemang.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'kojo.agyemang.citizen' WHERE nat_idcard = 100000023;

CREATE USER 'naa.tetteh.citizen'@'localhost' IDENTIFIED BY 'NT0024#Npims26';
GRANT 'citizen_role' TO 'naa.tetteh.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'naa.tetteh.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'naa.tetteh.citizen' WHERE nat_idcard = 100000024;

CREATE USER 'kwabena.fosu.citizen'@'localhost' IDENTIFIED BY 'KF0025#Npims26';
GRANT 'citizen_role' TO 'kwabena.fosu.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'kwabena.fosu.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'kwabena.fosu.citizen' WHERE nat_idcard = 100000025;

CREATE USER 'abena.amoako.citizen'@'localhost' IDENTIFIED BY 'AA0026#Npims26';
GRANT 'citizen_role' TO 'abena.amoako.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'abena.amoako.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'abena.amoako.citizen' WHERE nat_idcard = 100000026;

CREATE USER 'yaw.kyei.citizen'@'localhost' IDENTIFIED BY 'YK0027#Npims26';
GRANT 'citizen_role' TO 'yaw.kyei.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'yaw.kyei.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'yaw.kyei.citizen' WHERE nat_idcard = 100000027;

CREATE USER 'akosua.bediako.citizen'@'localhost' IDENTIFIED BY 'AB0028#Npims26';
GRANT 'citizen_role' TO 'akosua.bediako.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'akosua.bediako.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'akosua.bediako.citizen' WHERE nat_idcard = 100000028;

CREATE USER 'kwesi.amankwah.citizen'@'localhost' IDENTIFIED BY 'KA0029#Npims26';
GRANT 'citizen_role' TO 'kwesi.amankwah.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'kwesi.amankwah.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'kwesi.amankwah.citizen' WHERE nat_idcard = 100000029;

CREATE USER 'adwoa.sackey.citizen'@'localhost' IDENTIFIED BY 'AS0030#Npims26';
GRANT 'citizen_role' TO 'adwoa.sackey.citizen'@'localhost';
SET DEFAULT ROLE 'citizen_role' TO 'adwoa.sackey.citizen'@'localhost';
UPDATE Citizen SET mysql_username = 'adwoa.sackey.citizen' WHERE nat_idcard = 100000030;

FLUSH PRIVILEGES;

/*CITIZEN ROLES*/

SELECT user, COUNT(*) FROM mysql.user WHERE user LIKE '%.%' GROUP BY user HAVING COUNT(*) > 1;
-- should return EMPTY — confirms no duplicate usernames anywhere

/*CHECKING TO SEE IF ALL ARE UNIQUE ACROSS ALL THE 60 ROLES*/

/*BACKUP AND RECOVERY*/

-- mysqldump -u root -p NPIMS > npims_backup_2026-08-10.sql

-- TAKING A FULL BACKUP ON NPIMS

-- ls -lh npims_backup_2026-08-10.sql

SHOW DATABASES;

/*RESTORING IT/ RECOVERY PROCESS*/

-- mysql -u root -p -e "CREATE DATABASE NPIMS;"
-- mysql -u root -p NPIMS < npims_backup_2026-08-10.sql

USE NPIMS;
SELECT COUNT(*) FROM citizen;      -- should return 30
SELECT COUNT(*) FROM passport;     -- should return 31
SELECT COUNT(*) FROM visa;         -- should return 30
SELECT COUNT(*) FROM payment;      -- should return 30
SELECT COUNT(*) FROM travel_record; -- should return 29 (you deleted record_id 30 earlier)
SELECT COUNT(*) FROM app_account;  -- should return 10 demo logins
SHOW TABLES;
SELECT * FROM vw_citizen_summary LIMIT 5;

/*CHECKING IF EVERYTHING IS THERE */














