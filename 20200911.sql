실습join1]
SELECT prod_lgu, lprod_nm, prod_id, prod_name
FROM prod prod, lprod lprod
WHERE prod.prod_lgu = lprod.lprod_gu;

실습join2]
SELECT p.prod_buyer, b.buyer_name, p.prod_id, p.prod_name
FROM prod p, buyer b
WHERE p.prod_buyer = b.buyer_id;


실습join3]
join시 생각할 부분
1. 테이블 기술
2. 연결조건
ORACLE]
SELECT m.mem_id , m.mem_name, p.prod_id, p.prod_name, c.cart_qty
FROM member m, cart c , prod p 
WHERE c.cart_prod = p.prod_id AND m.mem_id = c.cart_member;
ANSI-SQL]
테이블 JOIN 테이블 ON()
      JOIN 테이블 ON()
      
SELECT m.mem_id , m.mem_name, p.prod_id, p.prod_name, c.cart_qty
FROM member m JOIN cart c ON(m.mem_id = c.cart_member)
              JOIN prod p ON(c.cart_prod = p.prod_id);



