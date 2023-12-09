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

/* FEN operators create */
CREATE OR REPLACE FUNCTION fen_eq(fen, fen)
RETURNS boolean
AS 'MODULE_PATHNAME', 'fen_eq'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION fen_contains(fen, fen)
RETURNS boolean
AS 'MODULE_PATHNAME', 'fen_contains'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION fen_contained_by(fen, fen)
RETURNS boolean
AS 'MODULE_PATHNAME', 'fen_contained_by'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION fen_overlap(fen, fen)
RETURNS boolean
AS 'MODULE_PATHNAME', 'fen_overlap'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- Function to extract a value from a fen value
CREATE OR REPLACE FUNCTION fen_compare(internal, internal)
RETURNS integer
AS 'MODULE_PATHNAME', 'fen_compare'
LANGUAGE C STRICT;

-- Function to extract a value from a fen value
CREATE OR REPLACE FUNCTION fen_extract_value(internal, internal, internal)
RETURNS internal
AS 'MODULE_PATHNAME', 'fen_extract_value'
LANGUAGE C STRICT;

-- Function to extract a query from a fen value
CREATE OR REPLACE FUNCTION  fen_extract_query(internal, internal, internal, internal, internal, internal, internal)
RETURNS internal
AS 'MODULE_PATHNAME', 'fen_extract_query'
LANGUAGE C STRICT;

-- Function for GIN index tri-state consistency check
CREATE OR REPLACE FUNCTION fen_triconsistent(internal, internal, internal, internal, internal, internal, internal)
RETURNS internal
AS 'MODULE_PATHNAME', 'fen_triconsistent'
LANGUAGE C STRICT;

CREATE OR REPLACE FUNCTION fen_consistent(internal, internal, internal, internal, internal, internal, internal, internal)
RETURNS boolean
AS 'MODULE_PATHNAME', 'fen_consistent'
LANGUAGE C STRICT;

-- Operator for fen_eq
CREATE OPERATOR = (
  LEFTARG = FEN, RIGHTARG = FEN,
  PROCEDURE = fen_eq,
  COMMUTATOR = =, NEGATOR = <>
);

-- Operator for fen_contains
CREATE OPERATOR @> (
  LEFTARG = FEN, RIGHTARG = FEN,
  PROCEDURE = fen_contains,
  COMMUTATOR = <@, NEGATOR = !@>
);

-- Operator for fen_contained_by
CREATE OPERATOR <@ (
  LEFTARG = FEN, RIGHTARG = FEN,
  PROCEDURE = fen_contained_by,
  COMMUTATOR = @>, NEGATOR = !<@
);

-- Operator for fen_overlap
CREATE OPERATOR && (
  LEFTARG = FEN, RIGHTARG = FEN,
  PROCEDURE = fen_overlap,
  COMMUTATOR = &&, NEGATOR = !&&
);


/* GIN Index */ 
-- Create an operator class for the type "fen" using GIN
CREATE OPERATOR CLASS fen_gin_ops
DEFAULT FOR TYPE fen
USING gin AS
   -- Define operators
   OPERATOR 3  =(fen, fen),
	 OPERATOR	7	 @> (fen,fen),  
	 OPERATOR	8  <@ (fen,fen),
	 OPERATOR	9  && (fen,fen),
   FUNCTION 1 fen_compare(internal, internal),
   FUNCTION 2 fen_extract_value(internal, internal, internal),
   FUNCTION 3 fen_extract_query(internal, internal, internal, internal, internal, internal, internal),
   FUNCTION 4 fen_consistent(internal, internal, internal, internal, internal, internal, internal, internal),
   FUNCTION 5 fen_triconsistent(internal, internal, internal, internal, internal, internal, internal);
