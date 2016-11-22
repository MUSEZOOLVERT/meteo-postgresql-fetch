CREATE OR REPLACE FUNCTION getdailystationdata(param text)
RETURNS json AS
$BODY$
	import urllib2
	import json
	import xmltodict

	file = urllib2.urlopen('http://dati.meteotrentino.it/service.asmx/ultimiDatiStazione?codice=' + param)
	data = file.read()
	file.close()
	data = json.loads(json.dumps(xmltodict.parse(data)))
	data = data['datiOggi']

	idxs = []

	# In case of no data in URL, returns a blank JSON
	finaljson = {}

	if (False if not data['temperature'] else True):
		idxs.append(len(list(data['temperature']['temperatura_aria'])))
		temperatures = data['temperature']['temperatura_aria']

		hasprec = False if not data['precipitazioni'] else True
		if hasprec:
			idxs.append(len(list(data['precipitazioni']['precipitazione'])))

		haswind = False if not data['venti'] else True
		if haswind:
			idxs.append(len(list(data['venti']['vento_al_suolo'])))

		for index in range(0,min(idxs)):
			day = temperatures[index]['data']
			finaljson[day] = {}
			finaljson[day]['temperatura'] = temperatures[index]['temperatura'] 
			finaljson[day]['rain'] = data['precipitazioni']['precipitazione'][index]['pioggia'] if hasprec else ''
			finaljson[day]['wind_int'] = data['venti']['vento_al_suolo'][index]['v'] if haswind else ''
			finaljson[day]['wind_dir'] = data['venti']['vento_al_suolo'][index]['d'] if haswind else ''

	return json.dumps(finaljson)
$BODY$
LANGUAGE plpythonu VOLATILE;
COMMENT ON FUNCTION getdailystationdata(text) IS 'The function gets the current (from midnight to querying time of the day) data for a weather station, given its ID';