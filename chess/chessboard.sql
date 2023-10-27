\echo Use "CREATE EXTENSION chessboard" to load this file. \quit

/******************************************************************************
 * Input/Output
 ******************************************************************************/

CREATE OR REPLACE FUNCTION chessboard_in(cstring)
  RETURNS chessboard
  AS 'MODULE_PATHNAME'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION chessboard_out(chessboard)
  RETURNS cstring
  AS 'MODULE_PATHNAME'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE TYPE chessboard (
  internallength = -1,
  input          = chessboard_in,
  output         = chessboard_out,
  alignment      = double
);

CREATE OR REPLACE FUNCTION chessboard(text)
  RETURNS chessboard
  AS 'MODULE_PATHNAME', 'chessboard_cast_from_text'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION text(chessboard)
  RETURNS text
  AS 'MODULE_PATHNAME', 'chessboard_cast_to_text'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE CAST (text as chessboard) WITH FUNCTION chessboard(text) AS IMPLICIT;
CREATE CAST (chessboard as text) WITH FUNCTION text(chessboard);

/******************************************************************************
 * Constructor
 ******************************************************************************/

CREATE FUNCTION chessboard(text)
  RETURNS chessboard
  AS 'MODULE_PATHNAME', 'chessboard_constructor'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

/*****************************************************************************
 * Accessing values
 *****************************************************************************/

/* Define functions for accessing values in the chessboard */

/******************************************************************************
 * Operators
 ******************************************************************************/

/* Define operators for comparing chessboards */

/******************************************************************************/

CREATE FUNCTION chessboard_add(chessboard, chessboard)
  RETURNS chessboard
  AS 'MODULE_PATHNAME', 'chessboard_add'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

/* Define subtraction and multiplication functions for chessboards */

/******************************************************************************/

CREATE FUNCTION chessboard_dist(chessboard, chessboard)
  RETURNS double precision
  AS 'MODULE_PATHNAME', 'chessboard_dist'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR <-> (
  LEFTARG = chessboard, RIGHTARG = chessboard,
  PROCEDURE = chessboard_dist,
  COMMUTATOR = <->
);

/******************************************************************************/

