from bs4 import BeautifulSoup
import requests
import re
import time
import numpy as np
import json

# just the id matters
recipie_url = "https://www.allrecipes.com/recipe/270533/chicken-fritters/"
recipie = requests.get(recipie_url, headers={
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.78 Safari/537.36"})
soup = BeautifulSoup(recipie.text, "html.parser")

json_schema = soup.find_all("script", type="application/ld+json")

json_string = str(json_schema).replace('[<script type="application/ld+json">', '').replace('</script>]', '')

json_object = json.loads(json_string)

print(json.dumps(json_object, indent=2))

# get recipie name and otehr info
print(json_object[1]['name'], json_object[1]['description'], json_object[1]['image']['url'],
      json_object[1]['recipeIngredient'])



