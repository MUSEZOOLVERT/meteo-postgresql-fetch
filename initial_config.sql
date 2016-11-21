CREATE EXTENSION postgis;
CREATE SCHEMA postgis;
ALTER DATABASE biosql SET search_path="$user", public, postgis,topology;
GRANT ALL ON SCHEMA postgis TO public;
ALTER EXTENSION postgis SET SCHEMA postgis;



