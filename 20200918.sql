DML : Data Manipulate Language
SELECT*****

DDL : Data Defination LanguAge
    데이터와 관련된 객체를 생성, 수정, 삭제하는 명령
    

오라클 객체 생성, 삭제 명령
CREATE 객체타입 객체이름 - 개발자가 부여{

DROP 객체타입 객체이름;

**** 알아는 두자(못외워도 찾아서 사용할 수 있으면 된다)
     모델링 툴을 사용하여 설계를 하게 되면 툴에서 설계된 테이블을 생성하는 
     구문을 자동으로 만들어준다
테이블을 생성하는 문법

CREATE TABLE [오라클사용자]. 테이블명 (
    컬럼명 컬럼의 데이터 타입,
    컬럼명2 컬럼의 데이터 타입2...
);


테이블 생성 
테이블명 - ranger
컬럼은 ranger_no NUMBER
      ranger_nm VARCHAR(50),
      reg_dt DATE
      
신규테이블에 데이터 입력
ranger_no = 1, ranger_nm = 'brown', reg_dt = 현재 날짜, 시간
CREATE TABLE ranger (
    ranger_no NUMBER ,
    ranger_nm VARCHAR(50),
    reg_dt DATE
    );

INSERT INTO ranger VALUES (1 ,'brown',SYSDATE);
      
SELECT *
FROM ranger;

테이블 삭제
DROP TABLE ranger;

자주 사용하는 데이터 타입
1. 숫자 : NUMBER(p,s) p: 전제자리수, s : 소수점 자리수라고 생각하자
         NUMBER ==> 숫자가 표현할 수 있는 최대 범위로 표현
2. 문자 : VARCHAR2(사이즈-byte), CHAR(X)
        VARCHAR2의 최대사이즈 4000byte
        VARCHAR2(2000) : 최대 2000byte를 담을 수 있는 문자타입
        java - 2byte, oracle xe 11g -3byte
        
        CHAR(1~2000byte), 고정길이 문자열 
        CHAR(5) 'test'
        test는 4byte고 char(5) 5byte이기 때문에
        남은 데이터 공간에 공백문자를 삽입함
        'test'
        'test' == 'test '
        
3. 날짜 : DATE - 7byte고정
            일자, 시간(시,분,초) 정보 저장
        varchar2 날짜관리 : YYYYMMDD ==> '20200918'==> 8BYTE
        시스템에서 문자 형식으로 많이 사용하는면 문자타입으로 사용도 고려
        
4.Large OBJECT 
    4.1 CLOB : 문자열을 저장할 수 있는 타입, 사이즈 : 4GB
    4.2 BLOB : 바이너리 데이터, 사이즈 : 4GB
        - CMS - 치과치료 
        
제약조건 : 데이터에 이상한 값이 들어가지 않도록 강제하는 설정
          emp테이블에 empno컬럼에 값이 없는 상태로 들어가는 것을 방지
          emp테이블에 deptno컬럼의 값이 dept테이블에 존재하지 않는 데이터를 입력하는 것을 방지
          emp테이블에 empno(사번) 컬럼의 값이 중복되지 않도록 방지
          
제약조건은 4가지가 존재, 그 중에 한가지의 일부를 별도의 키워드를 제공
ORACLE에서 만들 수 있는 제약조건이 5가지

1. NOT NULL : 컬럼에 반드시 값이 들어가게 하는 제약조건
2. UNIQUE : 해당 컬럼에 중복된 값이 들어오는 것을 방지하는 제약조건
3. PRIMARY KEY : UNIQUE +NOT NULL
4. FOREIGN KEY : 해당 컬럼이 참조하는 다른 테이블의 컬럼에 값이 존재해야 하는 제약조건
                    emp.deptno ==> dept.deptno
5. CHECK : 컬럼에 들어갈 수 있는 값을 제한하는 제약조건
            ex 성별이라는 컬럼있다고 가정
                들어갈 수 있는 값이 : 남 M , 여 F, ==> T ??


제약조건을 생성하는 방법 3가지
1. 테이블을 생성하면서 컬럼 레벨에 제약조건을 생성
        ==> 제약조건을 결합 컬럼(여러개의 컬럼을 합쳐서)에는 적용 불가
2. 테이블을 생성하면서 테이블 레벨에 제약조건을 생성
3. 이미 생성된 테이블에 제약조건을 추가하여 생성

1.테이블 생성 컬럼 레벨로 제약조건 생성
CREATE TABLE 테이블명 (
    컬럼1이름 컬럼1타입 [컬럼제약조건],
);

CREATE TABLE dept_test(
    deptno NUMBER (2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

PRIMARY KEY : UNIQUE(중복된 값이 들어갈 수 없다) + NOT NULL (NULL값이 들어갈 수 없다)

dept_test 테이블에 데이터가 없는 상태
PRIMARY KEY제약에 의해 deptno 컬럼에는 NULL값이 들어갈 수 없다
INSERT INTO dept_test VALUES (NULL,'ddit','daejeon');
unique constraint (.. 오류생김)

90번 부서는 존재하지 않고, NULL값이 아니므로 정삭적으로 등록
INSERT INTO dept_test VALUES (90,'ddit','daejeon');


비교 
dept 테이블에서는 deptno 컬럼에 PRIMARY KEY 제약이 없는 상태
그렇기 때문에 deptno컬럼의 값이 중복이 가능
SELECT *
FROM dept_test
WHERE deptno = 90;


제약조건 생성시 이름을 부여 
DROP TABLE dept_test;
DROP TABLE emp_test;

명명규칙 : PK_테이블명

CREATE TABLE dept_test(
    deptno NUMBER (2)CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES (90,'ddit','daejeon');
INSERT INTO dept_test VALUES (90,'ddit2','daejeon');

2. 테이블 생성시 테이블 레벨로 제약조건 생성
CREATE TABLE 테이블명(
     컬럼1 컬럼1 데이터타입,
     컬럼2 컬럼2 데이터타입,
     [TABLE LEVEL 제약조건]
);
DROP TABLE dept_test; 

CREATE TABLE dept_test(
    deptno NUMBER (2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT PK_dept_test PRIMARY KEY (deptno, dname)
);

deptno 컬럼의 값은 90으로 같지만 dname 컬럼의 값이 다르므로 
 PRIMARY KEY (deptno, dname) 설정에 따라 데이터가 입력될 수 있다
 
 복합컬럼에 대한 제약조건은 컬럼 레벨에서는 설정이 불가하고
 테이블 레벨 혹은 테이블 생성 후 제약조건을 추가하는 형태에서만 가능
INSERT INTO dept_test VALUES (90,'ddit','daejeon');
INSERT INTO dept_test VALUES (90,'ddit2','daejeon');

SELECT *
FROM dept_test;

NOT NULL 제약조건 생성 

DROP TABLE dept_test; 

CREATE TABLE dept_test(
    deptno NUMBER (2) CONSTRAINT PK_dept_test PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES (90,'ddit','daejeon');
INSERT INTO dept_test VALUES (91,NULL,'대전'); 

UNIQUE 제약조건 : 값의 중복이 없도록 방지하는 제약조건, 단 NULL은 허용한다


DROP TABLE dept_test; 
U_테이블명_ 컬럼명

CREATE TABLE dept_test(
    deptno NUMBER (2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT U_dept_test_dname UNIQUE(dname) 
);

INSERT INTO dept_test VALUES (90,'ddit','daejeon');
INSERT INTO dept_test VALUES (90, NULL,'daejeon'); --  NULL은 중복 허용
INSERT INTO dept_test VALUES (90, NULL,'daejeon');

INSERT INTO dept_test VALUES (90,'ddit','daejeon');

FOREIGN KEY 제약조건 : 참조하는 테이블에 데이터만 입력가능하도록 제어
다른 제약조건과 다르게 두개의 테이블간의 제약조건 설정
1. dept_test (부모) 테이블 생성
2. emp_test (자식) 테이블 생성
    2.1 참조제약 조건을 같이 생성
    
1.    
DROP TABLE dept_test; 

CREATE TABLE dept_test(
    deptno NUMBER (2)PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES (90,'ddit','daejeon');

2. emp_test (empno,ename,deptno)
DESC emp;
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test (deptno)
);                    -- 부모테이블이랑 상호작용

SELECT*
FROM emp_test;
SELECT *
FROM dept_test;
참조 무결성 제약조건에 의해 emp_test 테이블의 deptno 컬럼의 값은
dept_test 테이블의 deptno 컬럼의 존재하는 값만 입력이 가능하다

현재는 dept_test 테이블에는 90번 부서만 존재,
그렇기 때문에 emp_test에는 90번 이외의 값이 들어갈 수 없다
INSERT INTO emp_test VALUES (9000, 'brown', 90);
INSERT INTO emp_test VALUES (9001, 'sally', 10);

테이블 레벨 참조 무결성 제약조건 생성

DROP TABLE emp_test;
FK_소스테이블_참조테이블
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2), 
     CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno)
     REFERENCES dept_test (deptno)
);
INSERT INTO emp_test VALUES (9000, 'brown', 90);
INSERT INTO emp_test VALUES (9001, 'sally', 10);

dept_test : 90번 부서가 존재
emp_test : 90번 부서를 참조하는 9000번 brown이 존재

만약 dept_test테이블에서 10번 부서를 삭제하게 된다면?
DELETE dept_test 
WHERE deptno = 90;

참조 무결성 조건 옵션
1. default :자식이 있는 부모 데이터를 삭제할 수 없다
2. 참조 무결성 생성시 OPTION - ON DELETE SET NULL
              삭제시 참조하고 있는 자식 테이블의 컬럼을 NULL로 만든다
3. 참조 무결성 생성시 OPTION - ON DELETE CASCADE
              삭제시 참조하고 있는 자식 테이블 데이토도 같이 삭제
              
2. 
DROP TABLE emp_test;
DROP TABLE dept_test;
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2), 
     CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno)
     REFERENCES dept_test (deptno) ON DELETE SET NULL
);
INSERT INTO emp_test VALUES (9000, 'brown', 90);

DELETE dept_test;
WHERE deptno =90; -- NULL값으로 바뀜 
90번 부서의 속한 9000번 사번의 deptno 컬럼의 값이 NULL로 설정됨
SELECT *
FROM emp_test;


3.
DROP TABLE emp_test;
DROP TABLE dept_test;
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2), 
     CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno)
     REFERENCES dept_test (deptno) ON DELETE CASCADE
);
INSERT INTO emp_test VALUES (9000, 'brown',10);

DELETE dept_test
WHERE deptno =90;

90번 부서의 속한 9000번 사번의 deptno 컬럼의 값이 NULL로 설정됨
SELECT *
FROM emp_test;

입력시 : 부모(dept) ==> 자식(emp)
삭제시 : 자식(emp) ==> 부모(dept)

체크 제약 조건 : 컬럼의 값을 확인하여 입력을 허용

DROP TABLE emp_test;
CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(14),
        sal NUMBER (7)  CHECK (sal > 0),
        gender VARCHAR2(1)CONSTRAINT c_gender CHECK (gender IN ('M', 'F'))  
);

INSERT INTO emp_test VALUES(9000, 'brown', -5, 'M'); sal 체크
INSERT INTO emp_test VALUES(9000, 'brown', 100, 'T'); 성별 체크
INSERT INTO emp_test VALUES(9000, 'brown', 100, 'M'); 체크 통과


DROP TABLE dept_test;
DROP TABLE emp_test;
CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(14),
        sal NUMBER (7),
        gender VARCHAR2(1),

         CONSTRAINT c_sal  CHECK (sal > 0),
         CONSTRAINT c_gender CHECK (gender IN ('M', 'F'))  
);

INSERT INTO emp_test VALUES(9000, 'brown', -5, 'M'); sal 체크
INSERT INTO emp_test VALUES(9000, 'brown', 100, 'T'); 성별 체크
INSERT INTO emp_test VALUES(9000, 'brown', 100, 'M'); 체크 통과

COMMIT , ROLLBACK;

 ROLLBACK;
 
 DDL 주의점 
 1. DDL은 ROLLBACK이 안된다 
    DROP TABLE emp_test;
    CREATE TABLE emp_test (
                empno NUMBER(4),
                ename VARCHAR2(14)
        );
    ROLLBACK;
    
2. DDL은 AUTO COMMIT 
DROP TABLE emp_test;
DROP TABLE dept_test;

 CREATE TABLE emp_test(
                empno NUMBER(4),
                ename VARCHAR2(14)
    );
        
INSERT INTO emp_test VALUES (9000,'brown');

DDL에 의해 자동 커밋, emp_test 테이블에 데이터 입력이 확정 

CREATE TABLE dept_test(
    deptno NUMBER (2),
    dname VARCHAR2(14)
    );

여기서부터는 새로운 트랜젝션    
ROLLBACK;

SELECT 결과를 이용하여 테이블 생성하기
CREATE TABLE 테이블명 [(컬럼, 컬럼2] AS
SELECT 쿼리;

DROP TABLE emp_test;
DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

SELECT*
FROM dept_test;


 
DROP TABLE dept_test;

CREATE TABLE dept_test (dno,dnm, location) AS
SELECT *
FROM dept;

SELECT*
FROM dept_test;

CREATE TABLE AS ==> CTAS
1. NOT NULL을 제외한 나머지 제약조건을 복사하진 않는다
2. 개발시
     테스트 데이터를 만들어 놓고 실험을 해보고 싶을 때
     개발자 수준의 데이터 백업
     CREATE TABLE emp_20200918 AS
     SELECT *
     FROM emp;
     
SELECT*
FROM dept_test;

데이터 없이 테이블 구조만 복사하고 싶을 때
DROP TABLE dept_test;
CREATE TABLE dept_test AS
SELECT *
FROM dept
WHERE 1 != 1;

SELECT *
FROM dept_test;

지금까지는 TABLE 생성, 삭제
테이블 변경
1. 새로운 컬럼을 추가
2. 기존에 존재하는 컬럼의 변경(이름, 데이터 타입)
    *** 데이터 타입의 경우는 이미 데이터가 존재하면 수정이 불가능하다고 보면 됨
        동일한 데이터 타입으로 사이즈를 늘리는 경우는 상관없음
        ==> 설계시 고려를 충분히 하자
3. 테이블이 이미 생성된 시점에서 제약조건을 추가

테이블 변경으로 못하는 사항
1. 컬럼 순서는 못 바꾼다
2. 새로운 컬럼을추가하더라도 마지막 컬럼 뒤에 순서가 부여된다


테이블 변경시
ALTER TABLE 테이블명 .....
컬럼추가
DROP TABLE emp_test;
DROP TABLE dept_test;
CREATE TABLE emp_test (
       empno NUMBER(4),
      ename VARCHAR2(14)
);

DESC emp_test;
 
 emp_test 테이블에 hp 컬럼을 VARCHAR2(15)로 추가
 ALTER TABLE emp_test ADD(hp VARCHAR2(15));
 DESC emp_test;
 
 hp컬럼의 문자열 사이즈를 30으로 변경
 ALTER TABLE emp_test MODIFY (hp VARCHAR2(30));

 hp컬럼의 문자열 타입을 NUMBER로 변경
 ALTER TABLE emp_test MODIFY (hp VARCHAR2(10));
 
 ***데이터 타입을 바꾸는 것은 데이터가 없을 때는 상관없지만
    데이터가 있을 경우는 사이즈를 늘리는 것을 제외하고는 불가능
 
 컬럼명 변경(데이터 타입 변경과 다르게 이름 변경을 자유롭다) 
 hp컬럼을 phone으로 컬럼명을 변경
 ALTER TABLE emp_test RENAME COLUMN hp TO phone;
 
 컬럼 삭제
ALTER TABLE emp_test DROP (phone);

테이블이 생성된 시점에서 제약조건 추가, 삭제하기
문법
ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 제약조건 타입;
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

DROP TABLE emp_test;
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER (2),
    dname VARCHAR2(14)
);
 CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
);

1. dept_test 테이블의 deptno 컬럼에 PRIMARY KEY 제약조건 추가
ALTER TABLE dept_test ADD CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno);

2. emp_test 테이블의 empno 컬럼에 PRIMARY KEY 제약조건 추가
ALTER TABLE emp_test ADD CONSTRAINT PK_EMP_TEST PRIMARY KEY (empno);

3. emp_test 테이블의 deptno 컬럼이 dept_test 컬럼의 deptno컬럼을
    참조하는 FOREIGN KEY 제약조건 추가
ALTER TABLE emp_test ADD CONSTRAINT FK_emp_dept_test
    FOREIGN KEY(deptno) REFERENCES dept_test(deptno);
    