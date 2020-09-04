empno, ename, job, hiredate ...

하나의 컬럼
SELECT empno, ename 
FROM emp;

별칭 기술 : 텍스트, "텍스트" / ' 텍스트'
SELECT empno "ename"
FROM emp;

WHERE 절 : 스프레드 시트 (참이어야 데이터가 나옴)
            - filter : 전체 데이터 중에서 내가 원하는 행만 나오도록 제한
            
비교연산 <, >, =, !=, <>, <=, >=
        BETWEEN AND
        IN
연상자를 배울 때 (복습할 때) 기억할 부분은 해당연산자 X항 연산자 인지하자

1        +         5
피연산자  연산자    피연산자

a++ : 단항연산자

int a = b > 5 ? 10 : 20;

BETWEEN AND : 비교대상 BETWEEN 시작값 AND 종료값
IN : 비교대상 IN (값1, 값2 ...)
LIKE : 비교대상 LIKE '매칭문자열%_ '

SELECT *
FROM emp
WHERE 10 BETWEEN 20 AND 50;

NULL 비교
NULL값은 =, !=, 등의 비교연산으로 비교가 불가능
EX : emp테이블에는 comm컬럼의 값이 NULL인 데이터가 존재

COMM이 NULL인 데이터를 조회하기 위해 다음과 같이 실행할 경우
정상적으로 동작하지 않음 

SELECT *
FROM emp
WHERE comm IS NULL;

comm컬럼의 값이 NULL이 아닐 때
=, !=  <>

SELECT *
FROM emp
WHERE comm IS NOT NULL;

IN <==> NOT IN
사원 중 소속부서가 10번이 아닌 사원 조회
SELECT *
FROM emp
WHERE deptno NOT IN (10);


사원중에 자신의 상급자가 존재하지 않는 사원들만 조회(모든 컬럼)
SELECT *
FROM emp
WHERE mgr IS NULL;

논리 연산 : AND, OR, NOT 
AND, OR : 조건을 결합
    AND : 조건 1 AND 조건2 : 조건 1과 조건2를 동시에 만족하는 행만 조회가되도록 제한 
    OR :  조건1 OR 조건2 : 조건1 혹은 조건2를 만족하는 행만 조회되도록 제한
    
조건 1     조건2     조건1 AND 조건2    조건1 OR 조건2
T           T              T                T
T           F              F                T
F           T              F                F
F           F              F                F

WHERE 절에 AND 조건을 사용하게 되면 : 보통은 행이 줄어든다.
WHERE 절에 OR 조건을 사용하게 되면 : 보통은 행이 늘어든다.

NOT : 부정연산
다른 연산자와 함께 사용되면 부정형으로 사용됨
NOT IN (값1, 값2...)
IS NOT NULL
NOT EXISTS

mgr가 7698사번을 갖으면서 급여가 1000보다 큰 사원들을 조회
SELECT *
FROM emp
WHERE mgr = 7698
  AND sal > 1000; 

mgr가 7698사번을 갖거나 급여가 1000보다 큰 사원들을 조회
SELECT *
FROM emp
WHERE mgr = 7698
   OR sal > 1000; 
   
emp 테이블의 사원 중에 mgr가 7698, 7839가 아닌 사원 
SELECT *
FROM emp
WHERE mgr != 7698
  AND  mgr != 7839;
 
SELECT *
FROM emp
WHERE mgr IN ( 7698, 7839);

IN연산자가는 OR연산자로 대체 가능  
SELECT *
FROM emp
WHERE mgr IN ( 7698, 7839); ==> mgr = 7698 OR mgr =7839
WHERE mgr NOT IN ( 7698, 7839); ==> mgr != 7698 AND mgr !=7839

IN 연산자 사용 시 NULL 데이터 유의점
요구사항 : mgr가 7698, 7839, NULL인 사원만 조회

SELECT *
FROM emp
WHERE mgr IN (7698, 7839, NULL);

mgr = 7698 OR mgr = 7839 OR mgr = NULL;

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL);
mgr != 7698 AND mgr != 7839 AND mgr != NULL

SELECT *
FROM emp
WHERE mgr IN (7698, 7839)
   OR mgr IS NULL;
   
실습 WHERE7]
SELECT *  
FROM emp
WHERE JOB = 'SALESMAN' 
  AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');
  
data는 대소문자를 가린다
date type은

실습 WHERE8]
SELECT *
FROM emp
WHERE deptno != 10
 AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');
 
실습 WHERE9]
 SELECT *
 FROM emp
 WHERE deptno NOT IN (10)
   AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');
 
실습 WHERE10]  
SELECT *
FROM emp
WHERE deptno IN (20, 30)
  AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');

실습 WHERE11]
SELECT *
FROM emp 
WHERE job = 'SALESMAN'
   OR  hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');
   
실습 THERE12]
SELECT * 
FROM emp 
WHERE JOB = 'SALESMAN' 
 OR  empno LIKE '78%';

실습 THERE13]
SELECT * 
FROM emp 
WHERE JOB = 'SALESMAN' 
 OR empno = '78';
   
실습 THERE14]  
SELECT * 
FROM emp 
WHERE JOB = 'SALESMAN'
   OR empno LIKE '78%'
    AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');
    

정렬
*******매우매우 중요 *****
RDBMS는 집합에서 많은부분을 차용
집합의 특징 : 1. 순서가 없다.
             2. 중복을 허용하지 않는다
{1, 5, 10} == {5, 1, 10} (집합에 순서가 없다.)
{1, 5, 5, 10} ==> {1, 5, 10} (집합은 중복은허용하지 않는다.)

아래 sql의 실행결과, 데이터의 조회순서는 보장되지 않는다.
지금은 7369, 7499....조회가 되지만
내일 동일한 sql을 실핼하더라도 오늘 순서가 보장되지 않는다 (바뀔 수 있음)

*데이터는 보편적으로 데이터를 입력한 순서대로 나온다(보장은 아님)
** table에는 순서가 없다.
SELECT * 
FROM emp;

시스템을 만들다 보면 데이터의 정렬이 중요한 경우가 많다
게시판 글 리스트 : 가장 최신글이 가장 위로 와야 한다

**즉 SELECT 결과 행의 순서를 조정할수 있어야 한다
==> ORDER BY 구문

문법
SELECT *
FROM 테이블명 
[WHERE]
[ORDER BY 컬럼1, 컬럼2]

SELECT *
FROM emp
ORDER BY job, empno;

오름차순, ASC : 값이 작은 데이터부터 큰 데이터 순으로 나열
내림차순, DESC : 값이 큰 데이터부터 작은 데이터 순으로 나열

ORACLE에서는 기본적으로 오름차순이 기본값으로 적용
내림차순으로 정렬을 원할 경우 정렬 기준 컬럼 뒤에 DESC를 붙여 준다


job컬럼으로 오른차순 정렬하고 같은 job을 갖는 행끼리는 empno로 내림차순 정렬한다.
SELECT *
FROM emp
ORDER BY job, empno DESC;

참고로만... 중요하진 않음
1. ORDER BY 절에 별칭 사용 가능
SELECT empno eno, ename enm
FROM emp
ORDER BY enm;

2. ORDER BY 절에 SELECT 절의 컬럼 순서번호를 기술하여 정렬 가능
SELECT empno, ename 
FROM emp
ORDER BY 2; ==> ORDER BY ename

3. expression도 가능
SELECT empno, ename, saL + sal + 500
FROM emp
ORDER BY sal + 500;

실습orderby1]
SELECT *
FROM dept 
ORDER BY dname ASC;

SELECT *
FROM dept 
ORDER BY loc DESC;

실습orderby2]
SELECT *
FROM emp
WHERE comm NOT IN(0)
ORDER BY comm DESC, empno DESC;  
 
실습orderb3]
SELECT *
FROM emp 
WHERE mgr IS NOT NULL
ORDER BY job , empno DESC; 

실습orderb4]
1. SELECT *
2. FROM emp
3. WHERE deptno IN(10, 30)
     AND sal > 1500 
4. ORDER BY ename DESC;

2 - 3 - 1 -4

*****실무에서 매우 많이 사용 ****
ROWNUM : 행의 번호를 부여해주는 가상 컬럼
        ** 조회된 순서대로 번호를 부여
        
        
    ROWNUM은 1번부터 순차적으로 데이터를 읽어 올 때만 사용 가능    
1. WHERE절에 사용하는 것이 가능
    * WHERE ROWNUM =1 (= 동등 비교연산의 경우 1만 가능
      WHERE ROWNUM <= 5
      WHERE ROWNUM BETWEEN 1 AND 15
      
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM = 3;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 6 AND 10;

2. ORDER BY 절은 SELECT 이후에 실행된다
  ** SLEECT 절에 ROWNUM을 사용하고 ORDER BY절을 적용하게 되면 
    원하는 결과를 얻지 못한다.
    
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

정렬을 먼저 하고, 정렬된 결과에 ROWNUM을 적용
==> INLINE-VIEW
    SELECT 결과를 하나의 테이블처럼 만들어준다
    
사원정보를 페이징 처리
1페이지 5명씩 조회
1페이지 : 1~5,      (page-1)* pagesizE + 1 ~ page ~ page *pagesize
2페이지 : 6 ~10,
3페이지 : 11~15

page = 1, pagesize = 5

a = 테이블처리 하기위한 
SELECT *
FROM(SELECT ROWNUM rn, a.*
     FROM    
       (SELECT empno, ename
        FROM emp
        ORDER BY ename)a)
WHERE rn BETWEEN (:page -1) * : pagesize + 1 AND : page * : pagesize;
  
SELECT 절에 * 사용했는데 ,를 통해 다른 특수 컬럼이나 EXPRESSION을 사용할 경우는
    * 앞에 해당 데이터가 어떤 테이블에서 왓는 명시를 해줘야 한다(한정자)
    
SELECT ROWNUM,*
FROM emp;

SELECT ROWNUM, emp.*
FROM emp;

별칭은 테이블에도 적용 가능, 단 컬럼이랑 다르게 As 옵션은 없다

SELECT ROWNUM, e.*
FROM emp e;