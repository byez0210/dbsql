  | : OR 
 {} : 여러개가 반복
 [] : 옵션- 있을수도 있고, 없을수도 있다.
 
 
 ==SELECT 쿼리 문법 ==
SELECT * | {column | expression [alias]}
FROM 테이블 이름; 
SQL 실행방법
1. 실행하려고 하는 SQL을 선택 후 cntl + enter;
2. 실행하려는 SQL 구문에 커서를 위치시키고 cntl  +enter;
 
SELECT *
FROM  emp;

SELECT  empno, ename
FROM  emp;

SELECT *
FROM  dept;

자바언어와 다른 점
SQL 의 경우 KEY워드의 대소문자를 구분하지 않는다.

coding rule 
수업시간에는 keyword 는 대문자
그 외 (테이블명, 칼럼명)는 소문자 

실습 select1] 
SELECT *
FROM lprod;

SELECT buyer_id, buyer_name 
FROM buyer;

SELECT *
FROM cart;

SELECT mem_id, mem_pass, mem_name 
FROM member;  

연산
SELECT쿼리는 테이블이 데이터에 영향을 주지 않는다.
SELECT쿼리를 잘못 작성 했다고 해서 데이터가 망가지지 않음

SELECT ename, sal, sal + 100
FROM  emp;

데이터 타입
DESC 테이블명 (테이블 구조를 확인)
DESC emp;

숫자 + 숫자 = 숫자값
5 + 6 = 11

문자 + 문자 = 문자 ==> java에서는 문자열에 이은, 문자열 결합으로 처리

수학적으로 정의된 개념이 아님 
오라클에서는 날짜에다가 숫자를 일수로 생각하여 더하고 뺀 일자가 결과로 된다.
날짜 + 숫자 = 날짜

hiredate에서 365일 미래의 일자


==중요하지는 않음==
별칭 : 칼럼, expression에 새로운 이름을 부여 
    칼럼 | rxpression [AS][칼럼명]
SELECT ename AS emp_name, hiredate, 
        hiredate+365 after_lyear, hiredate-365 before_1year
FROM emp;

별칭을 부여할 때 주의점
1. 공백이나, 특수문자가 있는 경우 더블 퀘테이션으로 감싸줘야 한다.
2. 별칭명은 기본적으로 대문자로 취급하지만 소문자로 지정하고 싶으면 더블 퀘테이션으로 적용한다.

SELECT ename "emp name", empno emp_no, empno "emp_no2"
FROM emp;


자바에서 문자열 : "Hello, World"
SQL에서 문자열 : 'Hello, World'

==매우중요==
NULL : 아직 모르는 값
숫자 타입 : 0이랑 NULL은 다르다
문자 타입 : ' ' 공백문자와 NULL은 다르다.

*** NULL을 포함한 연산의 결과는 항상 NULL
 5 * NULL = NULL
 800 + NULL = NULL
 800 + 0 = 800
 
 emp  테이블 칼럼 정리
 1. empno : 사원번호
 2. ename : 사원이름
 3. job : (담당)업무 
 4. mgr : 매니저 사원번호 
 5. hiredate : 입사일자
 6. sal : 급여 
 7. comm : 성과급
 8. deptno : 부서번호 
 
emp 테이블에서 NULL값을 확인

SELECT ename, sal, comm, sal + comm AS total_sal
FROM emp;

SELECT *
FROM dept;

SELECT userid, usernm, reg_dt, reg_dt + 5
FROM users;

column alias (실습 select2)
SElECT prod_id "id", prod_name "name"
FROM prod

SELECT lprod_gu "gu", lprod_nm "nm"
FROM lprod

SELECT buyer_id "바이어아디", buyer_name "이름"
FROM buyer


literal : 값 자체
literal 표기법 : 값을 표현하는 방법
숫자 10 이라는 값을 
java : int a =10;
sql : SELECT empno, 10
     FROM emp;
      
문자 Hello, World 라는 문자 값을 
java : String str = "Hello ,World"

sql : SELECT empno, 'Hello, World', "Hello, World"
           * | cloumn | expression  [alias]
      FROM emp;

날짜 2020년 9월 2일이라는 날짜 값을..
java : primitive type(원시타입) : 8개  -int, long, short, byte, char, boolean, double, float
                                     문자열 ==> String class
                                     날짜 ==> Date class
                                 
sql : 

문자열 연산 
java + ==> 결합 연산 
     "Hello," + " World" ==> "Hello,World"
     "Hello," - " World" : 연산자가 정의되어 있지 않다
     "Hello," * " World" : 연산자가 정의되어 있지 않다  
     python
    "Hello," * 3 ==> " Hello,Hello,Hello,"
sql || CONCAT 합수 ==> 결합 연산
     emp테이블의 ename, job 컬럼이 문자열
     
     CONCAT (문자열1, 문자열2) : 문자열1과 문자열2를 합쳐서 만들어진 새로운 문자열을 반황해준다
     
SELECT ename || ' ' || job,
    CONCAT( CONCAT(ename, ' '), job)
FROM emp;
     
USER_TABLES : 오라클에서 관리하는 테이블(뷰)
              접속한 사용자가 보유하고 있는 테이블 정보를 정리
              
SELECT  CONCAT('SELECT * FROM ' ,table_name) || ';' "QUERY" 
FROM user_tables;

SELECT *
FROM emp;


