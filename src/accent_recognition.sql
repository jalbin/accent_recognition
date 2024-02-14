-- Drop SCHEMA if they exist
DROP SCHEMA IF EXISTS accents;

-- Create SCHEMA
CREATE SCHEMA accents;

-- Create database
CREATE DATABASE IF NOT EXISTS accents;

USE accents;

-- Drop tables if they exist
DROP TABLE IF EXISTS kaggle_recs;
DROP TABLE IF EXISTS kaggle_all;
DROP TABLE IF EXISTS saa_lang;
DROP TABLE IF EXISTS saa_recs;
DROP TABLE IF EXISTS saa_locations;
DROP TABLE IF EXISTS saa_bios;

-- Create the table saa_lang
CREATE TABLE saa_lang (
  language_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  language VARCHAR(255) NOT NULL,
  PRIMARY KEY  (language_id)
);

-- Create the table saa_locations
CREATE TABLE saa_locations (
  location_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  location VARCHAR(255) NOT NULL,
  PRIMARY KEY  (location_id)
) ;


-- Create the table saa_recs
CREATE TABLE saa_recs (
  speaker_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  filename VARCHAR(255),
  PRIMARY KEY  (speaker_id)
);
-- Create the table saa_bios
CREATE TABLE saa_bios (
    speaker_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    birth_place VARCHAR(255),
    city VARCHAR(255),
    native_language VARCHAR(255),
    other_languages VARCHAR(255),
    age FLOAT,
    sex VARCHAR(255),
    age_of_english_onset VARCHAR(255),
    english_learning_method VARCHAR(255),
    english_residence VARCHAR(255),
    length_of_english_residence VARCHAR(255),
    language VARCHAR(255),
	language_id SMALLINT UNSIGNED NOT NULL,
    location_id SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY  (speaker_id),
	KEY idx_fk_location_id (location_id),
	KEY idx_fk_language_id (language_id),
    CONSTRAINT fk_saa_bios_location_id FOREIGN KEY (location_id) REFERENCES saa_locations (location_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_saa_bios_language_id FOREIGN KEY (language_id) REFERENCES saa_lang (language_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
-- Create kaggle_all table
CREATE TABLE kaggle_all (
    age INT NOT NULL,
    age_onset INT NOT NULL,
    birthplace VARCHAR(255),
    filename VARCHAR(255),
    native_language VARCHAR(255),
    sex VARCHAR(255),
    speaker_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    country VARCHAR(255),
    file_missing BOOLEAN,
    last_col1 VARCHAR(255),
    last_col2 VARCHAR(255),
    PRIMARY KEY  (speaker_id),
    CONSTRAINT fk_saa_recs_kaggle_all FOREIGN KEY (speaker_id) REFERENCES saa_recs(speaker_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_saa_bios_kaggle_all FOREIGN KEY (speaker_id) REFERENCES saa_bios(speaker_id) ON DELETE RESTRICT ON UPDATE CASCADE
);


-- Create the table kaggle_recs
CREATE TABLE kaggle_recs (
  speaker_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  filename VARCHAR(255),
  PRIMARY KEY  (speaker_id),
  CONSTRAINT fk_kaggle_all_kaggle_recs FOREIGN KEY (speaker_id) REFERENCES kaggle_all(speaker_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
