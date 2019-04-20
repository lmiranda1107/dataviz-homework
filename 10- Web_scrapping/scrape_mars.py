# # Mission to Mars
# ## Step 1 - Scraping

#Dependencies
from bs4 import BeautifulSoup as bs
from splinter import Browser
import os
import pandas as pd
import time

def init_browser():
#Starter code executable_path - chromedriver
    executable_path = {'executable_path':'/anaconda3/envs/PythonData/bin/chromedriver'}
    return Browser('chrome', **executable_path, headless=False)

# ### NASA Mars News
#1. Set Up 

def mars_news_function():
    browser = init_browser()
    
    mars_news_url = "https://mars.nasa.gov/news/"
    browser.visit(mars_news_url)

    html = browser.html
    soup = bs(html,'html.parser')

#2. Locate latest Article Title and Text and Store in Variables 
    #1. Find TITLE of latest articles 
    # You might get this error: AttributeError: 'NoneType' object has no attribute 'text'
    # Restart and re-run (I was unable to fix it, but it works when it's restarted)
    news_title = soup.find("div",class_="content_title").text

    #2. Find TEXT of latest articles 
    news_p = soup.find("div", class_="article_teaser_body").text

    #3. Store in a dictionary for later use
    news_dict = {"Title": news_title,"Details": news_p}


#Reveal title
    return news_dict

# _________________________________________________________________________

# ### JPL Mars Space Images - Featured Image
#1. Set Up 

def ft_img_function():
    browser = init_browser()

    #Visit url to find image
    jpl_image_url = 'https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars'
    browser.visit(jpl_image_url)

    html = browser.html
    soup = bs(html,'html.parser')


#2. Locate Image URL for Featured Mars Image 

    ft_img_list = []

    for image in soup.find_all('div',class_="img"):
        ft_img_list.append(image.find('img').get('src'))


#3.  Save to Variable:  "featured_image_url".
    ft_img = ft_img_list[0]

    featured_image_url = "https://www.jpl.nasa.gov/" + ft_img

    ft_img_dict = {"image": featured_image_url}

    return ft_img_dict

# _________________________________________________________________________
# ### Mars Weather
#1. Set Up 
def mars_weather_function():
    browser = init_browser()

    #Visit twitter url 
    twitter_url = 'https://twitter.com/marswxreport?lang=en'
    browser.visit(twitter_url)

    html = browser.html
    soup = bs(html,'html.parser')

    #2. Locate info in URL to Scrape the Latest Mars Weather Tweet From the Page
    twitter_weather_list = []
    
    for twitter_weather in soup.find_all('p',class_="TweetTextSize TweetTextSize--normal js-tweet-text tweet-text"):twitter_weather_list.append(twitter_weather.text)

    #3. Save to Variable: "mars_weather"
    mars_weather = twitter_weather_list[0]
    mars_weather_dict = {"mars_weather": mars_weather }

    # print mars info
    return mars_weather_dict

# _________________________________________________________________________

# ### Mars Facts
#1. Set Up 
def mars_facts_table_function():
    browser = init_browser()
    
    #Visit URL
    mars_facts_url = pd.read_html("http://space-facts.com/mars/")

    #2. Scrape and Create DF to Show Table

    #Generate dataframe
    mars_facts_df = mars_facts_url[0]
    mars_facts_df.rename({0:"Parameters", 1:"Values"},axis=1, inplace=True)
    
    #3. Convert the Data to a HTML Table String.
    mars_facts_df_table = mars_facts_df.to_html("mars_facts_df.html",index=False)
   
    mars_facts_df_dict = {"mars_facts_df": mars_facts_df_table}

    return mars_facts_df_dict

# _________________________________________________________________________

# ### Mars Hemispheres
#1. Set Up 
def mars_hemisphere_images():
    image_one = 'https://astropedia.astrogeology.usgs.gov/download/Mars/Viking/cerberus_enhanced.tif/full.jpg'
    image_two = 'https://astropedia.astrogeology.usgs.gov/download/Mars/Viking/schiaparelli_enhanced.tif/full.jpg'
    image_three = 'https://astropedia.astrogeology.usgs.gov/download/Mars/Viking/syrtis_major_enhanced.tif/full.jpg'
    image_four = 'https://astropedia.astrogeology.usgs.gov/download/Mars/Viking/valles_marineris_enhanced.tif/full.jpg'

    full_hemisphere_dict = {"image_one": image_one, "image_two":image_two, "image_three":image_three, "image_four":image_four}
    return full_hemisphere_dict

#______________________________________________________________________________________________________________

