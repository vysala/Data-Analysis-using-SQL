Use `awesome chocolates`;

-- Retrieve all records from sales table

select * from sales;

-- Retrieve selected columns from sales table

select SaleDate, Amount, Customers from sales;

select Amount, Customers, GeoID from sales;

-- Add a calculated column with SQL and name the new column as 'Total per box' 

Select SaleDate, Amount, Boxes, Amount / boxes as 'Total per box'  from sales;

-- Using WHERE Clause in SQL to restrict the rows in the result

select * from sales
where amount > 10000;

-- Retrieve only those sales data where amount is greater than 10,000 and order them in descending order

select * from sales
where amount > 10000
order by amount desc;

-- Filtering and then Sorting by multiple criteria (first by Product ID, then by Amount)
-- Retrieve sales data where GEOID is g1 and order by product ID &  order of amounts desc

select * from sales
where geoid='g1'
order by PID, Amount desc;

-- Retrieve records from sales table where sales date is after '2022-01-01' and amount >10000 

Select * from sales
where amount > 10000 and SaleDate >= '2022-01-01';

-- Find out the sales data for the year 2021 if the sales amount is greater than 10000. Use year() function to retrieve data in a specific year

select SaleDate, Amount from sales
where amount > 10000 and year(SaleDate) = 2021
order by amount desc;

-- BETWEEN operator in SQL with < & > operators
--Retrieve sales data for boxes between 1 and 50.  

select * from sales
where boxes >0 and boxes <=50;

-- Using weekday() function in SQL. 
-- The WEEKDAY() function returns the weekday number for a given date.
-- Note: 0 = Monday, 1 = Tuesday, 2 = Wednesday, 3 = Thursday, 4 = Friday, 5 = Saturday, 6 = Sunday.

select SaleDate, Amount, Boxes, weekday(SaleDate) as 'Day of week'
from sales ;

-- Using weekday() function in SQL with where clause . 
select SaleDate, Amount, Boxes, weekday(SaleDate) as 'Day of week'
from sales
where weekday(SaleDate) = 4;

-- subquery 
-- Retrieve those products whose sales amount exceeded 10000 in the sales year 2021
       
 select pid, product from products where pid in (Select pid from sales where amount > 10000 and year(SaleDate) = 2021) ; 
    

--Queries to work with People table 
-- Retrieve all records from people table
select * from people;



-- Retrieve all records from people table where team is 'Delish' or 'Juices'
-- OR operator in SQL

select * from people
where team = 'Delish' or team = 'Jucies';

-- IN operator in SQL

select * from people
where team in ('Delish','Jucies');

-- LIKE operator in SQL   , Retrieve records from people table if the salesperson name starts with B. 'salesperson' column in people table stores name.

select * from people
where salesperson like 'B%';

-- Retrieve records from people table if the salesperson name has B. 
select * from people
where salesperson like '%B%';

select * from sales;

-- Using CASE to create branching logic in SQL

select 	SaleDate, Amount,
		case 	when amount < 1000 then 'Under 1k'
			when amount < 5000 then 'Under 5k'
                        when amount < 10000 then 'Under 10k'
			else '10k or more'
		end as 'Amount category'
from sales;

-- Find the number of people in each team 
select team, count(*) from people
group by team;

-- To see sales data with salesperson's name, we have to JOIN sales and People's table.
-- The common column between both tables is the salesperson ID (SPID).
SELECT s.SaleDate, s.Amount, p.Salesperson, s.SPID
	FROM Sales s
	JOIN People p ON p.SPID = s.SPID;
    
    -- Analyzing products sale by joining Sales and Products tables. I have performed a left join here as I only need to analyze the products that have been sold.
SELECT s.SaleDate, s.Amount, s.PID, p.Product
	FROM Sales s
	LEFT JOIN Products p ON p.PID = s.PID;
    
    
--  multiple table Joining - sales, people and products
SELECT s.SaleDate, s.Amount, p.Product, e.Salesperson, e.Team
	FROM Sales s
	JOIN People e ON s.SPID = s.SPID
	JOIN Products p ON p.PID = s.PID;    
    
-- Filtering multiple joined table for retrieving Delish team's sales where amount is less than 1000
SELECT Sales.SaleDate, Sales.Amount, Products.Product, People.Salesperson, People.Team
	FROM Sales
	JOIN People ON People.SPID = Sales.SPID
	JOIN Products ON Products.PID = Sales.PID
	WHERE People.Team = 'Delish' AND Sales.Amount < 1000;



-- Filtering multiple joined table for salespersons without teams, sales less than 1000
SELECT Sales.SaleDate, Sales.Amount, Products.Product, People.Salesperson, People.Team
	FROM Sales
	JOIN People ON People.SPID = Sales.SPID
	JOIN Products ON Products.PID = Sales.PID
	WHERE People.Team = '' AND Sales.Amount < 1000;
/*
We can use WHERE People.Team IS NULL, but in this awesome chocolates database the Team values which
are empty are not marked as NULL, which in SQL will appear as a small gray box within
the field. In this database, they are left blank, and not NULL. So we just use quote marks
'' with no characters between them, to filter for blank fields in Team column.
*/

-- Filtering above query for teamless sales, less than 1000, shipped to NZ or India
SELECT Sales.SaleDate, Sales.Amount, Products.Product, People.Salesperson, People.Team
	FROM Sales
	JOIN People ON People.SPID = Sales.SPID
	JOIN Products ON Products.PID = Sales.PID
	JOIN Geo ON Geo.GeoID = Sales.GeoID
	WHERE People.Team = '' AND Sales.Amount < 1000
	AND Geo.Geo IN ('New Zealand','India')
	ORDER BY SaleDate;
/*
Note that there is no 'Geo' column in the results. This is because, though we have
joined the Geo table and included a filter for the Geo.Geo column, we have not
SELECTed the Geo.Geo column to be displayed in the final results. So SQL will apply
the filter, but not display the Geo.Geo column in the final results.
*/

-- GROUP BY GeoID to aggregate Sales Amounts by geographic region
Select count(GeoID) from geo;   -- To check how many geo id's are there. 

SELECT GeoID, sum(Amount), avg(Amount), sum(Boxes)
	FROM Sales
	GROUP BY GeoID;
    
-- Using group by on geo column to get the geographic name rather than the geoid. Joining sales table and Geo table as we need the geographic names. 
SELECT Geo.Geo, sum(Amount), avg(Amount), sum(Boxes)
	FROM Sales
	JOIN Geo ON Geo.GeoID = Sales.GeoID
	GROUP BY Geo.Geo;
    
    
    -- Grouping and sorting multiple joined tables for sales by team per product category . Ignore the teams that are empty. 
SELECT p.Category, e.Team, sum(Boxes), sum(Amount)
	FROM Sales s
	JOIN People e ON e.SPID = s.SPID
	JOIN Products p ON p.PID = s.PID
	GROUP BY p.Category, e.Team
    having e.Team <> ''
	ORDER BY p.Category, e.Team;


-- Retrieve Sales Amounts by product, filtering only Top 10 products
SELECT p.Product, sum(Amount) AS 'Total Sales Amount'
	FROM Sales s
	JOIN Products p ON p.PID = s.PID
	GROUP BY p.Product
	ORDER BY `Total Sales Amount` DESC
	LIMIT 10;
    

    
    
    
    
    

