CREATE TABLE IF NOT EXISTS "distribution" (
  "taxonID" varchar NOT NULL,
  "occurrenceStatus" varchar default NULL,
  "locationID" varchar default NULL,
  "locality" text,
  "countryCode" text,
  "source" text
);

CREATE TABLE IF NOT EXISTS "speciesprofile" (
  "taxonID" varchar NOT NULL,
  "isExtinct" varchar default NULL,
  "isMarine" varchar default NULL,
  "isFreshwater" varchar default NULL,
  "isTerrestrial" varchar default NULL
);

CREATE TABLE IF NOT EXISTS "taxa" (
  "taxonID" varchar NOT NULL PRIMARY KEY,
  "parentNameUsageID" integer default NULL,
  "acceptedNameUsageID" integer default NULL,
  "originalNameUsageID" integer default NULL,
  "taxonomicStatus" varchar default NULL,
  "taxonRank" varchar default NULL,
  "scientificName" varchar default NULL,
  "genericName" varchar default NULL,
  "specificEpithet" varchar default NULL,
  "infraspecificEpithet" varchar default NULL,
  "nameAccordingTo" varchar default NULL,
  "namePublishedIn" text,
  "nomenclaturalCode" varchar default NULL,
  "nomenclaturalStatus" varchar default NULL,
  "taxonRemarks" text,
  "references" text
);

CREATE TABLE IF NOT EXISTS "vernacular" (
  "taxonID" varchar NOT NULL,
  "language" varchar NULL,
  "vernacularName" varchar NULL
);
