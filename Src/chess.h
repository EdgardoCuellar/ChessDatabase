/*
 * chess.h
 *      Header file for the PostgreSQL extension implementing chess-related functionalities.
 *
 * This header file declares the functions for handling chess data types and operations
 * such as SAN (Standard Algebraic Notation) and FEN (Forsyth-Edwards Notation).
 * It includes function declarations for input and output functions, as well as other
 * utility functions related to chess.
 *
 */

#include "postgres.h"
#include "utils/varlena.h"
#include "fmgr.h"
#include "utils/elog.h"
#include "utils/builtins.h"
#include "libpq/pqformat.h"
#include "DataTypes/SAN/SAN.h"
#include "DataTypes/FEN/FEN.h"

#include "access/gin.h"

#ifndef CHESS_H
#define CHESS_H

// Macros to simplify retrieving and returning chessgame data types in PostgreSQL functions.
#define PG_GETARG_CHESSGAME_P(n) ((SAN *)PG_GETARG_POINTER(n))
#define PG_RETURN_CHESSGAME_P(p) PG_RETURN_POINTER(p)

PG_MODULE_MAGIC;

/* Chess datatypes */

PG_FUNCTION_INFO_V1(san_in);
Datum san_in(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(san_out);
Datum san_out(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(fen_in);
Datum fen_in(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(fen_out);
Datum fen_out(PG_FUNCTION_ARGS);

/* Chess Functions */

PG_FUNCTION_INFO_V1(has_Board);
Datum has_Board(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(has_opening);
Datum has_opening(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(get_FirstMoves);
Datum get_FirstMoves(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(get_board_state);
Datum get_board_state(PG_FUNCTION_ARGS);

/* Chess Indexes (BTree) */

PG_FUNCTION_INFO_V1(san_eq);
Datum san_eq(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(san_lt);
Datum san_lt(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(san_gt);
Datum san_gt(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(san_cmp);
Datum san_cmp(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(san_like);
Datum san_like(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(san_not_like);
Datum san_not_like(PG_FUNCTION_ARGS);

/* FEN Operators */

PG_FUNCTION_INFO_V1(fen_eq);
Datum fen_eq(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(fen_lt);
Datum fen_lt(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(fen_gt);
Datum fen_gt(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(fen_cmp);
Datum fen_cmp(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(fen_like);
Datum fen_like(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(fen_not_like);
Datum fen_not_like(PG_FUNCTION_ARGS);

/* GIN INDEXES */

PG_FUNCTION_INFO_V1(fen_extract_value);
Datum fen_extract_value(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(fen_extract_query);
Datum fen_extract_query(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(fen_consistent);
Datum fen_consistent(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(fen_triconsistent);
Datum fen_triconsistent(PG_FUNCTION_ARGS);

#endif // CHESS_H
