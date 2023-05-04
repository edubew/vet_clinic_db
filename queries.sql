/*Queries that provide answers to the questions from all projects.*/

SELECT name FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE EXTRACT(YEAR FROM date_of_birth) BETWEEN 2016 AND 2019;
SELECT name FROM animals WHERE neutered = TRUE AND escape_attempts <3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT name, neutered FROM animals WHERE neutered = TRUE;
SELECT name FROM animals WHERE NOT (name = 'Gabumon');
SELECT name, weight_kg FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

-- Transaction1 starts
BEGIN;

UPDATE animals
SET species = 'unspecified';

SELECT name FROM animals WHERE species = 'unspecified';

ROLLBACK;
-- Transaction1 ends

-- Transaction 2 starts
BEGIN;
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

COMMIT;
SELECT * FROM animals;
-- Transaction 2 ends
