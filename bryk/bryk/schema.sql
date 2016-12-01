CREATE TABLE "user" (
    "user_id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "username" TEXT,
    "password" TEXT
);

CREATE TABLE "kategoria" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "przodek" INTEGER,
    "opis" TEXT
);

CREATE TABLE "zagadnienie" (
    "id" INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,
    "kategoria_id" INTEGER,
    "user_id" INTEGER,
    "tytul" TEXT,
    "opis" TEXT,
    "py_rys" TEXT,
    "py_skrypt" TEXT
);


CREATE TABLE "zagadnienie_par" (
    "id" INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,
    "zagadnienie_id" INTEGER,
    "nazwa" TEXT,
    "wartosc" TEXT
);


CREATE TABLE historia (
    "id" INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,
    "zagadnienie_id" INTEGER NOT NULL,
    "dt" INTEGER,
    "tytul" TEXT,
    "opis" TEXT,
    "py_rys" TEXT,
    "py_skrypt" TEXT, 
    "user_id" INTEGER
);
