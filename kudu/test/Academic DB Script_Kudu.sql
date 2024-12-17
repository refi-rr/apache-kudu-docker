/*
DROP TABLE AD_STUDENT_ATTENDANCE;
DROP TABLE AD_STUDENT_COURSE_DETAILS;
DROP TABLE AD_FACULTY_LOGIN_DETAILS;
DROP TABLE AD_FACULTY_COURSE_DETAILS;
DROP TABLE AD_EXAM_RESULTS;
DROP TABLE AD_EXAMS;
DROP TABLE AD_EXAM_TYPES;
DROP TABLE AD_FACULTY;
DROP TABLE AD_STUDENTS;
DROP TABLE AD_PARENT_INFORMATION;
DROP TABLE AD_COURSES;
DROP TABLE AD_ACADEMIC_SESSIONS;
DROP TABLE AD_DEPARTMENTS;
*/


CREATE TABLE AD_ACADEMIC_SESSIONS
(
  ID   		INTEGER,
  NAME 		STRING NOT NULL
, PRIMARY KEY (ID)
) 
STORED AS KUDU
TBLPROPERTIES (

  'kudu.num_tablet_replicas' = '3'
);

CREATE TABLE AD_DEPARTMENTS
  (
    ID         		INTEGER ,
    NAME       		STRING NOT NULL,
    HEAD       		STRING NOT NULL
, PRIMARY KEY (ID))
STORED AS KUDU
TBLPROPERTIES (

  'kudu.num_tablet_replicas' = '3'
);

CREATE TABLE AD_PARENT_INFORMATION
  (
    ID   		INTEGER,
    PARENT1_FN        	STRING NOT NULL,
    PARENT1_LN 		STRING NOT NULL,
    PARENT2_FN 		STRING ,
    PARENT2_LN 		STRING
  , PRIMARY KEY (ID)) STORED AS KUDU
TBLPROPERTIES (

  'kudu.num_tablet_replicas' = '3'
);

CREATE TABLE AD_STUDENTS
  (
     ID            	INTEGER ,
     FIRST_NAME         STRING NOT NULL ,
     LAST_NAME         	STRING NOT NULL ,
     REG_YEAR      	DATE NOT NULL,
     EMAIL		STRING NOT NULL,
     PARENT_ID          INTEGER NOT NULL
  , PRIMARY KEY (ID)) STORED AS KUDU
TBLPROPERTIES (

  'kudu.num_tablet_replicas' = '3'
);

CREATE TABLE AD_COURSES
  ( 
    ID       		INTEGER,
    NAME      		STRING NOT NULL ,
    SESSION_ID      	INTEGER  NOT NULL ,
    DEPT_ID          	INTEGER ,
    LOGON_ID         	STRING,
    PASSWORD         	STRING ,
    BUILDING		STRING ,
    ROOM		STRING,
    DATE_TIME          	STRING
  , PRIMARY KEY (ID)) STORED AS KUDU
TBLPROPERTIES (

  'kudu.num_tablet_replicas' = '3'
);


CREATE TABLE AD_FACULTY
  (
    ID        	        INTEGER ,
    FIRST_NAME        	STRING NOT NULL ,
    LAST_NAME      	STRING NOT NULL,
    EMAIL          	STRING NOT NULL,
    SALARY           	INTEGER,
    INSURANCE         	string,
    HOURLY_RATE       	INTEGER,
    DEPT_ID           	INTEGER
  , PRIMARY KEY (ID)) STORED AS KUDU ;


CREATE TABLE AD_EXAM_TYPES
  (
    TYPE         	STRING ,
    NAME         	STRING NOT NULL ,
    DESCRIPTION      	STRING

  , PRIMARY KEY (TYPE)) STORED AS KUDU
TBLPROPERTIES (

  'kudu.num_tablet_replicas' = '3'
);

-- Probando Particionado. Debe estar siempre dentro de la clave primaria y además debe estár adelante.
CREATE TABLE AD_EXAMS
  (
    ID      		INTEGER ,
    EXAM_TYPE    	STRING NOT NULL ,
    START_DATE   	DATE ,
    COURSE_ID    	INTEGER  NOT NULL
   , PRIMARY KEY (ID,EXAM_TYPE))
   PARTITION BY HASH (EXAM_TYPE) PARTITIONS 2
   STORED AS KUDU   
;

CREATE TABLE AD_EXAM_RESULTS
  (
     STUDENT_ID        	INTEGER ,
     COURSE_ID         	INTEGER ,
     EXAM_ID           	INTEGER ,
     EXAM_GRADE       	INTEGER NOT NULL   
  , PRIMARY KEY ( STUDENT_ID, COURSE_ID, EXAM_ID )
  ) PARTITION BY HASH (EXAM_ID) PARTITIONS 3
  STORED AS KUDU ;



CREATE TABLE AD_STUDENT_ATTENDANCE
  (
     STUDENT_ID         INTEGER ,
     SESSION_ID		INTEGER ,
     NUM_WORK_DAYS   	INTEGER NOT NULL,
     NUM_DAYS_OFF      	INTEGER NOT NULL,
     EXAM_ELIGIBILITY 	STRING 
  , PRIMARY KEY ( STUDENT_ID, SESSION_ID)
  ) STORED AS KUDU
TBLPROPERTIES (

  'kudu.num_tablet_replicas' = '3'
);


CREATE TABLE AD_STUDENT_COURSE_DETAILS
  (
     STUDENT_ID        	INTEGER ,
     COURSE_ID        	INTEGER ,
     GRADE		STRING NOT NULL
  , PRIMARY KEY ( STUDENT_ID, COURSE_ID )
  ) STORED AS KUDU
;



CREATE TABLE AD_FACULTY_COURSE_DETAILS
  (
     FACULTY_ID         INTEGER ,
     COURSE_ID         	INTEGER ,
     CONTACT_HRS        INTEGER NOT NULL  
 ,PRIMARY KEY ( FACULTY_ID, COURSE_ID )
  ) STORED AS KUDU;



CREATE TABLE AD_FACULTY_LOGIN_DETAILS
  (
    FACULTY_ID        	INTEGER ,
    LOGIN_DATE_TIME      TIMESTAMP NOT NULL
 ,PRIMARY KEY ( FACULTY_ID, LOGIN_DATE_TIME )
  ) STORED AS KUDU
TBLPROPERTIES (

  'kudu.num_tablet_replicas' = '3'
);


ALTER TABLE AD_ACADEMIC_SESSIONS ADD CONSTRAINT AD_SESSIONS_NAME_UK UNIQUE( NAME ) ;

ALTER TABLE AD_COURSES ADD CONSTRAINT AD_COURSES_NAME_UK UNIQUE(NAME);

ALTER TABLE AD_DEPARTMENTS ADD CONSTRAINT AD_DEPT_NAME_UK UNIQUE( NAME ) ;

ALTER TABLE AD_FACULTY ADD CONSTRAINT AD_FACULTY_EMAIL_UK UNIQUE( EMAIL ) ;

ALTER TABLE AD_STUDENTS ADD CONSTRAINT AD_STUDENTS_EMAIL_UK UNIQUE(EMAIL );



/* FOREIGN KEY  no son soportadas!

ALTER TABLE AD_COURSES ADD CONSTRAINT AD_COURSES_FK1 FOREIGN KEY ( SESSION_ID ) REFERENCES AD_ACADEMIC_SESSIONS ( ID ) ;

ALTER TABLE AD_COURSES ADD CONSTRAINT AD_COURSES_FK2 FOREIGN KEY ( DEPT_ID ) REFERENCES AD_DEPARTMENTS ( ID ) ;

ALTER TABLE AD_EXAMS ADD CONSTRAINT AD_EXAMS_FK1 FOREIGN KEY ( EXAM_TYPE ) REFERENCES AD_EXAM_TYPES ( TYPE ) ;

ALTER TABLE AD_EXAMS ADD CONSTRAINT AD_EXAMS_FK2 FOREIGN KEY ( COURSE_ID ) REFERENCES AD_COURSES ( ID ) ;

ALTER TABLE AD_EXAM_RESULTS ADD CONSTRAINT AD_EXAM_RESULTS_FK1 FOREIGN KEY ( STUDENT_ID ) REFERENCES AD_STUDENTS ( ID ) ;

ALTER TABLE AD_EXAM_RESULTS ADD CONSTRAINT AD_EXAM_RESULTS_FK2 FOREIGN KEY ( COURSE_ID ) REFERENCES AD_COURSES ( ID ) ;

ALTER TABLE AD_EXAM_RESULTS ADD CONSTRAINT AD_EXAM_RESULT_FK3 FOREIGN KEY ( EXAM_ID ) REFERENCES AD_EXAMS ( ID ) ;

ALTER TABLE AD_FACULTY ADD CONSTRAINT AD_FACULTY_FK FOREIGN KEY ( DEPT_ID ) REFERENCES AD_DEPARTMENTS ( ID ) ;

ALTER TABLE AD_STUDENT_COURSE_DETAILS ADD CONSTRAINT AD_STUDENT_COURSE_FK1 FOREIGN KEY ( STUDENT_ID ) REFERENCES AD_STUDENTS ( ID ) ;

ALTER TABLE AD_STUDENT_COURSE_DETAILS ADD CONSTRAINT AD_STUDENT_COURSE_FK2 FOREIGN KEY ( COURSE_ID ) REFERENCES AD_COURSES ( ID ) ;

ALTER TABLE AD_STUDENTS ADD CONSTRAINT AD_STUDENTS_FK FOREIGN KEY ( PARENT_ID ) REFERENCES AD_PARENT_INFORMATION ( ID ) ;

ALTER TABLE AD_STUDENT_ATTENDANCE ADD CONSTRAINT AD_STUDENT_ATTENDANCE_FK1 FOREIGN KEY ( STUDENT_ID ) REFERENCES AD_STUDENTS (ID ) ;

ALTER TABLE AD_STUDENT_ATTENDANCE ADD CONSTRAINT AD_STUDENT_ATTENDANCE_FK2 FOREIGN KEY ( SESSION_ID ) REFERENCES AD_ACADEMIC_SESSIONS ( ID ) ;

ALTER TABLE AD_FACULTY_COURSE_DETAILS ADD CONSTRAINT AD_FACULTY_COURSE_FK1 FOREIGN KEY ( FACULTY_ID ) REFERENCES AD_FACULTY ( ID ) ;

ALTER TABLE AD_FACULTY_COURSE_DETAILS ADD CONSTRAINT AD_FACULTY_COURSE_FK2 FOREIGN KEY (  COURSE_ID ) REFERENCES AD_COURSES ( ID ) ;

ALTER TABLE AD_FACULTY_LOGIN_DETAILS ADD CONSTRAINT AD_FACULTY_LOGIN_FK FOREIGN KEY ( FACULTY_ID ) REFERENCES AD_FACULTY ( ID ) ;

*/ 

ALTER TABLE AD_FACULTY_LOGIN_DETAILS CHANGE LOGIN_DATE_TIME LOGIN_DATE_TIME TIMESTAMP;
ALTER TABLE AD_FACULTY_LOGIN_DETAILS ALTER COLUMN LOGIN_DATE_TIME SET DEFAULT current_timestamp; -- "Cannot set default value for primary key column 'LOGIN_DATE_TIME'"


-- ALTER TABLE AD_PARENT_INFORMATION READ ONLY;


INSERT INTO AD_ACADEMIC_SESSIONS VALUES (100, 'SPRING SESSION');
INSERT INTO AD_ACADEMIC_SESSIONS VALUES (200, 'FALL SESSION');
INSERT INTO AD_ACADEMIC_SESSIONS VALUES (300, 'SUMMER SESSION');

INSERT INTO AD_DEPARTMENTS VALUES(10, 'ACCOUNTING', 'MARK SMITH');
INSERT INTO AD_DEPARTMENTS VALUES(20, 'BIOLOGY', 'DAVE GOLD');
INSERT INTO AD_DEPARTMENTS VALUES(30, 'COMPUTER SCIENCE', 'LINDA BROWN');
INSERT INTO AD_DEPARTMENTS VALUES(40, 'LITERATURE', 'ANITA TAYLOR');

-- ALTER TABLE AD_PARENT_INFORMATION READ WRITE;

INSERT INTO AD_PARENT_INFORMATION VALUES(600,'NEIL', 'SMITH','DORIS', 'SMITH');
INSERT INTO AD_PARENT_INFORMATION VALUES(610,'WILLIAM', 'BEN','NITA', 'BEN');
INSERT INTO AD_PARENT_INFORMATION VALUES(620,'SEAN', 'TAYLOR','RHEA', 'TAYLOR');
INSERT INTO AD_PARENT_INFORMATION VALUES(630,'DAVE', 'CARMEN','CATHY', 'CARMEN');
INSERT INTO AD_PARENT_INFORMATION VALUES(640,'JOHN', 'AUDRY','JANE', 'AUDRY');

-- El filtro de fecha es case sensitive. el casteo debe ser doble, porque el to_date no admite string de parámetros.
INSERT INTO AD_STUDENTS VALUES(720, 'JACK','SMITH', to_date(TO_TIMESTAMP('01-Jan-2012','dd-MMM-yyyy')),'JSMITH@SCHOOL.EDU', 600);
INSERT INTO AD_STUDENTS VALUES(730, 'NOAH', 'AUDRY', TO_DATE(TO_TIMESTAMP('01-Jan-2012','dd-MMM-yyyy')),'NAUDRY@SCHOOL.EDU', 640);
INSERT INTO AD_STUDENTS VALUES(740, 'RHONDA','TAYLOR', TO_DATE(TO_TIMESTAMP('01-Sep-2012','dd-MMM-yyyy')),'RTAYLOR@SCHOOL.EDU', 620);
INSERT INTO AD_STUDENTS VALUES(750, 'ROBERT','BEN', TO_DATE(TO_TIMESTAMP('01-Mar-2012','dd-MMM-yyyy')),'RBEN@SCHOOL.EDU', 610);
INSERT INTO AD_STUDENTS VALUES(760, 'JEANNE','BEN', TO_DATE(TO_TIMESTAMP('01-Mar-2012','dd-MMM-yyyy')),'JBEN@SCHOOL.EDU', 610);
INSERT INTO AD_STUDENTS VALUES(770, 'MILLS','CARMEN', TO_DATE(TO_TIMESTAMP('01-Apr-2013','dd-MMM-yyyy')),'MCARMEN@SCHOOL.EDU', 630);

INSERT INTO AD_COURSES VALUES (190, 'PRINCIPLES OF ACCOUNTING', 100, 10,NULL,NULL,'BUILDING A','101','MWF 12-1');
INSERT INTO AD_COURSES VALUES (191, 'INTRODUCTION TO BUSINESS LAW', 100, 10,NULL,NULL,'BUILDING B','201','THUR 2-4');
INSERT INTO AD_COURSES VALUES (192, 'COST ACCOUNTING', 100, 10,NULL,NULL,'BUILDING C','301','TUES 5-7');
INSERT INTO AD_COURSES VALUES (193, 'STRATEGIC TAX PLANNING FOR BUSINESS', 100, 10,'TAX123','PASSWORD',NULL,NULL,NULL);
INSERT INTO AD_COURSES VALUES (194, 'GENERAL BIOLOGY', 200, 20,'BIO123','PASSWORD',NULL,NULL,NULL);
INSERT INTO AD_COURSES VALUES (195, 'CELL BIOLOGY', 200, 20,NULL,NULL,'BUILDING D','401','MWF 9-10');

INSERT INTO AD_FACULTY VALUES (800, 'JILL', 'MILLER','JMILL@SCHOOL.EDU',10000,'HEALTH',NULL,20);
INSERT INTO AD_FACULTY VALUES (810, 'JAMES', 'BORG','JBORG@SCHOOL.EDU',30000,'HEALTH,DENTAL',NULL,10);
INSERT INTO AD_FACULTY VALUES (820, 'LYNN', 'BROWN','LBROWN@SCHOOL.EDU',NULL,NULL,50,30);
INSERT INTO AD_FACULTY VALUES (830, 'ARTHUR', 'SMITH','ASMITH@SCHOOL.EDU',NULL,NULL,40,10);
INSERT INTO AD_FACULTY VALUES (840, 'SALLY', 'JONES','SJONES@SCHOOL.EDU',50000,'HEALTH,DENTAL,VISION',NULL,40);

INSERT INTO AD_EXAM_TYPES VALUES('MCE','Multiple Choice Exams','CHOOSE MORE THAN ONE ANSWER');
INSERT INTO AD_EXAM_TYPES VALUES('TF','TRUE AND FALSE Exams','CHOOSE EITHER TRUE OR FALSE');
INSERT INTO AD_EXAM_TYPES VALUES('FIB','FILL IN THE BLANKS Exams','TYPE IN THE CORRECT ANSWER');
INSERT INTO AD_EXAM_TYPES VALUES('ESS','ESSAY Exams','WRITE PARAGRAPHS');
INSERT INTO AD_EXAM_TYPES VALUES('SA','SHORT ANSWER Exams','WRITE SHORT ANSWERS');

INSERT INTO AD_EXAMS VALUES(500,'MCE', TO_DATE(TO_TIMESTAMP('12-Sep-2013','dd-MMM-yyyy')),190);
INSERT INTO AD_EXAMS VALUES(510,'SA', TO_DATE(TO_TIMESTAMP('15-Sep-2013','dd-MMM-yyyy')), 191);
INSERT INTO AD_EXAMS VALUES(520,'FIB', TO_DATE(TO_TIMESTAMP('18-Sep-2013','dd-MMM-yyyy')), 192);
INSERT INTO AD_EXAMS VALUES(530,'ESS', TO_DATE(TO_TIMESTAMP('21-Mar-2014','dd-MMM-yyyy')), 193);
INSERT INTO AD_EXAMS VALUES(540,'TF', TO_DATE(TO_TIMESTAMP('02-Apr-2014','dd-MMM-yyyy')), 194);

INSERT INTO AD_EXAM_RESULTS VALUES(720,190,500,91);
INSERT INTO AD_EXAM_RESULTS VALUES(720,193,520,97);
INSERT INTO AD_EXAM_RESULTS VALUES(730,195,540,87);
INSERT INTO AD_EXAM_RESULTS VALUES(730,194,530,85);
INSERT INTO AD_EXAM_RESULTS VALUES(750,192,500,60);
INSERT INTO AD_EXAM_RESULTS VALUES(750,195,510,97);
INSERT INTO AD_EXAM_RESULTS VALUES(750,191,520,78);
INSERT INTO AD_EXAM_RESULTS VALUES(760,192,540,65);
INSERT INTO AD_EXAM_RESULTS VALUES(760,191,530,60);
INSERT INTO AD_EXAM_RESULTS VALUES(760,192,510,70);

INSERT INTO AD_STUDENT_ATTENDANCE VALUES( 720,100, 180, 21,'Y');
INSERT INTO AD_STUDENT_ATTENDANCE VALUES( 730,200, 180, 11,'Y');
INSERT INTO AD_STUDENT_ATTENDANCE VALUES( 740,300, 180, 12,'Y');
INSERT INTO AD_STUDENT_ATTENDANCE VALUES( 750,100, 180, 14,'Y');
INSERT INTO AD_STUDENT_ATTENDANCE VALUES( 760,200, 180, 15,'Y');
INSERT INTO AD_STUDENT_ATTENDANCE VALUES( 770,300, 180, 13,'Y');

INSERT INTO AD_STUDENT_COURSE_DETAILS VALUES(720,190,'A');
INSERT INTO AD_STUDENT_COURSE_DETAILS VALUES(720,193,'B');
INSERT INTO AD_STUDENT_COURSE_DETAILS VALUES(730,191,'C');
INSERT INTO AD_STUDENT_COURSE_DETAILS VALUES(740,195,'F');
INSERT INTO AD_STUDENT_COURSE_DETAILS VALUES(750,192,'A');
INSERT INTO AD_STUDENT_COURSE_DETAILS VALUES(760,190,'B');
INSERT INTO AD_STUDENT_COURSE_DETAILS VALUES(760,192,'C');
INSERT INTO AD_STUDENT_COURSE_DETAILS VALUES(770,192,'D');
INSERT INTO AD_STUDENT_COURSE_DETAILS VALUES(770,193,'F');
INSERT INTO AD_STUDENT_COURSE_DETAILS VALUES(770,194,'A');

INSERT INTO AD_FACULTY_COURSE_DETAILS VALUES (800, 192,3);
INSERT INTO AD_FACULTY_COURSE_DETAILS VALUES (800, 193,4);
INSERT INTO AD_FACULTY_COURSE_DETAILS VALUES (800, 190,5);
INSERT INTO AD_FACULTY_COURSE_DETAILS VALUES (800, 191,3);
INSERT INTO AD_FACULTY_COURSE_DETAILS VALUES (810, 194,4);
INSERT INTO AD_FACULTY_COURSE_DETAILS VALUES (810, 195,5);

INSERT INTO AD_FACULTY_LOGIN_DETAILS VALUES(800,current_timestamp());
INSERT INTO AD_FACULTY_LOGIN_DETAILS VALUES(810, current_timestamp());
INSERT INTO AD_FACULTY_LOGIN_DETAILS VALUES(840, current_timestamp());
INSERT INTO AD_FACULTY_LOGIN_DETAILS VALUES(820, current_timestamp());
INSERT INTO AD_FACULTY_LOGIN_DETAILS VALUES(830, current_timestamp());

ALTER TABLE AD_FACULTY_LOGIN_DETAILS ADD COLUMN  DETAILS  STRING;

-- Join simple
SELECT c.NAME, s.NAME
FROM AD_COURSES c JOIN AD_ACADEMIC_SESSIONS s
ON(c.SESSION_ID = s.ID)
WHERE SESSION_ID = 200;

-- Doble Join
SELECT c.NAME, STUDENT_ID, d.NAME
FROM AD_STUDENT_COURSE_DETAILS s
JOIN AD_COURSES c
ON c.ID = s.COURSE_ID
JOIN AD_DEPARTMENTS d
ON c.DEPT_ID = d.ID;

--Doble Join con filtro
SELECT c.NAME, STUDENT_ID, d.NAME
FROM AD_STUDENT_COURSE_DETAILS s
JOIN AD_COURSES c
ON c.ID = s.COURSE_ID
JOIN AD_DEPARTMENTS d
ON c.DEPT_ID = d.ID
WHERE d.ID =20;

-- Consulta de rangos
SELECT c.ID, c.NAME, EXAM_GRADE, EXAM_ID
FROM AD_COURSES c JOIN AD_EXAM_RESULTS e
ON (c.ID = e.COURSE_ID)
WHERE course_id BETWEEN 190 AND 192;

--Left Join
SELECT e.STUDENT_ID, e.EXAM_GRADE, e.COURSE_ID, c.NAME
FROM AD_EXAM_RESULTS e LEFT OUTER JOIN AD_COURSES c
ON (e.COURSE_ID = c.ID);

-- Order by
SELECT STUDENT_ID,EXAM_ID,COURSE_ID,EXAM_GRADE
FROM AD_EXAM_RESULTS
ORDER BY COURSE_ID, STUDENT_ID;


-- Subselect y row_number
SELECT  row_number() OVER (ORDER BY EXAM_GRADE desc) AS "HIGH SCORES",sub.STUDENT_ID, sub.EXAM_ID, sub.EXAM_GRADE
FROM
(SELECT STUDENT_ID, EXAM_ID, EXAM_GRADE
FROM AD_EXAM_RESULTS
ORDER BY EXAM_GRADE DESC -- Informó que este order no es necesario
) sub
limit 5
