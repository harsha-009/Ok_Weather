import requests
from flask import Flask,jsonify
from datetime import date

app=Flask(__name__)


@app.route('/<city>',methods=['GET','POST'])
def index(city):
	url=f'https://api.waqi.info/search/?token=e4c9bb358133d176ec63970412650e83e32a61a2&keyword={city}'
	#print(url)
	response=requests.post(url=url)
	result=response.json()
	try:
		if result['status'] == 'ok':
			loc=result['data'][0]['station']['name']
			url=f'https://api.waqi.info/feed/{loc}/?token=e4c9bb358133d176ec63970412650e83e32a61a2'
			response=requests.post(url=url)
			result=response.json()
			for i in range(0,len(result['data']['forecast']['daily']['o3'])):
				if result['data']['forecast']['daily']['o3'][i]['day'] == str(date.today()):
					o3=result['data']['forecast']['daily']['o3'][i]['avg']
					#print(o3)
			for i in range(0,len(result['data']['forecast']['daily']['pm10'])):
				if result['data']['forecast']['daily']['pm10'][i]['day'] ==str( date.today()):
					pm10=result['data']['forecast']['daily']['pm10'][i]['avg']
					#print(pm10)
			for i in range(0,len(result['data']['forecast']['daily']['pm25'])):
				if result['data']['forecast']['daily']['pm25'][i]['day'] == str(date.today()):
					pm25=result['data']['forecast']['daily']['pm25'][i]['avg']
					#print(pm25)
			for i in range(0,len(result['data']['forecast']['daily']['uvi'])):
				if result['data']['forecast']['daily']['uvi'][i]['day'] == str(date.today()):
					uvi=result['data']['forecast']['daily']['uvi'][i]['avg']
					#print(uvi)
			# o3=result['data']['forecast']['daily']['o3'][3]['avg']
			# pm10=result['data']['forecast']['daily']['pm10'][3]['avg']
			# pm25=result['data']['forecast']['daily']['pm25'][3]['avg']
			# uvi=result['data']['forecast']['daily']['uvi'][3]['avg']
			data={'o3':o3,'pm10':pm10,'pm25':pm25,'uvi':uvi}
		else:
			data={'o3':0,'pm10':0,'pm25':0,'uvi':0}
	except :
		data={'o3':0,'pm10':0,'pm25':0,'uvi':0}
	return jsonify(data)



if '__main__' == __name__:
	app.run(debug=True)
