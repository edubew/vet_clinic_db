/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50),
    date_of_birth DATE,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg DECIMAL
);

ALTER TABLE animals
ADD species VARCHAR(50);

-- Owners table
CREATE TABLE owners (
    id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    age INT
);

-- Species table
CREATE TABLE species (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50)
);

-- Modify animals table
ALTER TABLE animals
DROP COLUMN species;

ALTER TABLE animals
ADD species_id INT REFERENCES species(id);

ALTER TABLE animals
ADD owner_id INT REFERENCES owners(id);

-- Create a table for the vets
CREATE TABLE vets (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255),
    age INT,
    date_of_graduation DATE
);

-- Create a join table for the specializations
CREATE TABLE specializations (
    species_id INT,
    vet_id INT,
    PRIMARY KEY (species_id, vet_id),
    FOREIGN KEY (species_id) REFERENCES species(id),
    FOREIGN KEY (vet_id) REFERENCES vets(id)
);

-- Create visits table to join animals table and vets table
CREATE TABLE visits (
    animal_id INT,
    vet_id INT,
    visit_date DATE,
    PRIMARY KEY (animal_id, vet_id, visit_date),
    FOREIGN KEY (animal_id) REFERENCES animals (id),
    FOREIGN KEY (vet_id) REFERENCES vets (id)
);

   