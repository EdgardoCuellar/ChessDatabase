#include "postgres.h"
#include "fmgr.h"
#include "utils/builtins.h"
#include "utils/array.h"

PG_MODULE_MAGIC;

typedef struct Chessboard
{
    char fen[100];
} Chessboard;

PG_FUNCTION_INFO_V1(chessboard_in);
PG_FUNCTION_INFO_V1(chessboard_out);

Datum chessboard_in(PG_FUNCTION_ARGS)
{
    char *str = PG_GETARG_CSTRING(0);
    Chessboard *result;
    // Perform FEN validation here and set result->fen
    // If FEN is invalid, raise an error using ereport().
    if (!isValidFEN(str))
        ereport(ERROR,
                (errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
                 errmsg("invalid FEN representation: %s", str)));
    
    result = (Chessboard *)palloc(sizeof(Chessboard));
    strcpy(result->fen, str);
    PG_RETURN_POINTER(result);
}

Datum chessboard_out(PG_FUNCTION_ARGS)
{
    Chessboard *cb = (Chessboard *)PG_GETARG_POINTER(0);
    char *result = pstrdup(cb->fen);
    PG_RETURN_CSTRING(result);
}

PG_FUNCTION_INFO_V1(chessboard_typmod_in);
PG_FUNCTION_INFO_V1(chessboard_typmod_out);

Datum chessboard_typmod_in(PG_FUNCTION_ARGS)
{
    int32 typmod = PG_GETARG_INT32(0);
    // Perform type modification validation here, if needed.
    PG_RETURN_INT32(typmod);
}

Datum chessboard_typmod_out(PG_FUNCTION_ARGS)
{
    int32 typmod = PG_GETARG_INT32(0);
    // Convert type modification to a string representation, if needed.
    PG_RETURN_INT32(typmod);
}

PG_FUNCTION_INFO_V1(chessboard_eq);
PG_FUNCTION_INFO_V1(chessboard_ne);

Datum chessboard_eq(PG_FUNCTION_ARGS)
{
    Chessboard *a = (Chessboard *)PG_GETARG_POINTER(0);
    Chessboard *b = (Chessboard *)PG_GETARG_POINTER(1);

    PG_RETURN_BOOL(strcmp(a->fen, b->fen) == 0);
}

Datum chessboard_ne(PG_FUNCTION_ARGS)
{
    Chessboard *a = (Chessboard *)PG_GETARG_POINTER(0);
    Chessboard *b = (Chessboard *)PG_GETARG_POINTER(1);

    PG_RETURN_BOOL(strcmp(a->fen, b->fen) != 0);
}
