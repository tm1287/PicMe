from time import sleep
import requests
import time
#http://geodb-free-service.wirefreethought.com/v1/geo/countries/US/regions/TX/cities?limit=10&offset=0&sort=-population
with open("coords.txt", "w") as out:
    for i in range(1,56):
        time.sleep(1.1)
        code = ""
        if(i < 10):
            code = "0" + str(i)
        else:
            code = str(i)
        url = f"http://geodb-free-service.wirefreethought.com/v1/geo/countries/US/regions/{code}/cities?limit=10&offset=0&sort=-population"
        
        try:
            r = requests.get(url)
            data = r.json()["data"]

            for city in data:
                out.write(str( (city["latitude"], city["longitude"]) ) + "\n")
        except:
            print(r.json())

