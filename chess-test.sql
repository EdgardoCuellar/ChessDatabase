CREATE EXTENSION chessboard;

CREATE TABLE chess_games (
    id serial PRIMARY KEY,
    board chessboard
);

INSERT INTO chess_games (board) VALUES ('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1');

INSERT INTO chess_games (board) VALUES ('rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2');

SELECT * FROM chess_games;