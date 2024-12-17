SET search_path = citus;


CREATE TABLE AUTHORS
 (
    ID VARCHAR(6),
    NAME VARCHAR(60),
    CONSTRAINT author_id_pk PRIMARY KEY(ID)
  );

CREATE TABLE MEMBERS
  (
    ID             VARCHAR(6),
    FIRST_NAME     VARCHAR(50),
    LAST_NAME      VARCHAR(50) ,
    STREET_ADDRESS VARCHAR(50) ,
    CITY           VARCHAR(20) ,
    STATE          VARCHAR(2) ,
    ZIP            VARCHAR(10),
    CONSTRAINT members_id_pk PRIMARY KEY (ID)
  );

CREATE TABLE PUBLISHERS
  (
    ID   VARCHAR(6),
    NAME VARCHAR(100) NOT NULL,
    CONSTRAINT publisher_id_pk PRIMARY KEY (ID)
  );

CREATE TABLE BOOKS
  (
    ID      VARCHAR(6),
    TITLE        VARCHAR(255)NOT NULL,
    PUBLISHER_ID VARCHAR(6),
    AUTHOR_ID    VARCHAR(6),
    CONSTRAINT book_id_pk PRIMARY KEY (ID),
    CONSTRAINT bk_auth_fk FOREIGN KEY (author_id) REFERENCES authors(id),
    CONSTRAINT bk_publ_fk FOREIGN KEY (publisher_id) REFERENCES publishers(id)
   );

CREATE TABLE BOOK_TRANSACTIONS
  (
    ID              VARCHAR(6),
    TRAN_DATE       DATE DEFAULT current_date NOT NULL,
    TYPE            VARCHAR(10) ,
    BOOK_ID         VARCHAR(6) ,
    MEMBER_ID       VARCHAR(6),
    CONSTRAINT booktrns_id_pk PRIMARY KEY (ID),
    CONSTRAINT bk_trns_fk FOREIGN KEY (book_id) REFERENCES books(id),
    CONSTRAINT bk_mem_fk FOREIGN KEY (member_id) REFERENCES members(id)
   );




insert into publishers values(10,'Penguin Group');
insert into publishers values(20,'Addison Wesley');
insert into publishers values(30,'Elsevier');

insert into authors values(100,'Leo Tolstoy');
insert into authors values(200,'P.G. Wodehouse');
insert into authors values(300,'George Bernard Shaw');

insert into members(id) values(111);

insert into books values(1, 'War and Peace',10,100);
insert into books values(2, 'The Clicking of Cuthbert',20,200);
insert into books values(3, 'An Unsocial Socialist',30,300);

insert into book_transactions values('0D0001','2021-05-01','out','1','111');
insert into book_transactions values('0D0002','2021-02-02','out','2','111');
insert into book_transactions values('0D0003','2021-03-25','out','3','111');
