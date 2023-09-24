# to install the module uncomment the following
#pip install pandas
#pip install mysql-connector-python

import mysql.connector
import pandas as pd
import re
import math
import random
from collections import OrderedDict
import datetime 

#insert user data 
def insertDataIntoUserTable(f_name, l_name, type, dob, country_code, mobile_number, email, username, password, m_name = ""):
    
    conn = mysql.connector.connect(user='root', password='123456', host='127.0.0.1', database='projectdb')

    cursor = conn.cursor()
    
    date =  datetime.datetime.strptime("08-11-1997", "%d-%m-%Y")
    
    sql = ( "INSERT INTO USER(f_name, m_name, l_name, type, dob, country_code, mobile_number, email, username, password) "
              " VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)" )
    data = (f_name, m_name, l_name, type, date.strftime('%Y-%m-%d'), country_code, mobile_number, email, username, password)
    
    try:
       # Executing the SQL command
       cursor.execute(sql, data)

       # Commit your changes in the database
       conn.commit()

    except:
        # Rolling back in case of error
        conn.rollback()
        
    conn.close()
    
    return "Success"

#insert vendor information
def insertVendorInformation(vendor_name):
    
    conn = mysql.connector.connect(user='root', password='123456', host='127.0.0.1', database='projectdb')

    cursor = conn.cursor()
    
    sql = ( "INSERT INTO vendor(name) VALUES(%s)" )
    data = (vendor_name,)
    
    try:
       # Executing the SQL command
       cursor.execute(sql, data)

       # Commit your changes in the database
       conn.commit()

    except:
        # Rolling back in case of error
        conn.rollback()
        
    conn.close()
    
    return "Success"   

def updateVendorAdminTable():
    
    conn = mysql.connector.connect(user='root', password='123456', host='127.0.0.1', database='projectdb')

    cursor = conn.cursor()
    
    # get the list of vendor and user account that are admin
    sql = '''SELECT * from user where type = "ADMIN"'''
    cursor.execute(sql)

    result_user = cursor.fetchall();
    
    sql = '''SELECT * from vendor'''
    cursor.execute(sql)

    result_vendor = cursor.fetchall();
    
    #vendor admin for walmart
    admin_id = result_user[0][0]
    vendor_id = result_vendor[0][0]
    sql = ( "INSERT INTO vendor_admin(user_id, vendor_id) VALUES (%s, %s)" )
    data = (admin_id, vendor_id)
    
    try:
        cursor.execute(sql, data)
        conn.commit()
    except Exception as e: 
        print(e)
        conn.rollback()
        
    #vendor admin for amazon
    admin_id = result_user[1][0]
    vendor_id = result_vendor[1][0]
    sql = ( "INSERT INTO vendor_admin(user_id, vendor_id) VALUES (%s, %s)" )
    data = (admin_id, vendor_id)
    
    try:
        cursor.execute(sql, data)
        conn.commit()
    except Exception as e: 
        print(e)
        conn.rollback()
    
    conn.close()
    return "Success"

def insertUserAddress():
    
    conn = mysql.connector.connect(user='root', password='123456', host='127.0.0.1', database='projectdb')

    cursor = conn.cursor()
    
    # get the list of user account that are customer
    sql = '''SELECT * from user where type = "CUSTOMER"'''
    cursor.execute(sql)

    result_user = cursor.fetchall();
    
    #address for user 1
    user_id = result_user[0][0]
    sql = ( "INSERT INTO user_address(user_id, address_line_1, city, state, country, zip) "
              " VALUES(%s, %s, %s, %s, %s, %s)" )
    sql2 = ( "INSERT INTO user_address(user_id, address_line_1, city, state, country, zip) "
               "VALUES(%s, %s, %s, %s, %s, %s)" )
    data = (user_id, "17 Affnnity ln", "Buffalo", "New York", "USA", 14215)
    data2 = (user_id, "19 Affnnity ln", "Rochester", "New York", "USA", 13445)
           
    try:
        cursor.execute(sql, data)
        cursor.execute(sql2, data2)
        conn.commit()
    except Exception as e: 
        print(e)
        conn.rollback()
           
    #address for user 2
    user_id = result_user[1][0]
    sql = ( "INSERT INTO user_address(user_id, address_line_1, city, state, country, zip)"
               "VALUES(%s, %s, %s, %s, %s, %s)" )
    
    data = (user_id, "3135 sheridan drive", "Buffalo", "New York", "USA", 14217)
           
    try:
        cursor.execute(sql, data)
        conn.commit()
    except Exception as e: 
        print(e)
        conn.rollback()
           
    conn.close()
    return "Success"

def insertPaymentDetailsAndUserPaymentDetails():
    conn = mysql.connector.connect(user='root', password='123456', host='127.0.0.1', database='projectdb')

    cursor = conn.cursor()

        # get the list of user account that are customer
    sql = '''SELECT * from user where type = "CUSTOMER"'''
    cursor.execute(sql)

    result_user = cursor.fetchall();

    #user 1 card details
    user_id = result_user[0][0]

    sql1 = """INSERT INTO payment_details(payment_type, card_number, exp_date, cvv, name_on_card)
                VALUES("CREDIT", 4211567156679544, "01/28", 625, "Barry Allen")"""

    try:
        cursor.execute(sql1)
        payment_details_id = cursor.lastrowid

        sql2 = ( "INSERT INTO user_payment_details(user_id, payment_details_id)"
                   "VALUES(%s, %s)" )
        data = (user_id, payment_details_id)

        cursor.execute(sql2, data)
        conn.commit()
    except Exception as e:
        print(e)
        conn.rollback()

    #user 2 card details
    user_id = result_user[1][0]

    sql1 = """INSERT INTO payment_details(payment_type, card_number, exp_date, cvv, name_on_card)
                VALUES("DEBIT", 4211567156788269, "08/25", 722, "Diana Prince")"""

    sql2 = """INSERT INTO payment_details(payment_type, card_number, exp_date, cvv, name_on_card)
                VALUES("CREDIT", 4211567156787869, "06/27", 069, "Diana Prince")"""
    try:
        cursor.execute(sql1)
        payment_details_id = cursor.lastrowid

        sql3 = ( "INSERT INTO user_payment_details(user_id, payment_details_id)"
                   "VALUES(%s, %s)" )
        data = (user_id, payment_details_id)

        cursor.execute(sql3, data)

        cursor.execute(sql2)
        payment_details_id = cursor.lastrowid

        sql4 = ( "INSERT INTO user_payment_details(user_id, payment_details_id)"
                   "VALUES(%s, %s)" )
        data = (user_id, payment_details_id)

        cursor.execute(sql4, data)

        conn.commit()
    except Exception as e:
        print(e)
        conn.rollback()

    conn.close()


def insertCaterogiesTable(category_list):
    
    conn = mysql.connector.connect(user='root', password='123456', host='127.0.0.1', database='projectdb')

    cursor = conn.cursor()
    
    sql = ( "INSERT INTO categories(name) VALUES (%s)" )
    data = [(item, ) for item in category_list]
    try:
        cursor.executemany(sql, data)
        conn.commit()
    except Exception as e:
        print(e)
        conn.rollback()
    conn.close()

def checkProductData(row):
    for i,x in enumerate(row):
        if not isinstance(x, str) and math.isnan(x):
            row[i] = ""
        if isinstance(x, str) and len(x) > 0 and x[0] == "$":
            temp = x.split("-")
            
            row[i] = float(temp[0][1:])

def insertProductDetailsIntoTables(df, vendor_name):
    
    conn = mysql.connector.connect(user='root', password='123456', host='127.0.0.1', database='projectdb')

    cursor = conn.cursor()
    #get vendor id
    sql = ( "SELECT id from vendor where name = %s")
    data = (vendor_name, )
    vendor_id = ""
    cursor.execute(sql, data)
    vendor_id = cursor.fetchall();
    vendor_id = vendor_id[0][0]
    
    for i,row in enumerate(df):
        category = row[10]
        result = []
        if isinstance(category, str):
            
            cx = set()
            items = ""
            items = re.split(r"[\n|,&\n\n]\s*", category)
            for x in items:
                cx.add(x.strip())

            cl = []
            for item in cx:
                cl.append(str(item.strip()))

            format_strings = ','.join(['%s'] * len(cl))
            cursor.execute("SELECT id FROM categories WHERE name IN (%s)" % format_strings,
                    tuple(cl))
            result = cursor.fetchall()
        
        try:
            print(i)
            sql = ( "INSERT INTO product_details(name, description, product_image_url, cost_price, selling_price, "
                   "quantity, dimension, specification, brand_name, color)"
                   "VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)" )
            checkProductData(row)
            data = (row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9])
            cursor.execute(sql, data)
            product_details_id = cursor.lastrowid

            sql = ( "INSERT INTO product_vendor(vendor_id, product_details_id)"
                   "VALUES(%s, %s)" )
            data = (vendor_id, product_details_id)
            cursor.execute(sql, data)
  
            sql = ( "INSERT INTO product_categories(category_id, product_details_id)"
                   "VALUES(%s, %s)" )
            data = [(item[0], product_details_id, ) for item in result]
            
            cursor.executemany(sql, data)      

            conn.commit()
        except Exception as e:
            print(e)
            conn.rollback()
    conn.close()

def updateProductInformation():
    
    
    df_amazon = pd.read_csv("amazon.csv")
    df_walmart = pd.read_csv("walmart.csv")
    df_amazon.dropna(subset=['Selling Price'], inplace = True)

    category_set = set()
    for cat in df_amazon["Category"]:
        items = []
        if isinstance(cat, str):
            items = re.split(r"[\n|,&\n\n]\s*", cat)
        for x in items:
            category_set.add(x.strip())
            
    for cat in df_walmart["Category"]:
        items = []
        if isinstance(cat, str):
            items = re.split(r"[\n|,&\n\n]\s*", cat)
        for x in items:
            category_set.add(x.strip())
    
    category_list = []

    for item in category_set:
        category_list.append(str(item.strip()))
    
    insertCaterogiesTable(category_list)
    
    for index, row in df_amazon.iterrows():
        
        product_details = []
        product_details.append(row["Product Name"])
        product_details.append(row["About Product"])
        product_details.append(row["Product Url"])
        if row["List Price"] is None or math.isnan(row["List Price"]):
            product_details.append(row["Selling Price"])
        else:
            product_details.append(row["List Price"])
        product_details.append(row["Selling Price"])
        if row["Quantity"] is None or math.isnan(row["Quantity"]):
            product_details.append(random.randint(1,20))
        else:
            product_details.append(row["Quantity"])
        product_details.append(row["Product Dimensions"] )
        product_details.append(row["Product Details"])
        product_details.append(row["Brand Name"])
        product_details.append(row["Color"])
        product_details.append(row["Category"])
    
        product_details_amazon.append(product_details)
    
    
    for index, row in df_walmart.iterrows():
        product_details = []

        product_details.append(row["Product Name"])
        product_details.append(row["Description"])
        product_details.append(row["Product Url"])
        if row["List Price"] is None or math.isnan(row["List Price"]):
            product_details.append(row["Sale Price"])
        else:
            product_details.append(row["List Price"])
        product_details.append(row["Sale Price"])
        product_details.append(random.randint(1,20))

        product_details.append("")
        product_details.append(row["Package Size"])
        product_details.append(row["Brand"])
        product_details.append("")
        product_details.append(row["Category"])

        product_details_walmart.append(product_details)
    

    insertProductDetailsIntoTables(product_details_amazon, "amazon")
    insertProductDetailsIntoTables(product_details_walmart, "walmart")

if __name__ == '__main__':
    
    #insert data into user table
        
    #super-admin 1
    status = insertDataIntoUserTable("suraj", "Rath", "SUPERADMIN", '08-11-1997', 1, 7168675862,  
                                        "surajrath201@gmail.com", "suraj201", "123456")
    #super-admin 2
    status = insertDataIntoUserTable("Pratiksha", "Sharma", "SUPERADMIN", '08-11-1997', 1, 7168675860,  
                                        "pratik8sha@gmail.com", "pratik8sha", "123456")
        
    #admin account for walmart and amazon
    status = insertDataIntoUserTable("Bruce", "Wayne", "ADMIN", '08-07-1998', 1, 71686678487,  
                                        "random@random.com", "batman", "123456")
    status = insertDataIntoUserTable("clark", "Kent", "ADMIN", '08-07-1998', 1, 7168464727,  
                                        "random21@random.com", "superman", "123456")
        
    #user account
    #user 1
    status = insertDataIntoUserTable("Barry", "allen", "CUSTOMER", '08-07-1998', 
                1, 7168464322,  "random22@random.com", "flash", "123456")
    #user 2
    status = insertDataIntoUserTable("Diana", "Prince", "CUSTOMER", '08-07-1998', 
                1, 7168464342,  "random23@random.com", "wonderWomen", "123456")


    #insert vendor information
    # vendor walmart
    status = insertVendorInformation("walmart")
       
    # VENDOR 2 "amazon"
    status = insertVendorInformation("amazon")
    
    
    status = updateVendorAdminTable()
 
    status = insertUserAddress()
    status = insertPaymentDetailsAndUserPaymentDetails()

    
    product_details_amazon = []
    product_details_walmart = []
    updateProductInformation()
