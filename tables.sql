CREATE SEQUENCE rilevamenti_stazioni_id_seq;
CREATE TABLE stazioni
(
  id integer NOT NULL DEFAULT nextval('rilevamenti_stazioni_id_seq'::regclass),
  codice character varying(255),
  nome character varying(255),
  nomebreve character varying(255),
  quota integer,
  lat real,
  lon real,
  est real,
  north real,
  inizio date,
  fine date
);

INSERT INTO stazioni(codice,nome,nomebreve,quota,lon,lat,est,north,inizio,fine)
SELECT json_array_elements(getStations()->'ArrayOfAnagrafica'->'anagrafica')->>'codice' AS codice,
json_array_elements(getStations()->'ArrayOfAnagrafica'->'anagrafica')->>'nome' AS nome,
json_array_elements(getStations()->'ArrayOfAnagrafica'->'anagrafica')->>'nomebreve' AS nomebreve,
CAST(json_array_elements(getStations()->'ArrayOfAnagrafica'->'anagrafica')->>'quota' AS integer)AS quota ,
CAST(json_array_elements(getStations()->'ArrayOfAnagrafica'->'anagrafica')->>'longitudine' AS real) AS lon,
CAST(json_array_elements(getStations()->'ArrayOfAnagrafica'->'anagrafica')->>'latitudine' AS real) AS lat,
CAST(json_array_elements(getStations()->'ArrayOfAnagrafica'->'anagrafica')->>'est' AS real) AS est,
CAST(json_array_elements(getStations()->'ArrayOfAnagrafica'->'anagrafica')->>'north' AS real) AS north,
CAST(json_array_elements(getStations()->'ArrayOfAnagrafica'->'anagrafica')->>'inizio' AS date) AS inizio,
CAST(json_array_elements(getStations()->'ArrayOfAnagrafica'->'anagrafica')->>'fine' AS date) AS fine;

SELECT AddGeometryColumn ('public','stazioni','geometry',25832,'POINT',2, false);
UPDATE stazioni SET geometry=ST_transform(ST_setsrid(ST_makepoint(lon,lat),4326),25832);