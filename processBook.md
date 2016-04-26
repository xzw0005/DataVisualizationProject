
# A Process Book (for Both Shiny and D3 Visulaizations)

------

## 1. Data Source

* **Weather data**: http://www7.ncdc.noaa.gov/CDO/cdoselect.cmd 

    - The National Environmental Satellite, Data, and Information Service (NESDIS) of the National Oceanic and Atmospheric Administration which is operated under the U.S. Department of Commerce
	  
* **Stock data**: http://finance.yahoo.com

    - Yahoo finance website

------

## 2. Raw Data Set (Total 12 variables)

1. Observation Year

2. Observation Month

3. Observation Day

4. Observation Hour

5. Air Temperature

6. Dew Point Temperature

7. Sea Level Pressure

8. Wind Direction

9. Wind Speed Rate

10. Sky Condition Total Coverage Code

11. Liquid Precipitation Depth Dimension - One Hour Duration

12. Liquid Precipitation Depth Dimension - Six Hour Duration

------

## 3. Data Manipulation

* **Weather data**

    + Removing missing value and sky obscured value
	  
    + Averaging the cloudiness (sky condition) between 9 am and 4 pm per day
	  
    + Making the cloudiness into 8 groups

	  
*  **Stock market data**

    + Calculating the stock return using the adjusted close price x Stock return (%) = today's close price / previous day's close price

	  
*  **Mapping**

    - Aligning the cloudiness and stock return based on stock market open days

------

## 4. Decisions (Rationals) for Picking the Visualizations

* **Bar chart**

    - The bar chart is appropriate for comparing 8 groups.
	  
    - Adding several gridlines would be help to read the stock return value approximately.
	  
    - The range of stock return is enough to use zero-based axis.

* **Line chart**

    - The line chart is well known to represent the trend of data.

------

## 5. Filtering Options

* **Shiny**

    - The user can select the cloudiness level or year to be examined.

* **D3**

    - The user can adjust opacity of the line color in the graph.
	  
    - The user can export the whole data set as a spreadsheet.
	  
	- The user can switch y-axis (stock return on each cloudiness level) toward left or right.

------ 

## 6. Questions being asked

*  **Shiny**
	
    - How has the stock market behaved associated with varying cloudiness? 
	  
    - Is there any difference between two stock market exchanges (Nasdaq and S&P 500) associated with varying cloudiness? 
	  
    - For the Nasdaq, how has the stock return changed over years on some particular cloudiness conditions? 
	  
    - For the S&P 500, how has the stock return changed over years on some particular cloudiness conditions?

	  
* **D3**

    -Which industry has been the most affected by weather (cloudiness)?

------

## 7. Conclusions

* Sunny days influence significantly on improving stock return while gloomy days show the opposite effect.

* There is no relationship between middle ranges of the cloudiness level.

* Financial stocks returns are more volatile at different cloudiness levels.

--------
The end.