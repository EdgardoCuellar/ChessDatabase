CREATE EXTENSION chessboard;

CREATE TABLE chess_games (
    id serial PRIMARY KEY,
    board chessboard
);

INSERT INTO chess_games VALUES "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNRwKQkq-01", "8/5k2/3p4/1p1Pp2p/pP2Pp1P/P4P1K/8/8b--9950";

SELECT * FROM chess_games;