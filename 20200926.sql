START WITH : 계층쿼리의 시작 점(행), 여러개의 행을 조회하는 조건이 들어갈 수 있다
            START WITH절에 의해 선택된 행이 어려개이면, 순차적으로 진행한다
            
CONNECT BY : 행과 행을 연결할 조건을 기술

PRIOR : 현재 읽은 행을 지칭

**PRIOR 키워드는 CONNECT BY 바로 다음에 나오지 않아도 된다
CONNECT BY PRIOR deptcd = P_deptcd;
CONNECT BY P_deptcd = PRIOR deptcd;

**연결조건이 두개 이상일 때
CONNECT BY PRIOR P = q AND PRIOR a = b;

실습 h_1]
SELECT deptcd, LPAD(' ',(LEVEL-1)*3) || deptnm deptnm, LEVEL
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = P_deptcd;

실습 h_2] -- 조직도 할 때 많이 사용
SELECT LEVEL lv,deptcd, LPAD(' ',(LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = P_deptcd;


계층쿼리 - 상향식
디자인팀(dept0_00_0)부터 시작하여 자신의 상위 부서로 연결하는 쿼리

실습 h_3]
SELECT LEVEL lv, deptcd, LPAD(' ',(LEVEL-1)*3) || deptnm deptno, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd =deptcd;

create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

SELECT *
FROM h_sum;

실습 h_4]
SELECT LPAD(' ',(LEVEL-1)*3) || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id; 

pruning branch : 가지치기
SELECT 쿼리 처음 배울 때, 설명해준 SQL 구문 실행순서
FROM -> WHERE -> GROUP BY -> SELECT -> ORDER BY

SELECT 쿼리에 START WITH, CONNECT BY절에 있을 경우
FROM -> START WITH, CONNECT BY -> WHERE ....

하향식 쿼리로 데이터 조회
SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptcd != 'dept0_01';

현재 읽은 행의 deptcd 값이 앞으로 읽을 행의 deptcd 컬럼과 같고
앞으로 읽을 행의 dept_cd 컬럼의 값이 'dept0_01'이 아닐 때 연결하겠다

==> XX회사 밑에는 디자인부, 정부기획부, 정보시스템부 3개의 부가 있는데
    그 중에서 정부기획부를 제외한 2개의 부서에 대해서만 연결하겠다

행 제한조건을 WHERE 절에 기술했을 경우
FROM -> START WITH -> WHERE 절 순으로 실행되기 때문에
1. 계층 탐색을 전부 완료한 후
2. WHERE 절에 해당하는 행만 데이터를 제외한다
SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm
FROM dept_h
WHERE deptcd != 'dept0_01'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd ;
-- CONNECT BY 에 했을 때랑 WHERE에 기술했을 떄랑 결과가 다름 

계층쿼리 특수함수(오라클 사용자에게는 중요한 함수)
CONNECT_BY_ROOT(col) : 최상위 행의 컬럼 값 조회
SYS_CONNECT_BY_PATH(col,구분자) : 계층 순회경로를 표현
CONNECT_BY_ISLEAF : 해당 행이 leaf node (자식이 없는 노드) 인지 여부를 반환
                    (1: leaf node, 0 : no leaf node)
                
SELECT deptcd , LPAD(' ', (LEVEL-1)*3) || deptnm,
        CONNECT_BY_ROOT(deptnm) cbr,
        LTRIM(SYS_CONNECT_BY_PATH(deptnm,'-'),'-') scbp,
        CONNECT_BY_ISLEAF CBI
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

CONNECT BY LEVEL 계층쿼리 : CROSS JOIN 과 유사
연결가능한 모든 행에 대해 계층으로 연결

dual테이블에는 행이 하나

SELECT dummy, LEVEL, LTRIM(SYS_CONNECT_BY_PATH(dummy,'-','-')scbp
FROM dual
CONNECT BY LEVEL <=10;

commit;
CREATE table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덜번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
COMMIT;

SELECT *
FROM board_test;

실습 h6]
SELECT  seq, LPAD(' ',(LEVEL-1)*3) || title tile
FROM board_test 
START WITH seq IN (1,2,4)
CONNECT BY PRIOR seq = parent_seq;

실습 h7]
SELECT  seq, LPAD(' ',(LEVEL-1)*3) || title tile
FROM board_test 
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY seq DESC; 

실습 h8]
1.CONNECT_BY_ROOT를 활용한 그룹번호 생성
SELECT *
FROM
(SELECT  seq, LPAD(' ',(LEVEL-1)*3) || title tile, CONNECT_BY_ROOT(seq) gn
FROM board_test 
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq)
ORDER BY gn DESC,seq ASC;--계층쿼리가 깨지지 않게 하면서 정렬

2. gn (NUMBER) 컬럼을 테이블에 추가
ALTER TABLE board_test ADD(gn NUMBER);
UPDATE board_test SET gn = 1
WHERE seq IN (1,9);

UPDATE board_test SET gn = 2
WHERE seq IN (2,3);

UPDATE board_test SET gn = 4
WHERE seq NOT IN (1,2,3,9);
COMMIT;

SELECT  seq, LPAD(' ',(LEVEL-1)*3) || title tile
FROM board_test 
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq ASC;

분석함수, 윈도우 함수
사원 중에 가장 많은 급여를 받는 사람의 정보 조회(empeno,ename,sal)
SELECT empno, ename, sal
FROM emp
WHERE sal = (SELECT MAX(sal)
               FROM emp);
            
SQL의 단점 : 행간 연산이 부족 => 해당 부분을 보완 해주는 것이 분석함수(윈도우 함수)
부서 몇명 SAL값을 알아야함

실습ana0] 부서별 급여 랭크
SELECT ename,sal,deptno, 
       RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) sal_rank
FROM emp;

분석함수를 사용하지 않고 위와 동일한 결과를 만들어 내는 것이 가능
(*** 분석함수가 모든 DBMS에서 제공을 하지는 않음)

SELECT *
FROM
    (SELECT ename, sal, deptno, ROWNUM rn
      FROM
        (SELECT ename, sal, deptno
          FROM emp
          ORDER BY deptno, sal DESC))a,

(SELECT deptno, lv, ROWNUM rn 
 FROM
    (SELECT a.deptno, b.lv
     FROM
        (SELECT deptno, COUNT(*) cnt -- 부서별 순위를 만들어내기 위해
         FROM emp
         GROUP BY deptno)a,
         
    (SELECT LEVEL lv
    FROM dual
    CONNECT BY LEVEL <= (SELECT COUNT(*) FROM emp))b
    WHERE a.cnt >= b.lv 
    ORDER BY a.deptno,b.lv)) b
WHERE a.rn = b.rn;

분석함수/윈도우 함수 문법
SELECT 윈도우 함수이름([인자]) OVER 
        ([PARTITION BY columns][ORDER BY columns [WINDOWING]])
PARTITION BY : 영역설정
ORDER BY : 영역내에서 순서 설정 (RANK, ROW_NUMBER)
WINDOWING : 파티션 내에서 범위설정

순위관련 분석함수 - 동일 값에 대한 순위처리에 따라 3가지 함수를 제공
RANK : 동일값에 대해 동일순위 부여
       후순위 : 1등이 2명이면 그 다음 순위가 3위 (1 1 3)
DENSE_RANK : 동일값에 대해 동일 순위 부여 
             후순위 : 1등 2명이면 그 다음 순위가 2위 (1 1 2)
ROW_NUMBER : 동일값이라도 다른 순위를 부여 (1 2 3)

SELECT ename, sal, deptno, 
       RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank,
       DENSE_rank() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_DENSE_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_ROW_NUMBER 
FROM emp;

실습ana1]
SELECT empno, ename, sal, deptno, 
       RANK() OVER (ORDER BY sal DESC,empno) sal_rank,
       DENSE_rank() OVER (ORDER BY sal DESC, empno) sal_DENSE_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC, empno) sal_ROW_NUMBER 
FROM emp;


분석함수- 집계함수 
SUM(col), MIN(col), MAX(col), COUNT(col*), avg(col)

실습no _ana2]
사원번호, 사원이름, 소속부서번호, 소속된 부서의 사원 수 
SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

실습ana2]
SELECT empno, ename, sal, deptno, 
       ROUND(AVG(sal) OVER (PARTITION BY deptno) ,2) AVG_sal
FROM emp;

분석함수를 사용하지 않고 구하기

SELECT empno, ename, sal, emp.deptno, a.avg_sal
FROM emp,
    (SELECT deptno, ROUND(AVG(sal),2) avg_sal
     FROM emp
     GROUP BY deptno) a 
WHERE emp.deptno = a.deptno;

실습ana3]
SELECT empno, ename, sal, deptno, 
       MAX(sal) OVER (PARTITION BY deptno) MAX_sal
FROM emp;

실습ana4]
SELECT empno, ename, sal, deptno,
       MIN(sal) OVER (PARTITION BY deptno) MIN_sal
FROM emp;