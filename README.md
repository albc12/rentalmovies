# Movie set Dataset Exploration
## by Alicia Bosch

## Dataset

In this project I use SQL to explore a database related to movie rentals. As part of the project, I run SQL queries and build visualizations to showcase the output of the queries.

I query the Sakila DVD Rental database. The Sakila Database holds information about a company that rents movie DVDs. I will be querying the database to gain an understanding of the customer base, such as what the patterns in movie watching are across different customer groups, how they compare on payment earnings, and how the stores compare in their performance. The schema for the DVD Rental database is provided here: http://www.postgresqltutorial.com/postgresql-sample-database/.


## Summary of queries

Some of the queries include:

- A table with the family-friendly film category, each of the quartiles and the corresponding count of movies within each combination of film category for each corresponding rental duration category.
- The two stores compared in their count of rental orders during every month for all the years we have data for.
- The list of our top 10 paying customers, how many payments they made on a monthly basis during 2007, and what was the amount of the monthly payments.
- For each of these top 10 paying customers, I would like to find out the difference across their monthly payments during 2007.
I compared the payment amounts in each successive month and repeated this for each of these 10 paying customers.
Also, I identified the customer name who paid the most difference in terms of payments.


## Key questions and insights for presentation

For the presentation, I only explore some of the points I discussed above with visualizations. Here are the questions and main takeaways.

- What are the quartiles and count of movies of the different family-friendly film category within each corresponding rental duration category?
The first quartile of Animation was the highest of all quartiles of all categories, with 22 films.  
The second highest was the third quartile of the Family category with 20 films.

- How do the two stores compare in their count of rental orders during every month for all the years we have data for?
Both stores have a similar amount of rental orders throughout all the years we have data for.
The highest amount of rentals is in July 2005 (Store1: 3342 ,

- Who were the top 2 customers that reached the highest paid amount per film in 2007?
Eleanor Hunt and Rhonda Kennedy where the ones who reached the highest paid amount. It coincided to be in both cases in April 2007.  
As an observation, in general, May 2007 seems to be the weakest month out out all the shown months in the graph.  

- Can you compare the payment amounts of the top 10 paying customers in each successive month?
The customer Eleanor Hunt paid the maximum difference of $64.87 during March 2007 from $22.95 in February of 2007.
