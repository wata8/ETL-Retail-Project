SELECT * FROM sys.df_orders;

#TOP 5 MOST SELLING PRODUCTS
select Product_Id,round(sum(sale_price),2) as total_sale
from df_orders
group by Product_Id
order by total_sale desc
limit 5;

#TOP 5 MOST SELLING PRODUCTS IN EACH REGION
with cte as
(select Region,Product_Id,round(sum(sale_price),2) as total_sale
from df_orders
group by Region, Product_Id
order by Region,total_sale desc)

select * from
(select *,rank() over(partition by Region order by total_sale desc) as rn
from cte) A
where rn<=5;

#MONTH OVER MONTH GROWTH COMPARISION FOR 2022 AND 2023 SALES

with cte as
(select year(order_date) as order_year,month(order_date) as order_month,sum(sale_price) as total_sale
from df_orders
group by month(order_date),year(order_date))
select order_month,round(sum(case when order_year=2022 then total_sale end),2) as sales_2022
                  ,round(sum(case when order_year=2023 then total_sale end),2) as sales_2023
from cte
            group by order_month
            order by order_month asc;
#FOR EACH CATEGORY WHICH MONTH HAS HIGHEST SALES
with cte as 
(select category,month(order_date) as order_month,year(order_date) as order_year,sum(sale_price) as total_sale
from df_orders
group by category,month(order_date),year(order_date)) 

select* from
(select *,row_number() over(partition by category order by total_sale desc) as rn
from cte )a
where rn=1;

#WHICH STATE GIVES HIGHEST REVENUE AND FOR WHICH CATEGORY
select state,category,sum(sale_price) as total_price
from df_orders
group by category,state
order by total_price  desc
limit 1;


         
                  