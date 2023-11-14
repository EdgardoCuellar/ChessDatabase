\echo Use "CREATE EXTENSION chessboard" to load this file. \quit

/******************************************************************************

    Input/Output
    ******************************************************************************/

-- Create or replace the input function for chessboard
CREATE OR REPLACE FUNCTION chessboard_in(cstring)
RETURNS chessboard
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- Create or replace the output function for chessboard
CREATE OR REPLACE FUNCTION chessboard_out(chessboard)
RETURNS cstring
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- Create or replace the receive function for chessboard
CREATE OR REPLACE FUNCTION chessboard_recv(internal)
RETURNS chessboard
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- Create or replace the send function for chessboard
CREATE OR REPLACE FUNCTION chessboard_send(chessboard)
RETURNS bytea
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- Create the custom type chessboard
CREATE TYPE chessboard (
internallength = 128,
input = chessboard_in,
output = chessboard_out,
receive = chessboard_recv,
send = chessboard_send,
alignment = double
);

-- Create or replace the constructor function for chessboard
CREATE OR REPLACE FUNCTION chessboard_constructor(text)
RETURNS chessboard
AS 'MODULE_PATHNAME', 'chessboard_constructor'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;