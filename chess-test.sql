CREATE EXTENSION chessboard;

CREATE TABLE chess_games (
    id serial PRIMARY KEY,
    board chessboard
);

INSERT INTO chess_games (board) VALUES ('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1');

SELECT * FROM chess_games;