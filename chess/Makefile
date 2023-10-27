EXTENSION   = chess
MODULES 	= chess
DATA        = chess--1.0.sql chess.control

CC = gcc
CFLAGS = -I/usr/include/postgresql/server -fpic -shared

PG_CONFIG ?= pg_config
PGXS = $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
