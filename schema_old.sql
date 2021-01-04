CREATE TABLE IF NOT EXISTS "distribution" (
  "taxonID" integer NOT NULL,
  "locationID" varchar(255) default NULL,
  "locality" text,
  "occurrenceStatus" varchar(255) default NULL,
  "establishmentMeans" varchar(255) default NULL
);

CREATE TABLE IF NOT EXISTS "description" (
  "taxonID" integer NOT NULL,
  "description" text
);

CREATE TABLE IF NOT EXISTS "reference" (
  "taxonID" integer NOT NULL,
  "creator" varchar(255) default NULL,
  "date" varchar(255) default NULL,
  "title" varchar(255) default NULL,
  "description" text,
  "identifier" varchar(255) default NULL,
  "type" varchar(255) default NULL
);

CREATE TABLE IF NOT EXISTS "speciesprofile" (
  "taxonID" integer NOT NULL,
  "habitat" varchar(255) default NULL
);

CREATE TABLE IF NOT EXISTS "taxa" (
  "taxonID" integer NOT NULL PRIMARY KEY,
  "identifier" varchar(255) default NULL,
  "datasetID" varchar(255) default NULL,
  "datasetName" varchar(255) default NULL,
  "acceptedNameUsageID" integer default NULL,
  "parentNameUsageID" integer default NULL,
  "taxonomicStatus" varchar(255) default NULL,
  "taxonRank" varchar(255) default NULL,
  "verbatimTaxonRank" varchar(255) default NULL,
  "scientificName" varchar(255) default NULL,
  "kingdom" varchar(255) default NULL,
  "phylum" varchar(255) default NULL,
  "clazz" varchar(255) default NULL,
  "ordder" varchar(255) default NULL,
  "superfamily" varchar(255) default NULL,
  "family" varchar(255) default NULL,
  "genericName" varchar(255) default NULL,
  "genus" varchar(255) default NULL,
  "subgenus" varchar(255) default NULL,
  "specificEpithet" varchar(255) default NULL,
  "infraspecificEpithet" varchar(255) default NULL,
  "scientificNameAuthorship" varchar(255) default NULL,
  "source" text,
  "namePublishedIn" text,
  "nameAccordingTo" varchar(255) default NULL,
  "modified" varchar(255) default NULL,
  "description" text,
  "taxonConceptID" varchar(255) default NULL,
  "scientificNameID" varchar(255) default NULL,
  "referenzes" varchar(255) default NULL,
  "isExtinct" varchar(10) default NULL
);

CREATE TABLE IF NOT EXISTS "vernacular" (
  "taxonID" integer NOT NULL,
  "vernacularName" varchar(255) NULL,
  "language" varchar(255) NULL,
  "countryCode" varchar(255) NULL,
  "locality" varchar(255) NULL,
  "transliteration" varchar(255) NULL
);
