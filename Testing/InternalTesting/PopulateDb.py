# install this package : psycopg2 with pip

import psycopg2
import psycopg2.extras
import random

# Database connection parameters
db_params = {
    "dbname": "ExtensionTest",
    "user": "postgres",
    "password": "1122",
    "host": "localhost",  # or your database server address
    "port": "5432"
}

# Predefined chess moves
openings = ['e4', 'd4', 'Nf3', 'c4']
middle_game_moves = ['e5', 'd5', 'Nf6', 'c5', 'Nc6', 'Bb5+', 'Bc4', 'Bg5', 'Bxf6', 'Nxd5', 'exd5', 'O-O', 'Re1', 'Bf4', 'h3', 'a3', 'b4', 'c3']
end_game_moves = ['Qd2', 'Rd1', 'h3', 'O-O', 'Re1', 'Bxf6', 'Nxd5', 'Qe2', 'Rae1', 'f4', 'g3', 'Kg2', 'Rf2', 'Qf3', 'Nh4']

def generate_chess_game():
    game = []
    move_number = 1

    # Generate opening move
    game.append(f"{move_number}. {random.choice(openings)}")
    move_number += 1

    # Generate middle game moves
    for _ in range(random.randint(5, 15)):
        move = random.choice(middle_game_moves)
        game.append(f"{move_number}. {move}")
        move_number += 1

    # Generate end game moves
    for _ in range(random.randint(3, 7)):
        move = random.choice(end_game_moves)
        game.append(f"{move_number}. {move}")
        move_number += 1

    return ' '.join(game)

def insert_games_to_db(games):
    connection = None
    try:
        # Connect to the database
        connection = psycopg2.connect(**db_params)
        cursor = connection.cursor()

        # Prepare the INSERT query
        insert_query = "INSERT INTO chess_games (game_notation) VALUES %s"

        # Execute the query in batches
        psycopg2.extras.execute_values(cursor, insert_query, games, template=None, page_size=100)
        connection.commit()
        print(f"{len(games)} games inserted successfully.")

    except psycopg2.DatabaseError as error:
        print(f"Error: {error}")
        connection.rollback()
    finally:
        # Close the connection
        if connection is not None:
            connection.close()

# Generate and insert game notations
number_of_games = 1000000  # Adjust the number of games as needed
games = [(generate_chess_game(),) for _ in range(number_of_games)]
insert_games_to_db(games)