/* Data types */

CREATE OR REPLACE FUNCTION san_in(cstring)
  RETURNS SAN
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE
  AS 'MODULE_PATHNAME';

CREATE OR REPLACE FUNCTION san_out(SAN)
  RETURNS cstring
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE
  AS 'MODULE_PATHNAME';

CREATE OR REPLACE FUNCTION fen_in(cstring)
  RETURNS FEN
  AS 'MODULE_PATHNAME'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION fen_out(FEN)
  RETURNS cstring
  AS 'MODULE_PATHNAME'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE TYPE SAN (
  internallength = 1000,
  input          = san_in,
  output         = san_out
);

CREATE TYPE FEN (
  internallength = 128,
  input = fen_in,
  output = fen_out,
  alignment = double
);

/* Functions */

CREATE FUNCTION get_FirstMoves(SAN, integer)
  RETURNS SAN
  AS 'MODULE_PATHNAME', 'get_FirstMoves'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION has_opening(SAN, SAN)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'has_opening'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION get_board_state(SAN, integer)
  RETURNS FEN
  AS 'MODULE_PATHNAME', 'get_board_state'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION has_Board(SAN, FEN, integer)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'has_Board'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;


CREATE OR REPLACE FUNCTION san_eq(SAN, SAN)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'san_eq'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_lt(SAN, SAN)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'san_lt'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_gt(SAN, SAN)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'san_gt'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_cmp(SAN, SAN)
  RETURNS integer
  AS 'MODULE_PATHNAME', 'san_cmp'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_like(SAN, TEXT) 
  RETURNS BOOLEAN
  AS 'MODULE_PATHNAME', 'san_like'
  LANGUAGE C STRICT IMMUTABLE PARALLEL SAFE;

CREATE FUNCTION san_not_like(SAN, TEXT) 
  RETURNS BOOLEAN 
  AS 'MODULE_PATHNAME', 'san_not_like' 
  LANGUAGE C STRICT IMMUTABLE PARALLEL SAFE;

/* FEN operators create */
CREATE OR REPLACE FUNCTION fen_eq(fen, fen)
RETURNS boolean
AS 'MODULE_PATHNAME', 'fen_eq'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- Function to compare two fen values for less than
CREATE OR REPLACE FUNCTION fen_lt(fen, fen)
RETURNS boolean
AS 'MODULE_PATHNAME', 'fen_lt'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- Function to compare two fen values for greater than
CREATE OR REPLACE FUNCTION fen_gt(fen, fen)
RETURNS boolean
AS 'MODULE_PATHNAME', 'fen_gt'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- Function to compare two fen values
CREATE OR REPLACE FUNCTION fen_cmp(fen, fen)
RETURNS integer
AS 'MODULE_PATHNAME', 'fen_cmp'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- Function to check if a fen value matches a pattern
CREATE OR REPLACE FUNCTION fen_like(fen, TEXT)
RETURNS boolean
AS 'MODULE_PATHNAME', 'fen_like'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- Function to check if a fen value does not match a pattern
CREATE OR REPLACE FUNCTION fen_not_like(fen, TEXT)
RETURNS boolean
AS 'MODULE_PATHNAME', 'fen_not_like'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- Function to extract a value from a fen value
CREATE OR REPLACE FUNCTION fen_extract_value(fen, smallint, internal)
RETURNS internal
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

-- Function to extract a query from a fen value
CREATE OR REPLACE FUNCTION fen_extract_query(fen, smallint, internal)
RETURNS internal
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

-- Function for GIN index consistency check
CREATE OR REPLACE FUNCTION fen_consistent(fen, smallint, internal, internal, internal, internal)
RETURNS boolean
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

-- Function for GIN index tri-state consistency check
CREATE OR REPLACE FUNCTION fen_triconsistent(fen, smallint, internal, internal, internal, internal)
RETURNS boolean
AS 'MODULE_PATHNAME'
LANGUAGE C STRICT;

/* Operators */

CREATE OPERATOR = (
  LEFTARG = SAN, RIGHTARG = SAN,
  PROCEDURE = san_eq,
  COMMUTATOR = =, NEGATOR = <>
);

CREATE OPERATOR < (
  LEFTARG = SAN, RIGHTARG = SAN,
  PROCEDURE = san_lt,
  COMMUTATOR = >, NEGATOR = >=
);

CREATE OPERATOR > (
  LEFTARG = SAN, RIGHTARG = SAN,
  PROCEDURE = san_gt,
  COMMUTATOR = <, NEGATOR = <=
);

CREATE OPERATOR ~~ (
  LEFTARG = SAN,
  RIGHTARG = TEXT,
  PROCEDURE = san_like,
  COMMUTATOR = !~~
);

CREATE OPERATOR !~~ (
  LEFTARG = SAN,
  RIGHTARG = TEXT,
  PROCEDURE = san_not_like
);

/* BTree Index */

CREATE OPERATOR CLASS san_ops 
DEFAULT FOR TYPE san 
USING btree AS
    OPERATOR 1 <,
    OPERATOR 3 =,
    OPERATOR 5 >,
    FUNCTION 1 san_cmp(san, san);

/* Operators for fen */

CREATE OPERATOR = (
  LEFTARG = fen, RIGHTARG = fen,
  PROCEDURE = fen_eq,
  COMMUTATOR = =, NEGATOR = <>
);

CREATE OPERATOR < (
  LEFTARG = fen, RIGHTARG = fen,
  PROCEDURE = fen_lt,
  COMMUTATOR = >, NEGATOR = >=
);

CREATE OPERATOR > (
  LEFTARG = fen, RIGHTARG = fen,
  PROCEDURE = fen_gt,
  COMMUTATOR = <, NEGATOR = <=
);

CREATE OPERATOR ~~ (
  LEFTARG = fen,
  RIGHTARG = TEXT,
  PROCEDURE = fen_like,
  COMMUTATOR = !~~
);

CREATE OPERATOR !~~ (
  LEFTARG = fen,
  RIGHTARG = TEXT,
  PROCEDURE = fen_not_like
);


/* GIN Index */ 
CREATE OPERATOR CLASS fen_gin_ops
DEFAULT FOR TYPE fen
USING gin AS
   OPERATOR        1  <(fen, fen),
   OPERATOR        3  =(fen, fen),
   OPERATOR        5  >(fen, fen),
   FUNCTION        1  fen_consistent(fen, smallint, internal, internal, internal, internal),
   FUNCTION        2  fen_triconsistent(fen, smallint, internal, internal, internal, internal),
   FUNCTION        3  fen_extract_value(fen, smallint, internal),
   FUNCTION        4  fen_extract_query(fen, smallint, internal);
