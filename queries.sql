/*Queries that provide answers to the questions from all projects.*/

SELECT name FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE EXTRACT(YEAR FROM date_of_birth) BETWEEN 2016 AND 2019;
SELECT name FROM animals WHERE neutered = TRUE AND escape_attempts <3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT name, neutered FROM animals WHERE neutered = TRUE;
SELECT name FROM animals WHERE NOT (name = 'Gabumon');
SELECT name, weight_kg FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

-- Query to update animals table inside transactions
BEGIN;
UPDATE animals
SET species = 'unspecified';
SELECT name FROM animals WHERE species = 'unspecified';
ROLLBACK;
SELECT * FROM animals;

BEGIN;
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

-- Query to delete, restore and update data in animals table inside transactions
BEGIN;
DELETE FROM animals;
SELECT * FROM animals;

ROLLBACK;
SELECT * FROM animals;

DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT reboot;

UPDATE animals
SET weight_kg = weight_kg * -1;

ROLLBACK TO reboot;

UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

COMMIT;

-- Query with aggregate functions
SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, MAX(escape_attempts) AS max FROM animals GROUP BY neutered;
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

SELECT species, AVG(escape_attempts) FROM animals
WHERE EXTRACT(YEAR FROM date_of_birth) BETWEEN 1990 AND 2000
GROUP BY species;

/* Write queries (using JOIN) to answer the following questions */

-- What animals belong to Melody Pond?
SELECT animals.name, owners.full_name FROM animals 
JOIN owners ON animals.owner_id = owners.id 
WHERE owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name, species.name FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.full_name, animals.name FROM animals 
RIGHT JOIN owners ON animals.owner_id = owners.id;

-- How many animals are there per species?
SELECT count(animals.name), species.name FROM animals 
JOIN species ON animals.species_id = species.id 
GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT owners.full_name, species.name FROM animals 
JOIN owners ON animals.owner_id = owners.id 
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Digimon'
and owners.full_name = 'Jennifer Orwell';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name, owners.full_name FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE animals.escape_attempts=0
and owners.full_name = 'Dean Winchester';

-- Who owns the most animals?
SELECT count(*), owners.full_name FROM animals 
JOIN owners ON animals.owner_id = owners.id
GROUP BY owners.full_name ORDER BY count desc;

-- Who was the last animal seen by William Tatcher?
SELECT animals.name, vets.name, visits.visit_date FROM animals
JOIN visits on animals.id = visits.animal_id
JOIN vets on visits.vet_id = vets.id
WHERE vets.name = 'William Tatcher'
ORDER BY visits.visit_date DESC lIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT vets.name, count(animals.name) FROM animals 
JOIN visits on visits.animal_id = animals.id
JOIN vets on vets.id = visits.vet_id
WHERE vets.name = 'Stephanie Mendez'
GROUP BY vets.name;

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name, species.name FROM vets
LEFT JOIN specializations on specializations.vet_id = vets.id
LEFT JOIN species on specializations.species_id = species.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name, vets.name, visits.visit_date FROM animals 
JOIN visits on visits.animal_id = animals.id
JOIN vets on vets.id = visits.vet_id
WHERE vets.name = 'Stephanie Mendez'
AND visits.visit_date
BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT animals.name, count(*) FROM animals
JOIN visits on visits.animal_id = animals.id
GROUP BY animals.name
ORDER BY count desc limit 1;

-- Who was Maisy Smith's first visit?
SELECT animals.name, vets.name, visits.visit_date FROM animals
JOIN visits on animals.id = visits.animal_id
JOIN vets on visits.vet_id = vets.id
WHERE vets.name = 'Maisy SMith'
ORDER BY visits.visit_date ASC lIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.name, vets.name, visits.visit_date FROM animals
JOIN visits on animals.id = visits.animal_id
JOIN vets on visits.vet_id = vets.id
ORDER BY visits.visit_date DESC lIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) FROM vets 
JOIN visits ON visits.vet_id = vets.id
JOIN animals ON visits.animal_id = animals.id
JOIN specializations ON vets.id = specializations.vet_id
WHERE NOT specializations.species_id = animals.species_id;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT vets.name, species.name, count(species.name) from vets 
JOIN visits on visits.vet_id = vets.id 
JOIN animals on visits.animal_id = animals.id 
JOIN species on animals.species_id = species.id 
WHERE vets.name = 'Maisy SMith' 
GROUP BY species.name, vets.name 
ORDER BY count DESC lIMIT 1;