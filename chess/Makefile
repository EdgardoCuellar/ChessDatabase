EXTENSION   = chessboard
MODULES 	= chessboard
DATA        = chessboard--1.0.sql chessboard.control

CC = gcc
CFLAGS = -I/usr/include/postgresql/server -fpic -shared

PG_CONFIG ?= pg_config
PGXS = $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
