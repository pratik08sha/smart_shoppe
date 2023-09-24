

#user search for a product by its name
SELECT * FROM product_details pd join product_vendor pv on pv.product_details_id = pd.id where pd.name like '%iphone%';

#user want the prices sorted 
SELECT * FROM product_details where name like '%iphone%' order by selling_price;

#user set the price range
select * from product_details where selling_price > 4.00 and selling_price < 10.00 and name like '%iphone%';

#user search for product with specific brand name or color name with price filter
select * from product_details
where selling_price > 4.00 and selling_price < 15.00  
and (color is null or color = "" or color = "red")
and (brand_name is null or brand_name = "" or brand_name = "JBM")
and name like '%iphone%';

#user want the product under a certain category lets say category 10
SELECT pd.name, pd.description, pd.selling_price, c.name AS category from product_details pd 
JOIN product_categories pc on pd.id = pc.product_details_id
JOIN categories c on c.id = pc.category_id
where c.id = 10;

#user want the product under a certain category lets say category 10 and 11 and sorted by selling price
SELECT pd.name, pd.description, pd.selling_price, c.name AS category from product_details pd 
JOIN product_categories pc on pd.id = pc.product_details_id
JOIN categories c on c.id = pc.category_id
where c.id in (10,11)
order by pd.selling_price;



#insert a new product from vendor amazon
#for this we need a transaction that will ensure the product details are inserted followed by
#product_categories table as well as product_Vendor table
#amazon vendor id  = 2
#category id  = 34, 35
START TRANSACTION;
INSERT INTO product_details(name, description, product_image_url, cost_price, selling_price,
quantity, dimension, specification, brand_name, color)
VALUES("iphone14 Pro", "iphone 14 pro with fast charger", "", "1099", "950", 5, "", "42 mp camera, 12 mp front camera",
"Apple", "black");
set @product_details_id = LAST_INSERT_ID();
INSERT INTO product_vendor(vendor_id, product_details_id) values (2, @product_details_id);
INSERT INTO product_categories(product_details_id, category_id) values (@product_details_id, 34);
INSERT INTO product_categories(product_details_id, category_id) values (@product_details_id, 35);
commit;


#vendor wants to view all the product details and quantity left
SELECT pd.name, pd.quantity from product_details pd 
JOIN product_vendor pv on pv.product_details_id = pd.id
JOIN vendor v ON pv.vendor_id = v.id
WHERE v.name = "amazon";


#vendor updating the price of a product
UPDATE product_details set selling_price = "30.99" where id = 2;

#update the selling price increase selling price by 10% of products in category 10
update product_details  pd  
join product_categories pc on (pc.product_details_id = pd.id and pc.category_id = 10)
set pd.selling_price = pd.selling_price *(1.1)


