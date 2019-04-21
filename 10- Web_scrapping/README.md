# Mission To Mars

In this assignment, we were tasked with building a web application that scrapes various websites for data related to the Mission to Mars and displays the information in a single HTML page. 

### The following is a summary of the steps followed:

### Step 1 - Scraping
The scrapping was performed in a Jupyter Notebook called mission_to_mars.ipynb.

Five Websites were scrapped:
1. NASA Mars News: https://mars.nasa.gov/news/
2. JPL Mars Space Images - Featured Image: https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars
3. Mars Weather: https://twitter.com/marswxreport?lang=en
4. Mars Facts: http://space-facts.com/mars/
5. Mars Hemispheres: https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars
##
### Step 2 - MongoDB and Flask Application
1. We used MongoDB with Flask templating to create a new HTML page to display all of the information scraped from the URLs.
2. Converted the Jupyter notebook into a Python script called scrape_mars.py 
3. Created an app.py file to create an instance with Flask and create route that renders index.html template
4. Create a route called /scrape to import the scrape_mars.py script and call your scrape function.
5. Store the return value in Mongo as a Python dictionary.
6. Created a root route / to query Mongo database and pass the mars data into an HTML template that displays the data.
7. Created a template HTML file called index.html that takes the mars data dictionary and display all of the data in the appropriate HTML elements.

## Final Product










 
