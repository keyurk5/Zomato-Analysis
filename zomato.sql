-- Portfolio Project :- Data Analysis on Zomato Data.
-- Analyze top restaurants based on ratings, Top 5 Restaurants with most votes and high Ratings,
-- Restaurants with poor ratings, Restaurants with poor online, offline services.
-- Tools - Azure Data Studio, Microsoft SQL Server
-- PS- This is dummy data.

SELECT TOP 10 * FROM ZomatoData

-- Help Zomato to identify the cities with poor restaurant ratings.
-- Assumption: Anything less than 2.5 stars will be considered poor.

Select City, ROUND(AVG(Rating),2) as avg_rating
FROM ZomatoData
GROUP BY City
HAVING ROUND(AVG(Rating),2) <= 2.5
ORDER BY avg_rating

-- Mr X is looking for a restaurant in Kolkata which provides online food delivery, help him choose the best restaurant.

Select RestaurantName
FROM ZomatoData
WHERE City = 'Kolkata'
AND Has_Online_delivery = 1
AND Rating > 4
ORDER BY Rating DESC

-- Help Peter to find best rated restaurant for Pizza in New Delhi.

Select RestaurantName
FROM ZomatoData
WHERE City = 'New Delhi'
AND Cuisines LIKE '%pizza%'
AND Rating > 4
ORDER BY Rating DESC

-- Enlist Top 10 highly rated restaurants city wise

Select Top 10 RestaurantName
FROM
(
    Select RestaurantName,
    AVG(Rating) OVER(PARTITION BY City) as avg_rating
    FROM ZomatoData
) as sub
ORDER BY avg_rating DESC

-- Help Zomato with the list of restaurants with poor offline services
-- Assumption: Anything less than 2.5 stars will be considered poor.

Select RestaurantName
FROM ZomatoData
WHERE Has_Online_delivery = 0
AND Rating <= 2.5

-- Help Zomato with cities which have atleast 3 restaurants with ratings >= 4.8.

Select City
FROM
(
    SELECT City, COUNT(DISTINCT RestaurantId) as cnt
    FROM ZomatoData
    WHERE Rating >= 4.8
    GROUP BY City
    HAVING COUNT(DISTINCT RestaurantId) >= 3
) as res

-- Top 5 Restaurants with most votes and high Ratings

Select TOP 5 RestaurantName, City
FROM ZomatoData
ORDER BY Votes DESC, Rating DESC 

-- Top 5 countries with most restaurants linked with Zomato

Select TOP 5 country.CountryName,COUNT(DISTINCT RestaurantID) as numberOfRestaurants
FROM ZomatoData zomato
INNER JOIN CountryTable country
ON zomato.City = country.City
AND country.CountryName != 'NULL'
GROUP BY country.CountryName
ORDER BY numberOfRestaurants DESC

-- Top cuisines city wise

SELECT TOP 10 Cuisines
FROM (
    Select Cuisines, AVG(Rating) OVER (PARTITION BY City ORDER BY Rating) as avg_rating
    FROM ZomatoData
) as sub
ORDER BY avg_rating DESC

-- Help Zomato find City that has poor online delivered restaurants
-- Assumption: Anything less than 2.5 stars will be considered poor.

Select City, COUNT( Distinct RestaurantName) as countOfPoorOnlineDeliveryRestaurants
FROM ZomatoData
Where Rating <= 2.5
AND Has_online_delivery = 1
GROUP BY City
Having COUNT(Distinct RestaurantName) > 1
ORDER BY countOfPoorOnlineDeliveryRestaurants DESC