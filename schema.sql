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