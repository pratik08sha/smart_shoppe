##insert query for user table
select * from user;

INSERT INTO USER(f_name, l_name, type, dob, country_code, mobile_number, email, username, password) 
VALUES ("Lois", "lane", "ADMIN", STR_TO_DATE('1-01-2012', '%d-%m-%Y'), 1, 7168672342,  "random43@random.com", "lois23", "123456");
select * from user;

##if user is admin get the last insert id and put the same in vendor_admin table
set @user_id = LAST_INSERT_ID();
INSERT INTO vendor_admin(user_id, vendor_id) VALUES (@user_id, 1);
select * from vendor_admin;

#general customer
INSERT INTO USER(f_name, l_name, type, dob, country_code, mobile_number, email, username, password) 
VALUES ("Oliver", "Queen", "CUSTOMER", STR_TO_DATE('1-01-2012', '%d-%m-%Y'), 1, 7163472342,  "random41@random.com", "arrow", "123456");
SELECT * from user;

#authenticate password of user
select password from user where username="" or email = "" or mobile_number=7168675862;

#now we have created a user, user can add his address this will get inserted in user_address table
INSERT INTO user_address(user_id, address_line_1, city, state, country, zip)
VALUES (8, "714 williamsburg", "buffalo", "New York", "USA", 14216);

#select all the address for a user
SELECT * from user_address where user_id = 8;

#user can add payment details into the table payment details and same will be updated in user_payment_details;
START TRANSACTION;
INSERT INTO payment_details(payment_type, card_number, exp_date, cvv, name_on_card)
VALUES ("CREDIT", 5450411747426754, "12/29", 709, "LOIS LANE");
set @payment_details_id = LAST_INSERT_ID();
INSERT INTO user_payment_details(user_id, payment_details_id)
VALUES (8, @payment_details_id);
COMMIT;

#select the payment details of user 8
SELECT * FROM payment_details pd JOIN user_payment_details up 
ON up.payment_details_id = pd.id WHERE up.user_id = 8;

#update the address







