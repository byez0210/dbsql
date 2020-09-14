--컬럼이 뭘 가르키는지 알기 
cid : customer id
cnm : customer name
SELECT *
FROM customer;

product :제품
pid : product id : 제품 번호
pnm : product name : 제품 이름
SELECT *
FROM product;


cycle : 고객애음주기
cid : cycle id 고객 id
pid  : product id 제품 id
day : 1-7 (일-토)
cnt : COUNT, 수량
SELECT *
FROM cycle;

실습 JOIN4]
SELECT customer.cid,customer.cnm, cycle.pid, cycle.day, cycle.cnt 
FROM customer , cycle
WHERE customer.cid = cycle.cid AND cnm IN('brown', 'sally');

SELECT customer.*, cycle.pid, cycle.day, cycle.cnt 
FROM customer , cycle
WHERE customer.cid = cycle.cid AND cnm IN('brown', 'sally');

실습 JOIN5]
SQL : 실행에 대한 순서가 없다
      조인할 테이블에 대해소  FROM절에 기술한 순으로 테이블을 읽지 않음.
      FROM costomer, cycle,product ==> 오라클에서는 product 테이블부터 읽을 수도 있다
     
EXPLAIN PLAN FOR      
SELECT customer.cid,customer.cnm, product.pid, product.pnm,cycle.day, cycle.cnt 
FROM customer, cycle, product
WHERE customer.cid = cycle.cid 
  AND product.pid = cycle.pid 
  AND cnm IN('brown', 'sally');

SELECT*
FROM TABLE(dbms_xplan_display);

실습 JOIN6]
SELECT customer.cid,customer.cnm, cycle.pid, product.pnm, sum(cycle.cnt) cnt 
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND  product.pid = cycle.pid
GROUP BY cycle.pid, customer.cid,  product.pnm, customer.cnm;

실습 JOIN7]
SELECT c.pid ,p.pnm, sum(c.cnt)
FROM cycle c, product p
WHERE  p.pid = c.pid
GROUP BY c.pid, p.pnm;

실습 JOIN8] 
SELECT r.region_id, r.region_name, c.country_name
FROM regions r, countries c
WHERE r.region_id = c.region_id AND r.region_name = 'Europe';

실습 JOIN9] 
SELECT r.region_id, r.region_name, c.country_name, l.city
FROM regions r, countries c, locations l
WHERE r.region_id = c.region_id AND c.country_id = l.country_id AND  r.region_name = 'Europe';


실습 JOIN10]
SELECT r.region_id, r.region_name, c.country_name, l.city, d.department_name
FROM countries c, locations l, regions r,departments d
WHERE  r.region_id = c.region_id AND c.country_id = l.country_id 
  AND l.location_id = d.location_id AND  r.region_name = 'Europe';


실습 JOIN11] X
SELECT r.region_id, r.region_name, c.country_name, l.city, d.department_name , e.
FROM countries c, locations l, regions r,departments d, employees e
WHERE  r.region_id = c.region_id AND c.country_id = l.country_id 
  AND l.location_id = d.location_id AND  d.department_id = e. department_id AND r.region_name = 'Europe';
  
실습 JOIN12]
SELECT e.employee_id, j.job_id, j.job_title
FROM employees e, jobs j
WHERE  e.job_id = j.job_id;

실습 JOIN13] 
SELECT e.employee_id, CONCAT(e.first_name, e.last_name) mgr_name, m.employee_id ,CONCAT(m.first_name, m.last_name) name,j.job_id, j.job_title
FROM employees e, employees m, jobs j
WHERE m.job_id = j.job_id 
 AND m.manager_id = e.employee_id;

SELECT *
FROM jobs;
SELECT *
FROM employees;
JOIN구분
1. 문법에 따른 구분: ANSI-SQL, ORACLE
2. join의 형태에 따른 구분 : SELF-JOIN,NOMEQUI-JOIN, CROSS-JOIN
3. join 성공여부에 따라 데이터 표시여부: 
        : INNER JOIN - 조인이 성공했을 때 데이터를 표시
        : OUTER JOIN - 도인이 실패해도 기준으로 정한 테이블이 컬럼 정보는 표시

사번,사번이름, 관리자 사번, 관리자 이름
KING (PRESIDENT)의 경우 MGR 컬럼의 값이 NULL이기 때문에 
조인에 실패 ==> 13건 조회
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

ANSI-SQL -- JOIN을 기준으로 실행됨
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON(e.mgr = m.empno);

행에 대한 제한 조건 기술시 WHERE 절에 기술했을 때와 ON 절에 기술 했을 때 결과 다르다

사원의 부서가 10번인 사람들만 조회 되도록 부서번호 조건을 추가
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno AND e.deptno =10);

조건을 WHERE 절에 기술한 경우 ==> OUTER JOIN이 아닌 INNER 조인 결과가 나온다
SELECT e.empno, e.ename,e.deptno, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
WHERE e.deptno =10;

SELECT e.empno, e.ename,e.deptno, e.mgr, m.ename, m.deptno
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno)
WHERE e.deptno =10;

ORACLE-SQL :데이터가 없는 쪽의 컬럼에 (+) 기호를 붙인다
            ANSI-SQL 기준 테이블 반대편 테이블 컬럼에(-)을 붙인다
            WHERE 절 연결 조건에 적용

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m 
WHERE e.mgr = m.empno(+)
 AND m.deptno(+)= 10; -- 데이터 없는 쪽에 다붙여준다 
 
SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
UNION --합집합
SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)
MINUS
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
UNION --합집합
SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)
INTERSECT 
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);


SELECT *
FROM prod;
SELECT*
FROM buyprod;
WHERE BUY_DATE = TO_DATE('2005/01/25','YYYY/MM/DD');

실습outerjoin1]
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p 
WHERE p.prod_id = b.buy_prod(+) AND b.BUY_DATE(+) = TO_DATE('2005/01/25','YYYY/MM/DD');

ANSI-SQL 
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p 
ON( p.prod_id = b.buy_prod AND b.BUY_DATE = TO_DATE('2005/01/25','YYYY/MM/DD'));
 
실습outerjoin2]

