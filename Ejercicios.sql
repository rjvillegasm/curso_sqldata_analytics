
-- Exercise 1

drop table Science_class;
CREATE TABLE Science_class (
    Enrollment_no INT PRIMARY KEY NOT NULL,
    Name_student VARCHAR(45),
    Science_marks INT
);

-- Ejercicio 2 

insert into Science_class (Enrollment_no, Name_student, Science_marks)
values ('1', 'Popeye' , '33'),
		(2, 'Olive',54),
        (3,'Brutus',98);

    
copy Science_class from 'C:\misrepositorios\curso_sqldata_analytics\Data\Student.csv' delimiter ',' csv header;

-- fin ejercicio 2 

SELECT * FROM  Science_class;

select name_student , Science_marks from Science_class;

-- ejercicio 3 
select * from Science_class;

select Name_student from Science_class where Science_marks > 60;

select * from Science_class where Science_marks >35 and Science_marks < 60;

select	* from Science_class where Science_marks <= 35 or Science_marks >= 60; 


-- ejercicio 4 

Update Science_class set Science_marks= 45 where name_student='Popeye';

delete from Science_class where name_student='Robb';

alter table Science_class rename name_student to student_name;

-- ejercicio 5

select distinct city  from  customer  where region    in  ( 'North', 'East');

select * from sales where sales between 100 and 500;

select * from customer where customer_name like '% ____';

-- ejercicio 7
select * from sales where discount >0 Order by discount desc limit 10;

-- ejercicio 8

select sum(sales) from sales;

-- revisamos la tabla
select * from customer;

select count(customer_id) from customer where  age between 20 and 30;

select avg(age) from customer where region = 'East';

select  min(age), max(age) from customer where city='Philadelphia';

-- ejercicio 9

select * from sales;

select product_id, 
sum(sales) as total_sales,
sum(quantity) as total_units,
count(order_id) as number_of_orders,
max(sales) as max_sale,
min(sales) as min_sale,
avg(sales) as avg_sale
from sales group by product_id order by total_sales desc; 

select product_id , sum(quantity) as total_units
from sales group by product_id 
having sum(quantity)>50 order by total_units desc;    

-- ejercicio 10

--parte 1
-- revisamos las tablas 
select * from sales_2015;
select * from customer_20_60;

select b.state, sum(a.sales) as total_sales 
from sales_2015 as a left join customer_20_60 as b
on a.customer_id = b.customer_id 
group by b.state order by total_sales desc;

--parte 2
-- revisamos las tablas 
select * from sales;
select * from product;

select b.product_id, b.product_name , b.category,
sum(a.sales) as total_sales, sum(a.quantity) as total_units
from product as b left join sales as a 
on b.product_id = a.product_id 
group by b.product_id order by total_sales desc;   
-- nota: la columna mencionada en el group by debe ser exactamente la misma del select inicial,
-- incluyendo el alias de su tabla de origen

-- solo para revisar
select product_id , sum (sales) as total_sales, sum(quantity) as total_units
from sales  group by product_id order by total_sales desc; 

-- ejercicio 11

--revisamos las tablas
select * from sales;
select * from product;
select * from customer;
-- véase imagen "13 sub queries ERD"


select a.*, b.customer_name, b.age from sales as a 
left join customer as b
on a.customer_id = b.customer_id;

-- utilizando solo sub queries en el select 
select order_line, order_id, customer_id, product_id, sales, quantity , profit,
(select customer_name from customer where customer.customer_id = sales.customer_id ),
(select age from customer where customer.customer_id = sales.customer_id ),
(select product_name from product where product.product_id = sales.product_id ),
(select category from product where product.product_id = sales.product_id )
from sales order by order_line asc;

-- utilizando sub queries y join 
select 
a.product_name,
a.category,
b.product_id, 
b.order_id, 
b.sales,
b.cust_name,
b.cust_age
from product as a  left join 
( select order_id, sales, product_id,
(select customer_name from customer where customer.customer_id = sales.customer_id ) as cust_name,
(select age from customer where customer.customer_id = sales.customer_id ) as cust_age
from sales) as b on a.product_id = b.product_id;

-- alternativa
select 
a.product_name,
a.category,
b.*
from product as a  left join 
( select order_id, sales, product_id,
(select customer_name from customer where customer.customer_id = sales.customer_id ) as cust_name,
(select age from customer where customer.customer_id = sales.customer_id ) as cust_age
from sales) as b on a.product_id = b.product_id;



-- respuesta pdf
-- sp: sales-product
select c.customer_name, c.age, sp.* from
customer as c
right join (select s.*, p.product_name, p.category
from sales as s
left join product as p
on s.product_id = p.product_id) as sp
on c.customer_id = sp.customer_id;

-- simplificando la respuesta

-- primero creamos un join al cual asignamos un alias
select s.order_id, s.sales, p.product_name, p.category
from sales as s
left join product as p
on s.product_id = p.product_id;
-- asignamos un alias
(select s.order_id, s.sales, p.product_name, p.category
from sales as s
left join product as p
on s.product_id = p.product_id) as sp 
-- luego continúo con un right join entre sp y customer
select c.customer_name, c.age, sp.* from
customer as c
right join (/* tabla*/ ) as sp
on c.customer_id = sp.customer_id;

-- ejercicio 12

--revisamos la tabla
 select * from sales ;
--probamos el select
select order_line, product_id,sales, discount, order_date
from sales order by order_date asc limit 5 ;
-- ejecutamos la vista
create view Daily_Billing as 
select order_line, product_id,sales, discount
from sales order by order_date asc limit 1 ;
-- revisamos el resultado
select * from Daily_Billing;
--borramos
drop view Daily_Billing;

-- ejercicio 13
select * from product;
--1.
select max( length(product_name)) as nombre_mas_largo from product;
--2.
select product_name, category, sub_category,
product_name||', ' ||category||', '|| sub_category as product_details
from product; 
--3. 
select product_id,
substring(product_id,1,3) as cat, 
substring(product_id,5,2) as sub_cat,
substring (product_id,8, 8) as code 
from product; 
--revisando la primera fila
select product_id,
substring(trim(product_id,' '),1,3) as cat 
from product;
--4. 
select product_name, sub_category,
replace(product_name,' ',',')
from product 
where sub_category in('Chairs','Tables') ;
--4. alternativa
select sub_category,
STRING_AGG(product_name,',')
from product group by sub_category 
having sub_category in('Chairs','Tables') ;

-- ejercicio 14
select * from customer;

--1.
select customer_id, customer_name,random() as random_number 
from customer order by random_number limit 5;

--2.
Create table my_sales as (
select sum(sales) as total_sales,
sum(ceil(sales)) as ceil_sales,
sum(floor(sales)) as floor_sales,
sum(round(sales)) as total_rounded
from sales order by total_sales desc);

select * from my_sales;

select total_sales, ceil_sales as ceil_floor_round_sales,
(total_sales - ceil_sales) as ceil_flood_round_diff
from my_sales
union 
select total_sales,floor_sales,
(total_sales - floor_sales) as floor_diff
from my_sales
union 
select total_sales , total_rounded ,
(total_sales - total_rounded) as round_diff
from my_sales;

-- ejercicio 15

--1.
select to_char (age('1939-4-6', current_date ), 'YYdd') 
as batman_age_in_years_and_days;

--2. ventas mensuales de la sub categoría chairs
select * from product;
-- resultado esperado
select meses, sum (sales) from sales group by meses having subcategoría ='Chair'
-- creamos el join
select s.order_id, s.order_date, s.sales, p.sub_category from sales as s 
left join product as p 
on s.product_id = p.product_id ;
-- obtenemos el mes 
select  Extract(month from s.order_date) as mes , s.sales, p.sub_category from sales as s 
left join product as p 
on s.product_id = p.product_id 
where p.sub_category = 'Chairs';
--  sub query

select mes, round(sum(sales)) as ventas from (
select  Extract(month from s.order_date) as mes , s.sales, p.sub_category from sales as s 
left join product as p 
on s.product_id = p.product_id 
where p.sub_category = 'Chairs') group by mes order by mes ;


-- opción con CTE
with venta_meses_sillas ( mes, ventas, sillas ) as 
(
select  Extract(month from s.order_date) as mes , s.sales, p.sub_category from sales as s 
left join product as p 
on s.product_id = p.product_id 
where p.sub_category = 'Chairs'
)
select mes, round(sum(ventas)) as sales from venta_meses_sillas group by mes order by mes ;


-- ejercicio 16 
--1.
select * from customer
where customer_name ~*'^[a-z]{5}\s(a|b|c|d)[a-z]{4}$'; 

--2.
--creamos tabla zipcode
create table zipcode (id serial primary key,
"PIN/ZIP codes" character varying);
-- insertamos valores
insert into zipcode ("PIN/ZIP codes") values('234432'),
('23345'),('sdfe4'),('123&3'),('67424'),('7895432'),('12312'); 
-- seleccionamos la tabla
select*from zipcode;
-- validamos que tengan entre 5 y 6 valores numéricos
select * from zipcode where "PIN/ZIP codes" ~*'^[0-9]{5,6}$';