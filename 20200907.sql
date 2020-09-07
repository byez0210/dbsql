ROWNUM : 1 부터 읽어야 한다    
        SELECT 절이  ORDER BY 절보다 먼저 실행된다
         ==> ROWNUM 을 이용한 순서를 부여하려면 정렬부터 해야한다
            ==> 인라인뷰( ORDER BY - ROWNUM을 분리)
            
            
실습 ROW_1]

SELECT ROWNUM rn, empno, ename 
FROM emp 
WHERE ROWNUM <= 10;

실습 ROW_2]
SELECT *
FROM(SELECT ROWNUM rn, a.*
     FROM    
       (SELECT empno, ename
        FROM emp
        ORDER BY ename)a)
WHERE rn BETWEEN (:page -1) * : pagesize + 1 AND : page * :pagesize;

SELECT *
FROM (SELECT ROWNUM rn, empno, ename 
      FROM emp) 
WHERE rn >= 11 AND rn<=20;

실습 ROW_3]

1. 정렬기준 : ORDER BY ename ASC;
2. 페이지 사이즈 : 11~20 (페이지당 10건) 

SELECT *
FROM (SELECT ROWNUM rn, a.* 
      FROM 
           (SELECT empno, ename
            FROM emp
            ORDER BY ename)a)
WHERE rn > 10 AND rn <= 20;        

ORACLE 함수 분류
1. SINGLE ROW FUNCTION  : 단일 행을 작업의 기준, 결과도 한건 반환
2. MULTI ROW FUMCTION : 여러 행을 작업의 기준, 하나의 행을 결과로 반환

dual 테이블
    1.sys 계정에 존재하는 누구나 사용할 수 있는 테이블
    2. 테이블에는 하나의 컬럼, dummy존재, 값은 x
    3. 하나의 행만 존재
          **** SINGLE
          
SELECT *
FROM dual;

sql 칠거지약
1. 좌변을 가공하지 말아라 (테이블 컬럼에 함수를 사용하지 말것)
    . 함수 실행 횟수
    . 인덱스 사용관련(추후에)

SELECT empno, ename, LENGTH(ename),LENGTH('HELLO')
FROM emp;


SELECT LENGTH('HELLO')
FROM dual;

(컬럼)행의 건수만큼 실행
SELECT ename, LOWER(ename)
FROM emp
WHERE LOWER(ename) = 'smith';

 한번만 실행
SELECT ename, LOWER(ename)
FROM emp
WHERE ename = UPPER('smith');

SELECT ename, LOWER(ename)
FROM emp
WHERE ename = 'SMITH';

문자열 관련함수
SELECT CONCAT('Hello', ',World') concat, 
       SUBSTR('Hello, World', 1, 5) substr, -- 1~5까지
       SUBSTR('Hello, World',5) substr2, 
       LENGTH('Hello, World') length, --문자열의 길이
       INSTR ('Hello, World', 'o') instr, --첫번째로 등장하는 인덱스
       INSTR ('Hello, World', 'o', 5 +1) instr2,
       INSTR ('Hello, World', 'o',INSTR ('Hello, World', 'o') + 1) instr3,
       LPAD('Hello, World', 15, '*') lpad, --(문자열, 전체길이, 부족한 길이만큼 채울 문자)
       LPAD('Hello, World', 15)lpad2,      --(문자열, 전체길이)
       RPAD('Hello, World', 15, '*') rpad,
       REPLACE('Hello, World', 'Hello', 'Hell')replace,
       TRIM('Hello, World') trim,
       TRIM('    Hello,World     ') trim2, --(문자열 앞뒤로 공백 제거)
       TRIM( 'H' FROM 'Hello,World') trim3 --(문자열 앞뒤로 특정 문자 제거)
FROM dual;


숫자 관련함수
ROUND : 반올림 함수
TRUNC : 버림 함수
  ==> 몇번째 자리에서 반올림, 버림 할지?
      두번째 인자가 0, 양수 : ROUND (숫자, 반올림 결과 자리수)
      두번째 인자가 음수 : ROUND (숫자, 반올림 할 자리수)
MOD : 나머지를 구하는 함수

SELECT TRUNC (105.54, 1) trunc,
       TRUNC (105.55, 1) trunc2,
       TRUNC (105.55, 0) trunc3,
       TRUNC (105.55, -1) trunc4
FROM DUAL;

MOD : 나머지를 구하는 함수
피제수나눔을 당하는 수, 제수 - 나누는 수
a / b = c
a : 피제수
b : 제수

10을 3으로 나눴을 때의 몫을 구하기
SELECT 10/3,trunc (10/3 , 0) trunc
FROM dual;

날짜 관련함수
문자열 ==> 날짜 타입 TO_DATE
SYSDATE : 오라클 서버의 현재 날짜, 시간을 돌려주는 특수함수
          함수의 인자가 없다.
          (java
          pulic void test() {
          }
          test();
          
          SQL
          Length('Hello, World')
          SYSDATE;
SELECT SYSDATE
FROM dual;
          

날짜타입 +- 정수(일자) : 날짜에서 정수만큼 더한(뺀) 날짜 
하루 = 24
1 =24h
1/24일 = 1h
1/24일/60 = 1m
1/24일/60/60 = 1s
emp hiredate + 5, -5

SELECT SYSDATE, SYSDATE + 5, SYSDATE - 5,
       SYSDATE + 1/24, SYSDATE + 1/24/60
FROM dual;

date 실습 fn1]

sql : 'Hello, World', 5
java : 
날짜를 어떻게 표현할까?
java : java.util,Date
sql : nsl 포멧
 ==> 툴때문일수도 있음 예측하기 힘듬
 TO_DATE 함수를 이용하여 명확하게 명시
TO_DATE('날짜 문자열', '날짜 문자열 형식')

SELECT TO_DATE('2019/12/31','YYYY/MM/DD') YESTERDAY, 
       TO_DATE('2019/12/31','YYYY/MM/DD')-5 YESTERDAY_BEFORE5, 
       SYSDATE NOW, 
       SYSDATE - 5 NOW_BEFORE3
FROM dual;
 