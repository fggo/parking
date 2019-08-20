-- SQLPLUS system/oracle;
-- CREATE USER parking IDENTIFIED by parking;
-- GRANT CONNECT, RESOURCE TO parking;
-- CONN parking/1234;

SELECT * FROM MEMBER;
select * from member where email='admin@admin.com' and pw='admin';
SELECT * FROM USERHISTORY;
--SELECT * FROM CAR;
--SELECT * FROM PAYMENTHISTORY;
--SELECT * FROM REVIEW;
--SELECT * FROM QNABOARD;
--SELECT * FROM NOTICE;
--SELECT * FROM BOOKMARK;
--SELECT * FROM COUPON;


-- TABLE
DROP TABLE MEMBER CASCADE CONSTRAINTS;
DROP TABLE USERHISTORY CASCADE CONSTRAINTS;
DROP TABLE CAR CASCADE CONSTRAINTS;
DROP TABLE PAYMENTHISTORY CASCADE CONSTRAINTS;
DROP TABLE REVIEW CASCADE CONSTRAINTS;
DROP TABLE QNABOARD CASCADE CONSTRAINTS;
DROP TABLE NOTICE CASCADE CONSTRAINTS;
DROP TABLE BOOKMARK CASCADE CONSTRAINTS;
DROP TABLE COUPON CASCADE CONSTRAINTS;

DROP SEQUENCE USERHISTORY_SEQ;
DROP SEQUENCE PAYMENTHISTORY_SEQ;
DROP SEQUENCE REVIEW_SEQ;
DROP SEQUENCE QNABOARD_SEQ;
DROP SEQUENCE NOTICE_SEQ;
DROP SEQUENCE BOOKMARK_SEQ;

SELECT * FROM user_constraints WHERE table_name IN
    ('MEMBER', 'USERHISTORY', 'CAR', 'PAYMENTHISTORY', 'REVIEW', 'QNABOARD', 'NOTICE', 'BOOKMARK', 'COUPON');

CREATE TABLE MEMBER (
    user_code VARCHAR2(20) NOT NULL,
    email VARCHAR2(20) NOT NULL,
    pw VARCHAR2(20) NOT NULL,
    phone VARCHAR2(20) NOT NULL,
    user_name VARCHAR2(40) NOT NULL,
    user_addr VARCHAR2(200) NOT NULL,
    created_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    login_date TIMESTAMP,
    sms_yn CHAR(1) NOT NULL,
    email_yn CHAR(1) NOT NULL,
    email_verified CHAR(1) DEFAULT '0'
);

COMMENT ON COLUMN MEMBER.user_code IS '회원코드';
COMMENT ON COLUMN MEMBER.email IS '이메일';
COMMENT ON COLUMN MEMBER.pw IS '비밀번호';
COMMENT ON COLUMN MEMBER.phone IS '폰번호';
COMMENT ON COLUMN MEMBER.user_name IS '회원이름';
COMMENT ON COLUMN MEMBER.user_addr IS '회원주소';
COMMENT ON COLUMN MEMBER.created_date IS '가입날짜';
COMMENT ON COLUMN MEMBER.login_date IS '최근 로그인날짜';
COMMENT ON COLUMN MEMBER.sms_yn IS '문자 수신여부(Y/N)';
COMMENT ON COLUMN MEMBER.email_yn IS '이메일 수신여부(Y/N)';
COMMENT ON COLUMN MEMBER.email_verified IS '이메일 인증여부(1/0)';

ALTER TABLE MEMBER 
    ADD CONSTRAINT pk_user PRIMARY KEY(user_code);
ALTER TABLE MEMBER 
    ADD CONSTRAINT uq_user UNIQUE (email);
ALTER TABLE MEMBER 
    ADD CONSTRAINT chk_user_sms CHECK (UPPER(sms_yn) in ('Y','N'));
ALTER TABLE MEMBER 
    ADD CONSTRAINT chk_user_email CHECK (UPPER(email_yn) in ('Y','N'));
ALTER TABLE MEMBER 
    ADD CONSTRAINT chk_user_verified CHECK (email_verified in ('1','0'));

CREATE TABLE USERHISTORY(
    idx NUMBER(7) NOT NULL,
    user_code VARCHAR2(20) NOT NULL,
    latitude NUMBER(10,8) NOT NULL,
    longitude NUMBER(11,8) NOT NULL,
    parkinglot_name VARCHAR2(50) NOT NULL,
    parkinglot_addr VARCHAR2(200) NOT NULL,
    parking_date TIMESTAMP DEFAULT SYSTIMESTAMP
);
COMMENT ON COLUMN USERHISTORY.idx IS '이용내역 코드번호';
COMMENT ON COLUMN USERHISTORY.user_code IS '회원코드';
COMMENT ON COLUMN USERHISTORY.latitude IS '위도(0~90)';
COMMENT ON COLUMN USERHISTORY.longitude IS '경도(0~180)';
COMMENT ON COLUMN USERHISTORY.parkinglot_name IS '주차장이름';
COMMENT ON COLUMN USERHISTORY.parkinglot_addr IS '주차장주소';
COMMENT ON COLUMN USERHISTORY.parking_date IS '주차날짜';

CREATE SEQUENCE USERHISTORY_SEQ START WITH 1;

CREATE OR REPLACE TRIGGER USERHISTORY_TRG
BEFORE INSERT ON USERHISTORY
FOR EACH ROW
BEGIN
  SELECT USERHISTORY_SEQ.NEXTVAL
  INTO :NEW.IDX
  FROM DUAL;
END;
/


ALTER TABLE USERHISTORY
    ADD CONSTRAINT pk_userhistory PRIMARY KEY(idx);
ALTER TABLE USERHISTORY
    ADD CONSTRAINT fk_userhistory_member FOREIGN KEY(user_code) REFERENCES MEMBER(user_code)
    ON DELETE CASCADE;


CREATE TABLE CAR(
    user_code VARCHAR2(20) NOT NULL,
    capcity NUMBER(2) DEFAULT 0,
    car_type VARCHAR2(50),
    model VARCHAR2(50)
);
COMMENT ON COLUMN CAR.user_code IS '회원코드';
COMMENT ON COLUMN CAR.capcity IS '차량 인승';
COMMENT ON COLUMN CAR.car_type IS '차량종류';
COMMENT ON COLUMN CAR.model IS '차량모델명';

ALTER TABLE CAR
    ADD CONSTRAINT fk_car_member FOREIGN KEY(user_code) REFERENCES MEMBER(user_code)
    ON DELETE CASCADE;


CREATE TABLE PAYMENTHISTORY(
    idx NUMBER(7) NOT NULL,
    purchase_amount NUMBER(7) DEFAULT 0,
    instt_name VARCHAR2(100),
    instt_phone VARCHAR2(20),
    payment_date TIMESTAMP DEFAULT SYSTIMESTAMP
);
COMMENT ON COLUMN PAYMENTHISTORY.idx IS '결제내역번호';
COMMENT ON COLUMN PAYMENTHISTORY.purchase_amount IS '주차요금 결제액';
COMMENT ON COLUMN PAYMENTHISTORY.instt_name IS '관리기관명';
COMMENT ON COLUMN PAYMENTHISTORY.instt_phone IS '관리기관 연락처';
COMMENT ON COLUMN PAYMENTHISTORY.payment_date IS '주차요금 결제일';

CREATE SEQUENCE PAYMENTHISTORY_SEQ START WITH 1;

CREATE OR REPLACE TRIGGER PAYMENTHISTORY_TRG
BEFORE INSERT ON PAYMENTHISTORY
FOR EACH ROW
BEGIN
  SELECT PAYMENTHISTORY_SEQ.NEXTVAL
  INTO :NEW.IDX
  FROM DUAL;
END;
/

-- ALTER TABLE PAYMENTHISTORY
--     ADD CONSTRAINT pk_paymenthistory PRIMARY KEY(idx);
ALTER TABLE PAYMENTHISTORY
    ADD CONSTRAINT fk_paymenthistory_userhistory FOREIGN KEY(idx) REFERENCES userhistory(idx)
    ON DELETE CASCADE;


CREATE TABLE REVIEW(
	idx NUMBER(7) NOT NULL,
    review_title VARCHAR2(50) NOT NULL,
    review_content VARCHAR2(50) NOT NULL,
    created_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    rating NUMBER(1) NOT NULL
);
COMMENT ON COLUMN REVIEW.idx IS '코드번호';
COMMENT ON COLUMN REVIEW.review_title IS '리뷰 제목';
COMMENT ON COLUMN REVIEW.review_content IS '리뷰 작성글';
COMMENT ON COLUMN REVIEW.created_date IS '작성날짜';
COMMENT ON COLUMN REVIEW.rating IS '평점(1~5 정수)';

CREATE SEQUENCE REVIEW_SEQ START WITH 1;

CREATE OR REPLACE TRIGGER REVIEW_TRG
BEFORE INSERT ON REVIEW
FOR EACH ROW
BEGIN
  SELECT REVIEW_SEQ.NEXTVAL
  INTO :NEW.IDX
  FROM DUAL;
END;
/

ALTER TABLE REVIEW
    ADD CONSTRAINT fk_review_userhistory FOREIGN KEY(idx) REFERENCES userhistory(idx)
    ON DELETE CASCADE;
ALTER TABLE REVIEW
    ADD CONSTRAINT chk_review_rating CHECK (rating in (1,2,3,4,5));


CREATE TABLE QNABOARD(
    idx NUMBER(7) NOT NULL,
    user_code VARCHAR2(20) NOT NULL,
    qna_title VARCHAR2(50) NOT NULL,
    qna_content VARCHAR2(400) NOT NULL,
    created_date TIMESTAMP DEFAULT SYSTIMESTAMP
);
COMMENT ON COLUMN QNABOARD.idx IS '문의글번호';
COMMENT ON COLUMN QNABOARD.user_code IS '회원코드';
COMMENT ON COLUMN QNABOARD.qna_title IS '문의글 제목';
COMMENT ON COLUMN QNABOARD.qna_content IS '문의글 내용';
COMMENT ON COLUMN QNABOARD.created_date IS '작성날짜';

CREATE SEQUENCE QNABOARD_SEQ START WITH 1;

CREATE OR REPLACE TRIGGER QNABOARD_TRG
BEFORE INSERT ON QNABOARD
FOR EACH ROW
BEGIN
  SELECT QNABOARD_SEQ.NEXTVAL
  INTO :NEW.IDX
  FROM DUAL;
END;
/

ALTER TABLE QNABOARD
    ADD CONSTRAINT pk_qnaboard PRIMARY KEY(idx);
ALTER TABLE QNABOARD
    ADD CONSTRAINT fk_qnaboard_member FOREIGN KEY(user_code) REFERENCES MEMBER(user_code)
    ON DELETE CASCADE;


CREATE TABLE NOTICE(
    idx NUMBER(7) NOT NULL,
    user_code VARCHAR2(20) NOT NULL,
    notice_title VARCHAR2(50) NOT NULL,
    notice_content VARCHAR2(400) NOT NULL,
    created_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    view_count NUMBER(7)
);
COMMENT ON COLUMN NOTICE.idx IS '공지사항글번호';
COMMENT ON COLUMN NOTICE.user_code IS '회원코드';
COMMENT ON COLUMN NOTICE.notice_title IS '공지사항 제목';
COMMENT ON COLUMN NOTICE.notice_content IS '공지사항 내용';
COMMENT ON COLUMN NOTICE.created_date IS '작성날짜';
COMMENT ON COLUMN NOTICE.view_count IS '조회수';

CREATE SEQUENCE NOTICE_SEQ START WITH 1;

CREATE OR REPLACE TRIGGER NOTICE_TRG
BEFORE INSERT ON NOTICE
FOR EACH ROW
BEGIN
  SELECT NOTICE_SEQ.NEXTVAL
  INTO :NEW.IDX
  FROM DUAL;
END;
/

ALTER TABLE NOTICE 
    ADD CONSTRAINT pk_notice PRIMARY KEY(idx);
ALTER TABLE NOTICE
    ADD CONSTRAINT fk_notice_member FOREIGN KEY(user_code) REFERENCES MEMBER(user_code)
    ON DELETE CASCADE;


CREATE TABLE BOOKMARK(
    idx NUMBER(3) NOT NULL,
    user_code VARCHAR2(20) NOT NULL,
    latitude NUMBER(10,8) NOT NULL,
    longitude NUMBER(11,8) NOT NULL
);
COMMENT ON COLUMN BOOKMARK.idx IS '북마크번호';
COMMENT ON COLUMN BOOKMARK.user_code IS '회원코드';
COMMENT ON COLUMN BOOKMARK.latitude IS '위도(0~90)';
COMMENT ON COLUMN BOOKMARK.longitude IS '경도(0~180)';

CREATE SEQUENCE BOOKMARK_SEQ START WITH 1;

CREATE OR REPLACE TRIGGER BOOKMARK_TRG
BEFORE INSERT ON BOOKMARK
FOR EACH ROW
BEGIN
  SELECT BOOKMARK_SEQ.NEXTVAL
  INTO :NEW.IDX
  FROM DUAL;
END;
/

ALTER TABLE BOOKMARK 
    ADD CONSTRAINT pk_bookmark PRIMARY KEY(idx);
ALTER TABLE BOOKMARK
    ADD CONSTRAINT fk_bookmark_member FOREIGN KEY(user_code) REFERENCES MEMBER(user_code)
    ON DELETE CASCADE;


CREATE TABLE COUPON(
    coupon_code CHAR(16) NOT NULL,
    user_code VARCHAR2(20) NOT NULL,
    expired_yn CHAR(1)
);
COMMENT ON COLUMN COUPON.coupon_code IS '쿠폰번호';
COMMENT ON COLUMN COUPON.user_code IS '회원코드';
COMMENT ON COLUMN COUPON.expired_yn IS '쿠폰 사용기한 초과여부'; 

ALTER TABLE COUPON
    ADD CONSTRAINT pk_coupon PRIMARY KEY(coupon_code);
ALTER TABLE COUPON
    ADD CONSTRAINT fk_coupon_member FOREIGN KEY(user_code) REFERENCES MEMBER(user_code)
    ON DELETE CASCADE;
ALTER TABLE COUPON
    ADD CONSTRAINT chk_coupon_expired_yn CHECK (UPPER(expired_yn) in('Y', 'N'));


INSERT INTO MEMBER VALUES('101', 'admin@admin.com', 'admin','010-1111-1111','admin', 'Seoul', DEFAULT, DEFAULT,'N','Y', DEFAULT);
INSERT INTO MEMBER VALUES('102','b@b.com','b','010-2222-2222','baba','Gyeonggi-do',DEFAULT,DEFAULT,'y','n', DEFAULT);
INSERT INTO USERHISTORY VALUES(DEFAULT, '101', 88.12312322, 155.231123, 'happyparking','Seoul Seongdonggu', DEFAULT);
INSERT INTO USERHISTORY VALUES(DEFAULT, '102', 44.12378, 120.12348222, 'luluparking','Seoul Gangnamgu', DEFAULT);

COMMIT;