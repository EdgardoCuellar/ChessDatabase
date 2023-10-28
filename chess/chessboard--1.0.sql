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

/******************************************************************************
 * Constructor
 ******************************************************************************/

CREATE OR REPLACE FUNCTION chessboard(text)
  RETURNS chessboard
  AS 'MODULE_PATHNAME', 'chessboard_constructor'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;


