SELECT sido, sigungu, gb 
FROM fastfood
WHERE SIDO = '대전광역시'
 AND sigungu = '중구';

 
 순위  시도    시군구  롯데리아   맘스터치   
 1    서울시   서초구     5         7
 2    서울시   강남구     6         9
 3  

KFC -66 롯데리아 -188 버거킹 -104 맥도날드 -126
SELECT a.sido, a.sigungu, a.cnt, b.cnt, ROUND( a.cnt/b.cnt,2) di
FROM
(SELECT sido, sigungu, COUNT(*) cnt
 FROM fastfood 
 WHERE gb IN ('KFC','맥도날드', '버거킹')
 GROUP BY sido, sigungu)a,
 
 (SELECT sido, sigungu,COUNT(*) cnt
 FROM fastfood 
 WHERE gb IN '롯데리아'
 GROUP BY sido, sigungu)b
 WHERE a.sido = b.sido
 AND a.sigungu = b.sigungu;
 ORDER BY di DESC;
 
 
   kfc 건수 , 롯데리아 건수, 버거킹 건수, 맥도날드 건수
 SELECT sido, sigungu , 
                ROUND((NVL(SUM(DECODE(gb, 'KFC', cnt)),0)  +
                NVL(SUM(DECODE(gb, '버거킹', cnt)),0) +
                NVL(SUM(DECODE(gb, '맥도날드', cnt)),0) ) /
                NVL(SUM(DECODE(gb, '롯데리아', cnt)),1),2) di
 FROM
 (SELECT sido, sigungu, gb, COUNT(*) cnt
 FROM fastfood
 WHERE gb IN('KFC', '롯데리아', '버거킹','맥도날드')
 GROUP BY sido, sigungu, gb)
 GROUP BY sido, sigungu
 ORDER BY di DESC;
 
 
 SELECT sido, sigungu, ROUND(sal/people) p_sal
 FROM tax
 ORDER BY p_sal DESC;
 
 도시발전지수 1- 세금1위
 도시발전지수 2- 세금2위
 도시발전지수 3- 세금3위
 
 
 DML : Data Manipuiate LANGUAGE
 
 1. SELECT
 2. INSERT : 테이블에 새로운 데이터를 입력하는 명령
 3. UPDATE : 테이블에 존재하는 데이터의 컬럼을 변경하는 명령
 4. DELETE : 테이블에 존재하는 데이터(행)를 삭제하는 명령
 
INSERT 3가지 
1.테이블의 특정 컬럼에만 데이커를 입력할 때 (입력되지 않음컬럼은 NULL로 설정된다)
INSERT INTO 테이블명(컬럼 1, 컬럼2 ....) VALUES (컬럼1의 값 , 컬럼 2의 값 2...);
 
DESC emp;
 
INSERT INTO emp (empno,ename) VALUES (9999,'brown');
SELECT *
FROM emp
WHERE empno =9999;
 
 
empno 컬럼의 설정이 NOT NULL이기 떄문에 empno 컬럼에 NULL값이 들어갈 수 없어서 에러
INSERT INTO emp (ename) VALUES ('sally');
 
2.테이블의 모든 컬럼에 모든 데이터를 입력할 때
  **** 단 값을 나열하는 순서는 테이블의 정의된 컬럼 순서대로 기술해야 한다
       테이블 컬럼 순서 확인 방법 : DESC 테이블명
INSERT INTO 테이블명(컬럼 1, 컬럼2 ....) VALUES (컬럼1의 값 , 컬럼 2의 값 2...);

DESC dept;

컬럼을 기술하지 않았기 떄문에 테이블에 정의된 모든 컬럼에 대해 값을 기술해야 하나 3개중에 2개만 기술하여 에러 발생
INSERT INTO dept VALUES (97,'DDIT');
SELECT*
FROM dept;

3. SELECT 결과를 (여러행일 수도 있다) 테이블에 입력
INSERT INTO 테이블명 [col,...]
SELECT 구문;

INSERT INTO emp (empno, ename) 
SELECT 9997,'cony' FROM dual
UNION ALL
SELECT 9996, 'moon'FROM dual;

SELECT *
FROM emp;

날짜 컬럼 값 입력하기
INSERT INTO emp VALUES (9996, 'james', 'CLERK', NULL, SYSDATE, 3000, NULL , NULL);

'2020/09/01'
INSERT INTO emp VALUES (9996, 'james', 'CLERK', NULL, TO_DATE ('2020/09/01','YYYY/MM/DD'), 3000, NULL , NULL);

SELECT *
FROM emp;

UPDATE : 테이블에 존재하는 데이터를 수정
        1. 어떤 데이터를 수정할지 데이터를 한정(WHERE)
        2. 어떤 컬럼에 어떤 값을 넣을지 기술
        
UPDATE 테이블명 SET 변경할 컬럼명 = 수정할 값[, 변경할 컬럼명 = 수정할 값....]
[WHERE]
99   ddit    deajeon 
dept 테이블의 컬럼의 값이 99번인 데이터의 DNAME 컬럼을 대문자로 DDIT로 LOC 컬럼을 한글'영민'으로 변경

UPDATE dept SET dname = 'DDIT' , loc = '영민'
WHERE deptno= 99;

UPDATE dept SET dname = 'DDIT' , loc = '영민';
SELECT *
FROM dept;

ROLLBACK;

2. 서브쿼리를 이용한 데이터 변경(** 추후 MERGE 구문을 배우면 더 효율적으로 작성할 수 있다)

테스트 데이터 입력
INSERT INTO emp (empno, ename, job) VALUES (9000,'brown',NULL);

9000번 사번의 DEPTNO, JOB컬럼의 값을 SMITH사원의 DEPTNO, JOB 컬럼으로 동일하게 변경
SELECT deptno, job
FROM emp
WHERE ename = 'SMITH';

UPDATE emp SET deptno = (SELECT deptno
                         FROM emp
                         WHERE ename = 'SMITH')
                , job = (SELECT job
                         FROM emp
                         WHERE ename = 'SMITH')
WHERE empno = 9000; 

SELECT*
FROM emp 
WHERE ename IN ('brown','SMITH');

3. DELETE : 테이블에 존재하는 데이터를 삭제(행전체를 삭제)
*****emp 테이블에서 9000번 사번의 deptno 컬럼을 지우고 싶을 떄 (NULL)  ??
    ==> deptno 컬럼을 NULL 업데이트 한다

DELETE [FROM] 테이블명
[WHERE....]

emp 테이블에서 9000번 사번의 데이터(행)를 완전히 삭제
DELETE emp
WHERE empno = 9000;

UPDATE, DELETE 절을 실핼하기 전에 
WHERE 절에 기술항 조건으로 SELECT 를 먼저 실행하여, 변경, 삭제되는 행을 눈으로 확인 해보자

DELETE emp
WHERE empno = 7369;

SELECT *
FROM emp;
WHERE empno = 7369;

DELETE emp;

ROLLBACK;


DML 구문 실행시
DBMS는 복구를 위해 로그를 남긴다
즉 데이터 변경 작업 + alpah의 작업량 필요

하지만 개발 환경에서는 데이터를 복구할  필요가 없기 떄문에
삭제속도를 빠르게 하는 것이 개발 효율성에서 좋음

로그없이 테이블의 모든 데이터를 삭제하는 방법 : TRUNCATE TABLE 테이블명;

DELETE emp;
TRUNCATE TABLE emp;