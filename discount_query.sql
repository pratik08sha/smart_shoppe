#insert a new discount on product 7453
START TRANSACTION;
INSERT INTO discount(code, amount, start_date, end_date)
VALUES ("NEW30", 5, DATE('2023-04-24 09:00:00'), DATE('2023-04-29 11:59:59'));
set @discount_id = LAST_INSERT_ID();
INSERT INTO discount_on_products(discount_id, product_details_id)
VALUES(@discount_id, 7453);
COMMIT;

#insert a new discount on product 11322 as percentage
START TRANSACTION;
INSERT INTO discount(code, percentage, max_amount, start_date, end_date)
VALUES ("NEW40", 20, 15, DATE('2023-04-24 09:00:00'), DATE('2023-04-29 11:59:59'));
set @discount_id = LAST_INSERT_ID();
INSERT INTO discount_on_products(discount_id, product_details_id)
VALUES(@discount_id, 11322);
COMMIT;

#insert a discount on categories("all phones") id = 2640
START TRANSACTION;
INSERT INTO discount(code, percentage, max_amount,start_date, end_date)
VALUES("CAT20", 10, 15, DATE('2023-04-24 09:00:00'), DATE('2023-04-29 11:59:59'));
set @discount_id = LAST_INSERT_ID();
INSERT INTO discount_categories(discount_id, category_id) 
VALUES (@discount_id, 2640);
COMMIT;

select * from discount;

##show discount applicable on products on user_cart
SELECT pd.name, pd.selling_price, uc.quantity, 
(pd.selling_price * uc.quantity ) as cost, ifnull(d.amount, CONCAT(d.percentage,"%")) AS discount_applicable,
(pd.selling_price * uc.quantity ) - ifnull(ifnull(d.amount, LEAST((((pd.selling_price * uc.quantity ) * d.percentage)/100), IFNULL(d.max_amount,(pd.selling_price * uc.quantity )))), 0) 
AS new_selling_price
FROM user_cart uc
JOIN product_details pd ON pd.id = uc.product_details_id
LEFT JOIN discount_on_products dp ON dp.product_details_id = pd.id
LEFT JOIN discount d ON d.id = dp.discount_id
WHERE uc.user_id = 11;

##show sum of all the products in user_cart after applying the discount
SELECT sum(new_selling_price) FROM (SELECT pd.name, pd.selling_price, uc.quantity, 
(pd.selling_price * uc.quantity ) as cost, ifnull(d.amount, CONCAT(d.percentage,"%")) AS discount_applicable,
(pd.selling_price * uc.quantity ) - ifnull(ifnull(d.amount, LEAST((((pd.selling_price * uc.quantity ) * d.percentage)/100), IFNULL(d.max_amount,500000))), 0) 
AS new_selling_price
FROM user_cart uc
JOIN product_details pd ON pd.id = uc.product_details_id
LEFT JOIN discount_on_products dp ON dp.product_details_id = pd.id
LEFT JOIN discount d ON d.id = dp.discount_id
WHERE uc.user_id = 11) AS new_user_cart;


