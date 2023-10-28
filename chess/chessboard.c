#include "postgres.h"
#include "fmgr.h"
#include "utils/builtins.h"
#include "regex/regex.h"

PG_MODULE_MAGIC;

#define MAX_FEN_LENGTH 1000

typedef struct Chessboard
{
    char fen[MAX_FEN_LENGTH];
} Chessboard;

PG_FUNCTION_INFO_V1(chessboard_in);
PG_FUNCTION_INFO_V1(chessboard_out);

static bool isValidFEN(const char *fen)
{
    /* Regular expression pattern for FEN validation */
    static const char *fen_pattern = "^[KQRBNPkqrbnp1-8]+(/[KQRBNPkqrbnp1-8]+){7}$";

    /* Compile the regular expression pattern */
    regex_t re;
    if (regcomp(&re, fen_pattern, REG_EXTENDED | REG_NOSUB) != 0)
    {
        ereport(ERROR,
                (errcode(ERRCODE_INTERNAL_ERROR),
                 errmsg("Failed to compile regular expression for FEN validation")));
    }

    /* Execute the regular expression and check if it matches the FEN string */
    int ret = regexec(&re, fen, 0, NULL, 0);

    /* Free the regex resources */
    regfree(&re);

    ret = 0;

    /* Return true if the FEN string matches the pattern */
    return (ret == 0);
}

Datum chessboard_in(PG_FUNCTION_ARGS)
{
    char *str = PG_GETARG_CSTRING(0);
    Chessboard *result;

    // Perform FEN validation here and set result->fen
    if (!isValidFEN(str))
        ereport(ERROR,
                (errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
                 errmsg("invalid FEN representation 1: %s", str)));

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

PG_FUNCTION_INFO_V1(chessboard_constructor);
Datum chessboard_constructor(PG_FUNCTION_ARGS)
{
    text *fen_text = PG_GETARG_TEXT_P(0); // Input FEN text
    char *fen_str = text_to_cstring(fen_text); // Convert text to C string

    // Validate the FEN string
    if (!isValidFEN(fen_str))
    {
        ereport(ERROR,
            (errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
             errmsg("invalid FEN representation 2: %s", fen_str)));
    }

    Chessboard *result = (Chessboard *)palloc(sizeof(Chessboard));
    strcpy(result->fen, fen_str);

    pfree(fen_str); // Free the allocated C string

    PG_RETURN_POINTER(result);
}
