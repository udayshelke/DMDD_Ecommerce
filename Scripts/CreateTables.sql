--Create tables

CREATE TABLE customer (
	cust_id NUMBER(38) PRIMARY KEY,
	First_Name VARCHAR2(50),
	Last_Name VARCHAR2(50),
	DOB DATE,
	cust_phoneno VARCHAR2(50),
	cust_email VARCHAR2(100)
);
CREATE TABLE customerAddress(
	custAdd_id NUMBER(38) PRIMARY KEY,
    cust_id NUMBER(38) NOT NULL REFERENCES customer(cust_id),
	Street VARCHAR2(50),
	city VARCHAR2(50),
	state VARCHAR2(50),
	zipcode NUMBER(38)
);
CREATE TABLE Order(
	order_id NUMBER(38) PRIMARY KEY,
    payment_type_id NUMBER(38) NOT NULL REFERENCES PaymentType(payment_type_id),
	cust_id NUMBER(38) NOT NULL REFERENCES customer(cust_id),
	orderDate DATE
);
CREATE TABLE OrderDeliveryStatus(
	order_status_id NUMBER(38) PRIMARY KEY,
    order_id NUMBER(38) NOT NULL REFERENCES order(order_id),
	delivery_partner_id NUMBER(38) NOT NULL REFERENCES DeliveryPartner(delivery_partner_id),
	Order_Status_Name VARCHAR2(50)
);
CREATE TABLE DeliveryPartner(
	delivery_partner_id NUMBER(38) PRIMARY KEY,
    delivery_partner_name VARCHAR2(50),
	delivery_partner_phoneno VARCHAR2(50),
	delivery_partner_email VARCHAR2(100)
);
CREATE TABLE OrderDetails(
	order_Details_id NUMBER(38) PRIMARY KEY,
    Product_id NUMBER(38) NOT NULL REFERENCES product(product_id),
	order_id NUMBER(38) NOT NULL REFERENCES order(order_id)
);
CREATE TABLE product(
	product_id NUMBER(38) PRIMARY KEY,
    product_type_id NUMBER(38) NOT NULL REFERENCES ProductType(product_type_id),
	product_name VARCHAR2(50),
	product_active VARCHAR2(50),
	product_cost NUMBER(38),
	product_quantity NUMBER(38)
);
CREATE TABLE PaymentType(
	payment_type_id NUMBER(38) PRIMARY KEY,
    payment_type_name VARCHAR2(50)
);
CREATE TABLE ProductType(
	product_type_id NUMBER(38) PRIMARY KEY,
    product_type_name VARCHAR2(50),
	product_type_description VARCHAR2(50)
);
CREATE TABLE Distributor(
	distributor_id NUMBER(38) PRIMARY KEY,
	product_id NUMBER(38) NOT NULL REFERENCES product(product_id),
	product_manufacturer_id NUMBER(38) NOT NULL REFERENCES ProductManufacturer(product_manufacturer_id),
    product_quantity NUMBER(38)
);
CREATE TABLE ProductManufacturer(
	product_manufacturer_id NUMBER(38) PRIMARY KEY,
);