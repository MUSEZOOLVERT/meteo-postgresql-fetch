CREATE OR REPLACE FUNCTION getstations()
RETURNS json AS
$BODY$
	import urllib2
	import json
	import xmltodict

	file = urllib2.urlopen('http://dati.meteotrentino.it/service.asmx/listaStazioni')
	data = file.read()
	file.close()

	data = json.dumps(xmltodict.parse(data))
	return data
$BODY$
LANGUAGE plpythonu VOLATILE
COST 100;