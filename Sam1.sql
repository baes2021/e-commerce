CREATE TABLE if not exists 'Customer' (	
'Customer_ID' varchar (100) PRIMARY key,
'First_Name'  varchar(100),
'Last_Name' varchar(100),
'Segment' varchar(100)
);

CREATE TABLE if not exists 'Order' (
    'Order_Date' varchar(100), 
	'Order_ID' varchar(100) PRIMARY KEY ,
	'Customer_ID' varchar(100),
    FOREIGN KEY('Customer_ID') REFERENCES 'Customer'('Customer_ID'));


CREATE TABLE  if not exists 'Shipment' (	
'Order_ID' varchar(100), 
'Ship_Date' varchar(100),
    'Ship_Mode' varchar(100),
	'Shipment_ID' int(100) PRIMARY key,
    FOREIGN KEY('Order_ID') REFERENCES 'Order'('Order_ID'));



CREATE TABLE if not exists 'Address' ('Country' varchar(100),
'City' varchar(100),
'State' varchar(100),
'Postal_Code' varchar(100),
'Region' varchar(100),
'Order_ID' varchar(100),
'Address_ID' int(100) PRIMARY key,
FOREIGN KEY('ORDER_ID') REFERENCES 'Order'('ORDER_ID')
);


CREATE TABLE  if not exists 'Product' (
'Product_ID' varchar(100),
'Product_Name' varchar(100),
'Category' varchar(100),
'Sub_Category' varchar(100),
PRIMARY KEY('Product_ID','Product_Name')
);

CREATE TABLE  if not EXISTS 'Sale' (
'Product_ID' varchar(100),
'Quantity' int,
'Discount' float,
'Profit' float, 
'Sales' float, 
'Customer_ID' varchar(100),
FOREIGN KEY('Product_ID') REFERENCES 'Product'('Product_ID'),
FOREIGN KEY('Customer_ID') REFERENCES 'Customer'('Customer_ID')
);
