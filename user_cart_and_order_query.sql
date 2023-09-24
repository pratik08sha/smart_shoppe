#now user with id 5 decide to add item with product code 7453 and 11322 into his cart with 1 quantity each
INSERT INTO user_cart(user_id, product_details_id, quantity) values (8, 7453, 1);
INSERT INTO user_cart(user_id, product_details_id, quantity) values (8, 11322, 1);

#update qunatity in user_cart
Update user_cart set quantity = quantity + 1 where user_id = 8 and product_details_id = 7453;


#select user cart for user 5
SELECT pd.name, pd.selling_price, uc.quantity from user_cart uc 
JOIN product_details pd on pd.id = uc.product_details_id
JOIN product_vendor pv on pv.product_details_id = pd.id
where uc.user_id = 8;

#total cost of all the product in user cart
SELECT sum(pd.selling_price) as total_cost FROM user_cart uc
JOIN product_details pd ON pd.id = uc.product_details_id
WHERE uc.user_id = 8;

#get the categories of the products in user cart
select c.id, c.name, uc.product_details_id from categories c
JOIN product_categories pc ON pc.category_id = c.id
JOIN user_cart uc ON uc.product_details_id = pc.product_details_id
WHERE uc.user_id = 8;
;

#now user want to order the item from his cart
#for this we first move the item from the cart to order than remove the item from cart
#also we update the quantity of the item in product details table
# we have already the information that product id 7453 belongs to vendor id 2 
#similarly product id 11322 belongs to vendor 1
START TRANSACTION;
INSERT INTO orders(user_id, vendor_id, payment_recieved, status, status_description, order_date, delivery_date)
VALUES (8, 2, 1, "order is processing", "order is being proceessed to vendor", DATE('2023-04-26 08:42:15'), DATE('2023-05-06 18:00:00'));
set @order_id = LAST_INSERT_ID();
INSERT INTO product_ordered(order_id, product_details_id, quantity) 
VALUES(@order_id, 7453, 1);
INSERT INTO vendor_order_status(order_id, payment) values (@order_id, 50.25);
UPDATE product_details set quantity = quantity - 1 where id = 7453;
DELETE FROM user_cart where product_details_id = 7453 and user_id = 8;
COMMIT;

START TRANSACTION;
INSERT INTO orders(user_id, vendor_id, payment_recieved, status, status_description, order_date, delivery_date)
VALUES (8, 1, 1, "order is processing", "order is being proceessed to vendor", DATE('2023-04-26 08:42:15'), DATE('2023-05-02 18:00:00'));
set @order_id = LAST_INSERT_ID();
INSERT INTO product_ordered(order_id, product_details_id, quantity) 
VALUES(@order_id, 11322, 1);
INSERT INTO vendor_order_status(order_id, payment) values (@order_id, 50.25);
UPDATE product_details set quantity = quantity - 1 where id = 11322;
DELETE FROM user_cart where product_details_id = 11322 and user_id = 8;
COMMIT;


## select the order done by the user
SELECT pd.name, pd.selling_price, o.status, o.status_description from orders o 
JOIN product_ordered po ON po.order_id = o.id
JOIN product_details pd ON pd.id = po.product_details_id
where o.user_id = 8
group by o.vendor_id;


## vendor view for all the products ordered from their inventory
SELECT pd.name, sum(po.quantity) AS quantity_purchased, pd.quantity as quantity_left FROM product_details pd
JOIN product_ordered po ON po.product_details_id = pd.id
JOIN orders od ON od.id = po.order_id
JOIN vendor v ON v.id = od.vendor_id
where v.name = "amazon"
group by pd.id;




