use hotel;

-- 1. Calculate which meal has highest price.

select meal_name, max(price) as highest_price
from meals
group by meal_name
order by highest_price desc
limit 1;

-- 2.Calculate total price of the items of cold or hot.

select hot_cold ,round(sum(price)) as Total_price
from meals
group by hot_cold
order by Total_price desc;

-- 3.Calculate total number of orders received for each meal type. 

select mt.meal_type as meal , 
		count(m.meal_name) as total_order
from meal_types mt
left join meals m
on mt.id = m.meal_type_id 
group by mt.meal_type
order by total_order desc;

-- 4.Calculate which city is spending a highest of monthly budget on meals.

select * from cities;
select * from members;

select c.city , 
		sum(monthly_budget) as Total_monthly_budget
from cities c
left join members m
on c.id = m.city_id 
group by c.city 
order by total_monthly_budget desc
limit 1;

-- 5.Calculate which gender type is spending most in meals.

select sex, sum(monthly_budget) as Total_Spending
from members
group by sex
order by Total_Spending desc
limit 1;

-- 6.Give the details of the person who is spending the highest for meals.

select * from members ; 
select * from cities;

select m.id, m.first_name,m.surname,m.sex,m.email,c.city , m.monthly_budget
from members m
left join cities c
on c.id = m.city_id
where m.monthly_budget = (select max(monthly_budget) from members);

-- 7.Find the details of month wise totals of orders and meals.
select year ,month ,sum(order_count)as order_count,
			sum(meals_count) as meal_count
from monthly_member_totals
group by year ,month;

-- 8.Which city has highest commision?

select city ,round(sum(commission)) as Total_commission
from monthly_member_totals
group by city 
order by Total_commission desc
limit 1;

-- 9.Which gender type has highest negative balance?
select sex,round(sum(balance)) as balance
from monthly_member_totals
group by sex 
order by balance desc ;

-- 10.List the top 10 mail contacts of customers from 'Herzelia' city with negative balance.

SELECT email, ROUND(SUM(balance),2) AS Balance
FROM monthly_member_totals
WHERE city = 'Herzelia'
GROUP BY email,city
ORDER BY Balance
LIMIT 10;

-- 11. Find on which day of the month we have received maximum number of orders.
SELECT DAY(date) AS Day, ROUND(SUM(total_order),2) AS Total_order
FROM orders
GROUP BY Day
ORDER BY Total_order
LIMIT 1;

-- 12.Which restaurant type has highest income percentage

select * from restaurant_types;
select * from restaurants; 

select rt.restaurant_type as Restaurant_type ,ROUND(SUM(income_persentage)*100,0) as Income_persentages
from restaurant_types rt
left join restaurants r
on rt.id  = r.restaurant_type_id 
group by Restaurant_type
order by Income_persentages desc;

-- 13.Join required data to create an insightful table regarding meals and items
select mt.meal_type,m.hot_cold as hot_cold , m.price as price,income_persentage*100 AS IncomePercentage,city AS City, serve_type AS ServeType
from meal_types mt
LEFT JOIN meals m
on mt.id = m.meal_type_id 
LEFT JOIN serve_types
ON m.serve_type_id = serve_types.id
LEFT JOIN restaurants
ON m.restaurant_id = restaurants.id
LEFT JOIN cities
ON restaurants.city_id = cities.id
Order by IncomePercentage desc;

-- 14. Join required data to create an insightful table regarding members and their interest towards meals.
SELECT members.id AS ID, members.first_name,members.surname,members.sex AS Sex,cities.city AS City, members.email,members.monthly_budget AS Monthly_Budget,
	   restaurant_name AS Restaurant_Name, restaurant_type AS Restaurant_Type , year AS Year, month AS Month, order_count, meals_count, total_expense, ROUND(balance,2) AS Balance,
       ROUND(commission,2) AS Commission,date AS Date, hour AS Time
FROM members
LEFT JOIN cities
ON members.city_id = cities.id
LEFT JOIN restaurants 
ON cities.id = restaurants.city_id
LEFT JOIN restaurant_types
ON restaurants.restaurant_type_id = restaurant_types.id
LEFT JOIN orders
ON members.id = orders.member_id
LEFT JOIN monthly_member_totals
ON members.id = monthly_member_totals.member_id;