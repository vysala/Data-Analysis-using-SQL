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

-- Retrieve sales data where GEOID is g1 and order by product ID &  order of amounts desc

select * from sales
where geoid='g1'
order by PID, Amount desc;

-- Retrieve records from sales table where sales date is after '2022-01-01' and amount >10000 

Select * from sales
where amount > 10000 and SaleDate >= '2022-01-01';

-- Find out the sales data for the year 2022 if the sales amount is greater than 10000. Use year() function to retrieve data in a specific year

select SaleDate, Amount from sales
where amount > 10000 and year(SaleDate) = 2022
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

--Queries to work with People table 

select * from people;

-- OR operator in SQL

select * from people
where team = 'Delish' or team = 'Jucies';

-- IN operator in SQL

select * from people
where team in ('Delish','Jucies');

-- LIKE operator in SQL

select * from people
where salesperson like 'B%';

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

select team, count(*) from people
group by team;
