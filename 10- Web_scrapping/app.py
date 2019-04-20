# Step 2 - MongoDB and Flask Application
'''
Use MongoDB with Flask templating to create a new HTML page that displays all of the information that was scraped from the URLs above.

    - Start by converting your Jupyter notebook into a Python script called scrape_mars.py with a function called scrape that will execute all of your scraping code from above and return one Python dictionary containing all of the scraped data.

    - Next, create a route called /scrape that will import your scrape_mars.py script and call your scrape function.

        - Store the return value in Mongo as a Python dictionary.

    - Create a root route / that will query your Mongo database and pass the mars data into an HTML template to display the data.
    - Create a template HTML file called index.html that will take the mars data dictionary and display all of the data in the appropriate HTML elements. Use the following as a guide for what the final product should look like, but feel free to create your own design.
'''

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Dependencies
from flask import Flask, render_template,redirect
import pymongo
import scrape_mars

#Create instance of Flask app
app = Flask(__name__)
client = pymongo.MongoClient()
db = client.mission_to_mars_db


collection = db.mission_to_mars
collection_image = db.mission_to_mars
collection_weather = db.mission_to_mars
collection_hemisphere = db.mission_to_mars


#Create route that renders index.html template
@app.route("/")
def home():

    news_dict= db.collection.find()
    ft_img_dict = db.collection_image.find()
    mars_weather_dict = db.collection_weather.find()
    full_hemisphere_dict = db.collection_hemisphere.find()

    return render_template("index.html", news_dict = news_dict, 
                                        ft_img_dict = ft_img_dict,
                                        mars_weather_dict = mars_weather_dict,
                                        full_hemisphere_dict = full_hemisphere_dict)

@app.route("/scrape")
def scrape():
    db.collection.remove()

    news_dict = scrape_mars.mars_news_function()
    db.collection.insert_one(news_dict)

    db.collection_image.remove()
    ft_img_dict = scrape_mars.ft_img_function()
    db.collection_image.insert_one(ft_img_dict)

    db.collection_weather.remove()
    weather_dict = scrape_mars.mars_weather_function()
    db.collection_weather.insert_one(weather_dict)

    db.collection_hemisphere.remove()
    full_hemisphere_dict = scrape_mars.mars_hemisphere_images()
    db.collection_hemisphere.insert_one(full_hemisphere_dict)


    print('----------------')
    print('----------------')
    print(news_dict)
    print('----------------')
    print('----------------')
    print(ft_img_dict)
    print('----------------')
    print('----------------')
    print(weather_dict)
    print('----------------')
    print('----------------')
    print(full_hemisphere_dict)
  
    return redirect("http://localhost:5000/", code=302)

if __name__ == "__main__":
    app.run(debug=True)
    
