CREATE EXTENSION complex;

CREATE TABLE t (id integer, z complex);

INSERT INTO t VALUES
(1, '(1, 0)'),
(2, '(0, 1)'),
(3, '(-1, 0)'),
(4, '(0, -1)');

SELECT * FROM t;

SELECT z as z, 
    re(z) as "Re(z)", 
    im(z) as "Im(z)"
--  conjugate(z) as "z*"
FROM t;

SELECT * FROM t WHERE z << '(0, 0)';
-- SELECT * FROM t WHERE z >> '(0, 0)';
SELECT * FROM t WHERE z <<| '(0, 0)';
-- SELECT * FROM t WHERE z |>> '(0, 0)';

SELECT a.z as a, 
    b.z as b, 
    a.z + b.z as "a + b", 
--  a.z - b.z as "a - b",
--  a.z * b.z as "a*b", 
    a.z / b.z as "a / b",
    a.z <-> b.z as "a <-> b"
FROM t a, t b;