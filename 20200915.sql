실습outerjoin2]
SELECT TO_DATE(:yyyymmdd,'YYYY/MM/DD') buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p 
WHERE p.prod_id = b.buy_prod(+) 
  AND b.BUY_DATE(+) = TO_DATE(:yyyymmdd,'YYYY/MM/DD');

실습outerjoin3]
SELECT TO_DATE(:yyyymmdd,'YYYY/MM/DD') buy_date, b.buy_prod, p.prod_id, p.prod_name, NVL(b.buy_qty,0)
FROM buyprod b, prod p 
WHERE p.prod_id = b.buy_prod(+) 
  AND b.BUY_DATE(+) = TO_DATE(:yyyymmdd,'YYYY/MM/DD');
  
실습outerjoin4]
SELECT p.pid, p.pnm, :cid cid , NVL(c.day,0) DAY, NVL(c.cnt,0)CNT
FROM cycle c, product p
WHERE c.pid(+) = p.pid AND c.cid(+) = :cid ;

ANSI-SQL --해보기

실습outerjoin5] 
SELECT p.pid, p.pnm, :cid cid ,NVL(t.cnm,'brown') cnm, NVL(c.day,0) day, NVL(c.cnt,0) cnt
FROM cycle c, product p, customer t
WHERE c.pid(+) = p.pid AND c.cid= t.cid(+) AND c.cid(+)= 1
AND  t.cid(+) = :cid;

INNER JOIN : 조인이 성공하는 데이터만 조회가 되는 조인 방식
OUTER JOIN : 조인에 실패해도 기준으로 데이터의 컬럼은 조회가 되는 조인 방식

EMP 테이블의 행 건수( 14) * DEPT 테이블의 행 건수 (4)
SELECT *
FROM emp, dept;

SELECT *
FROM customer, product;
SELECT *
FROM customer CROSS JOIN product;

SQL 활용에 있어서 매우 중요
서브쿼리 : 쿼리안에서 실행되는 쿼리
1. 서브쿼리 분류 - 서브쿼리가 사용되는 위치에 따른 분류
    1.1 SELECT : 스칼라 서브쿼리(SCALAR SUBQUERY)
    1.2 FROM : 인라인 뷰 (INLINE - VIEW
    1.3 WHERE : 서브쿼리 (SUB QUERY)
                                (행1, 행 여러개),(컬럼1, 컬럼 여러개)
2. 서브쿼리 분류 - 서브쿼리가 반환하는 행,컬럼의 개수의 따른 분류
(행1, 행 여러개),(컬럼1, 컬럼 여러개) :
(행, 컬럼) : 4가지
    2.1 단일행, 단일 컬럼
    2.2 단일행, 복수 컬럼 ==> X
    2.3 복수행, 단일 컬럼
    2.4 복수행, 복수 컬럼
    
3. 서브쿼리 분류 - 메인쿼리의 컬럼을 서브쿼리에서 사용여부에 따른 분류
    3.1 상호 연관 서브 쿼리 (CORRELATED SUB QUERY)
        - 메인 쿼리의 컬럼을 서브 쿼리에서 사용하는 경우
    3.2 비상호 연관 서브 쿼리 (NON CORRELATED SUB QUERY)
        - 메인 쿼리의 컬럼을 서브 쿼리에서 사용하지 않는 경우
        
SMITH가 속한 부서에 속한 사원들은 누가 있을까?
1. SMITH가 속한 부서번호 구하기
2. 1번에서 구한 부서에 속해 있는 사원들 구하기

SELECT *
FROM emp
WHERE ename = 'SMITH';
SELECT*
FROM emp
WHERE deptno = 20;

==> 서브쿼리를 이용하여 하나로 합칠수가 있다
SELECT*
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
서브쿼리를 사용할 때 주의점
1. 연산자
2. 서브쿼리의 리턴 형태

서브쿼리가 한개의 행 복수컬럼을 조회하고, 단일 컬럼과 비교 하는 경우 ==> X
SELECT*
FROM emp
WHERE deptno = (SELECT deptno, empno
                FROM emp
                WHERE ename = 'SMITH');
                
서브쿼리가 여러개의 행, 단일컬럼을 조회하는 경우
1. 사용되는 위치 : WHERE - 서브쿼리
2. 조회되는 행, 컬럼의 개수 : 복수행, 단일 컬럼
3. 메인쿼리의 컬럼을 서브쿼리에서 사용 유무 : 비상호
SELECT*
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH' 
                   OR ename = 'ALLEN');
                
실습sub1]
SELECT COUNT(*) 
FROM emp
WHERE sal > (SELECT avg(sal)
             FROM emp);
             
실습sub2]
SELECT * 
FROM emp
WHERE sal > (SELECT avg(sal)
             FROM emp);
             
실습sub3]             
SELECT*
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename IN( 'SMITH','WARD')); 
복수행 연산자 : IN(중요),ANY,ALL (빈도 떨어진다)            
SELECT*
FROM emp                -- 800,1250
WHERE sal < ANY (SELECT sal
                    FROM emp
                    WHERE ename IN( 'SMITH','WARD')); 
                    
SAL 컬럼의 값이 800이나, 1250 보다 작은 사원
==> SAL 컬럼의 값이 1250보다 작은 사원 

ALL
SELECT*
FROM emp                -- 800,1250
WHERE sal > ALL (SELECT sal
                    FROM emp
                    WHERE ename IN( 'SMITH','WARD'));
                    
SAL 컬럼의 값이 800보다 크면서 1250보다 큰 사원 
==> SAL 컬럼의 값이 1250보다 큰 사원 

복습
NOT IN 연산자와 NULL

관리자가 아닌 사원의 정보를 조회 ==> NULL때문에 데이터가 나오지 않음
SELECT *
FROM emp
WHERE empno NOT IN(SELECT mgr
                   FROM emp);
                   
pair wise 개념 : 순서쌍, 두가지 조건을 동시에 만족시키는 데이터를 조회할 때 사용
                 AND 논리연산자와 결과값이 다를 수 있다 ( 아래예시 참조) 
서브쿼리 : 복수행, 복수컬럼
SELECT *
FROM emp
WHERE (mgr,deptno) IN (SELECT mgr, deptno
                       FROM emp
                       WHERE empno IN (7499,7782));
                       
SCALAR SUBQUERY : SELECT 절에 기술된 서브쿼리
                 하나의 컬럼
*** 스칼라 서브쿼리는 하나의 행, 하나의 컬럼을 조회하는 쿼리이어야 한다                 
SELECT dummy, (SELECT SYSDATE
               FROM dual)
FROM dual;
스칼라 서브쿼리가 복수개의 행(4개), 단일컬럼을 조회 ==> 에러            
SELECT empno, ename, deptno,(SELECT dname FROM dept) 
FROM emp;

emp 테이블과 스칼라 서브쿼리를 이용하여 부서명 가져오기
기존 : emp 테이블과 dept테이블을 조인하여 컬럼을 확장


SELECT empno, ename, deptno, 
    (SELECT dname FROM dept WHERE deptno = emp.deptno) -- 상호연관
FROM emp;

상호연관 서브쿼리 : 메인쿼리의 컬럼을 서브쿼리에서 사용 서브쿼리
                - 서브쿼리만 단독으로 실행하는 것이 불가능 하다
                - 메인쿼리와 서브쿼리의 실행 순서가 정해져 있다
                    메인쿼리가 항상 먼저 실행된다
비상호연관 서브쿼리 : 메인 쿼리의 컬럼으로 서브쿼리에서 사용하지 않은 서브쿼리
                 - 서브쿼리만 단독으로 실행하는 것이 가능하다
                 - 메인 쿼리만 서브쿼리의 실행순서가 정해져있다
                    메인 => 서브, 서브=> 메인 둘 다 가능
EXPLA
SELECT *
FROM dept
WHERE deptno IN (SELECT deptno
                 FROM emp);

