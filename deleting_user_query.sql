#delete a user and observe other table

DELETE from user where id = 8;

select * from user_address;
select * from user_payment_details;
#we are not deleting the payment details from the table payment_details table 
#as two peoples can have same payment details(for eg wife using husband's card on her account as well as husband's account)

select * from user_cart;

#we are also not deleting the order history as the vendor might want to see the transactions user have made from their inventory