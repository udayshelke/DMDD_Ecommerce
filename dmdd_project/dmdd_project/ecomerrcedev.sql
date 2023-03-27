

drop role mihir;
drop user customer cascade;
create role mihir identified by makwana101;
create user customer identified by MihirMakwana801;
grant connect, resource to customer;
grant create session to customer;
grant unlimited tablespace to customer;
grant select on order_details to mihir;
grant select on product to mihir;
grant select on product_type to mihir;
grant select, update on payment_type to mihir;
grant select on order_delivery_status to mihir;
grant select, update, delete on customer_address to mihir;
grant select, update, delete on customer to mihir;
grant mihir to customer;



--CLEANUP SCRIPT
set serveroutput on
declare
    v_table_exists varchar(1) := 'Y';
    v_sql varchar(2000);
begin
   dbms_output.put_line('Start schema cleanup');
             
      execute immediate 'alter table DISTRIBUTOR drop column Product_manufacturer_ID';
      execute immediate 'alter table PRODUCT_MANUFACTURER drop column Distributor_ID';
      
      
   for i in (select 'CUSTOMER_ADDRESS' table_name from dual union all
             select 'ORDER_DELIVERY_STATUS' table_name from dual union all
             select 'ORDER_DETAILS' table_name from dual union all
             select 'CUSTOMER_ORDER' table_name from dual union all
             select 'PAYMENT_TYPE' table_name from dual union all
             select 'CUSTOMER' table_name from dual union all
             select 'PRODUCT_MANUFACTURER' table_name from dual union all
             select 'DISTRIBUTOR' table_name from dual union all
             select 'PRODUCT' table_name from dual union all
             select 'PRODUCT_TYPE' table_name from dual union all
             select 'DELIVERY_PARTNER' table_name from dual
   )
   loop
   dbms_output.put_line('....Drop table '||i.table_name);
   begin
       select 'Y' into v_table_exists
       from USER_TABLES
       where TABLE_NAME=i.table_name;

       v_sql := 'drop table '||i.table_name;
       execute immediate v_sql;
       dbms_output.put_line('........Table '||i.table_name||' dropped successfully');
       
   exception
       when no_data_found then
           dbms_output.put_line('........Table already dropped');
   end;
   end loop;
   dbms_output.put_line('Schema cleanup successfully completed');
exception
   when others then
      dbms_output.put_line('Failed to execute code:'||sqlerrm);
end;
/

--CREATE TABLES AS PER DATA MODEL


create table customer(
CustomerID number(38) PRIMARY KEY,
Customer_FirstName varchar2(50),
Customer_LastName varchar2(20),
Customer_DOB date,
Customer_PhoneNo varchar2(20),
Customer_Email varchar2(100)
)
/

create table customer_address(
CustomerAdd_ID number(38) PRIMARY KEY,
CustomerID number(38) REFERENCES customer (CustomerID),
Street varchar2(200),
State varchar2(200),
City varchar2(50),
Zip number(38)
)

/

create table payment_type(
Payment_type_ID number(38) PRIMARY KEY,
Payment_type_name varchar2(50))
/

create table product_type(
Product_type_ID number(38) PRIMARY KEY,
Product_type_name varchar(50),
Product_Description varchar(500))
/

create table product(
Product_ID number(38) PRIMARY KEY,
Product_type_ID number(38) REFERENCES product_type (Product_type_ID),
Product_name varchar2(200),
Product_cost number(38),
Product_active varchar2(20),
Product_quantity number(38))
/

create table distributor(
Distributor_ID number (38) PRIMARY KEY,
Product_ID number(38),
Product_manufacturer_ID number(38),
Product_Quantity number(38),
CONSTRAINT FK_Product_ID FOREIGN KEY (Product_ID) REFERENCES product(Product_ID))
/

create table product_manufacturer(
Product_manufacturer_ID number(38) PRIMARY KEY,
Distributor_ID number(38),
CONSTRAINT FK_Distributor_ID FOREIGN KEY (Distributor_ID) REFERENCES distributor(Distributor_ID))
/

alter table distributor add CONSTRAINT FK_Product_manufacturer_ID FOREIGN KEY (Product_manufacturer_ID) REFERENCES product_manufacturer(Product_manufacturer_ID);

create table customer_order(
Order_ID number(38) PRIMARY KEY,
Order_date date,
Payment_type_ID number(38) REFERENCES payment_type (Payment_type_ID),
CustomerID number(38) REFERENCES customer (CustomerID))
/

create table order_details(
Order_details_ID number(38) PRIMARY KEY,
Product_ID number(38) REFERENCES product (Product_ID),
Order_ID number(38) REFERENCES customer_order (Order_ID))
/

create table delivery_partner(
Delivery_partner_ID number(38) PRIMARY KEY,
Delivery_partner_Name varchar2(50),
Delivery_partner_PhoneNo varchar2(20),
Deliver_partner_Email varchar2(100))
/

create table order_delivery_status(
Order_delivery_status_ID number(38) PRIMARY KEY,
Order_delivery_status_Name varchar2(50),
Order_ID number(38) REFERENCES customer_order (Order_ID),
Delivery_partner_ID number(38) REFERENCES delivery_partner (Delivery_partner_ID)
)
/



insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (1, 'Julie', 'Alejandro', '23-Feb-2023', '6315978924', 'jalejandro0@biglobe.ne.jp');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (2, 'Corny', 'Stihl', '26-Sep-2022', '8209511531', 'cstihl1@shinystat.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (3, 'Elisha', 'Orviss', '18-Apr-2022', '7884253303', 'eorviss2@phpbb.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (4, 'Ansley', 'Chipping', '05-Sep-2022', '7016871574', 'achipping3@businessinsider.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (5, 'Arvie', 'Witul', '18-Jan-2023', '9458002236', 'awitul4@tamu.edu');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (6, 'Trumaine', 'Sebire', '01-Mar-2023', '1393378393', 'tsebire5@lulu.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (7, 'Melesa', 'Kestian', '19-May-2022', '5213304477', 'mkestian6@deliciousdays.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (8, 'Cornell', 'Oakly', '25-Sep-2022', '8329512900', 'coakly7@whitehouse.gov');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (9, 'Othella', 'Melby', '25-Jul-2022', '8743705270', 'omelby8@wordpress.org');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (10, 'Ashia', 'Hacquard', '19-Dec-2022', '9038018324', 'ahacquard9@nydailynews.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (11, 'Granger', 'Belshaw', '15-Nov-2022', '9087145557', 'gbelshawa@cpanel.net');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (12, 'Jeralee', 'Jiles', '05-Dec-2022', '4179574038', 'jjilesb@seattletimes.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (13, 'Betsy', 'Brumbie', '05-Nov-2022', '6911458497', 'bbrumbiec@smugmug.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (14, 'Lorilee', 'Preto', '01-Dec-2022', '2741075204', 'lpretod@prweb.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (15, 'Berke', 'Maevela', '23-May-2022', '9079553557', 'bmaevelae@google.it');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (16, 'Lolita', 'Topaz', '30-Apr-2022', '8349825307', 'ltopazf@photobucket.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (17, 'Brooke', 'Pyatt', '25-Feb-2023', '8409679214', 'bpyattg@chron.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (18, 'Marti', 'Jakoviljevic', '22-Nov-2022', '9184058206', 'mjakoviljevich@ovh.net');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (19, 'Kania', 'Kobiela', '05-Dec-2022', '3339402403', 'kkobielai@homestead.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (20, 'Bobbie', 'Drugan', '08-Apr-2022', '1185739454', 'bdruganj@omniture.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (21, 'Luce', 'Mundwell', '24-Feb-2023', '5961591468', 'lmundwellk@dagondesign.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (22, 'Hakim', 'Wybourne', '09-Apr-2022', '9079708638', 'hwybournel@loc.gov');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (23, 'Pepito', 'Bremeyer', '12-Jul-2022', '1454058653', 'pbremeyerm@issuu.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (24, 'Rania', 'Dulake', '16-Jul-2022', '7863419451', 'rdulaken@multiply.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (25, 'Conn', 'Yukhnini', '09-Jul-2022', '8413704016', 'cyukhninio@ocn.ne.jp');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (26, 'Nadean', 'Simoneton', '12-Oct-2022', '5163512339', 'nsimonetonp@ox.ac.uk');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (27, 'Star', 'Bosomworth', '20-Dec-2022', '3379866367', 'sbosomworthq@china.com.cn');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (28, 'Sabra', 'Haveline', '08-May-2022', '8105483475', 'shaveliner@biblegateway.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (29, 'Ailey', 'Rozsa', '07-Jan-2023', '7212387599', 'arozsas@furl.net');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (30, 'Regan', 'Dominelli', '02-Aug-2022', '6806773281', 'rdominellit@hubpages.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (31, 'Shirlene', 'Izatson', '24-Sep-2022', '3686014943', 'sizatsonu@is.gd');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (32, 'Malissia', 'Burroughes', '13-Nov-2022', '4618869654', 'mburroughesv@upenn.edu');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (33, 'Humphrey', 'Smewing', '29-Jul-2022', '3461294075', 'hsmewingw@blogtalkradio.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (34, 'Demott', 'Johann', '23-Feb-2023', '5184555960', 'djohannx@npr.org');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (35, 'Mari', 'Brute', '12-Jan-2023', '5901553071', 'mbrutey@wikimedia.org');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (36, 'Any', 'Whacket', '22-Jul-2022', '8781807884', 'awhacketz@salon.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (37, 'Sheelagh', 'Balding', '13-May-2022', '6595774874', 'sbalding10@1und1.de');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (38, 'Matthieu', 'Scholtz', '19-Sep-2022', '5758802630', 'mscholtz11@discuz.net');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (39, 'Kellie', 'Liver', '16-Apr-2022', '3078165582', 'kliver12@google.es');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (40, 'Goran', 'McCarl', '14-Jan-2023', '2345353758', 'gmccarl13@oracle.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (41, 'Nanette', 'Stancer', '12-Feb-2023', '2397521388', 'nstancer14@cargocollective.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (42, 'Willette', 'Hanford', '25-Aug-2022', '4656483105', 'whanford15@shutterfly.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (43, 'Elinore', 'Spirritt', '26-Jun-2022', '5182719435', 'espirritt16@imageshack.us');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (44, 'Cherida', 'Dauby', '19-Jan-2023', '6321721269', 'cdauby17@google.pl');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (45, 'Merrili', 'Hollingsbee', '05-Jun-2022', '2526951197', 'mhollingsbee18@woothemes.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (46, 'Bruis', 'Gauchier', '18-Jun-2022', '6632033370', 'bgauchier19@jigsy.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (47, 'Hali', 'Kaser', '07-Apr-2022', '6353017184', 'hkaser1a@phoca.cz');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (48, 'Preston', 'Coggell', '25-Aug-2022', '9166985534', 'pcoggell1b@skype.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (49, 'Edsel', 'Gooder', '08-Aug-2022', '2615073457', 'egooder1c@cargocollective.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (50, 'Sophie', 'Delete', '27-Oct-2022', '3662689591', 'sdelete1d@reuters.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (51, 'Paquito', 'O''Dennehy', '03-Nov-2022', '4752688171', 'podennehy1e@meetup.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (52, 'Kermy', 'Cooley', '02-Jun-2022', '9016569584', 'kcooley1f@accuweather.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (53, 'Coleen', 'Harbertson', '22-Nov-2022', '1776456334', 'charbertson1g@utexas.edu');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (54, 'Vinni', 'Beckingham', '06-Jan-2023', '8732069335', 'vbeckingham1h@bluehost.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (55, 'Bradney', 'Kovacs', '04-Apr-2022', '2444849289', 'bkovacs1i@prnewswire.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (56, 'Adlai', 'Sallings', '14-Nov-2022', '8725010068', 'asallings1j@amazon.de');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (57, 'Lindie', 'Mulrean', '19-Mar-2023', '2525562854', 'lmulrean1k@geocities.jp');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (58, 'Nonna', 'Clarkson', '29-Dec-2022', '9986262562', 'nclarkson1l@berkeley.edu');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (59, 'Patsy', 'Tatham', '14-May-2022', '6885503044', 'ptatham1m@macromedia.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (60, 'Bertram', 'Pankhurst.', '09-Jan-2023', '7724817117', 'bpankhurst1n@google.fr');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (61, 'Korry', 'Marflitt', '27-Sep-2022', '1076621515', 'kmarflitt1o@ycombinator.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (62, 'Jorry', 'Spritt', '06-Oct-2022', '4135799988', 'jspritt1p@patch.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (63, 'Ikey', 'Fairholme', '08-Aug-2022', '6296116710', 'ifairholme1q@de.vu');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (64, 'Vyky', 'Amy', '30-Sep-2022', '9042254792', 'vamy1r@usnews.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (65, 'Karyl', 'Tulleth', '08-Oct-2022', '7529522560', 'ktulleth1s@friendfeed.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (66, 'Farris', 'Vicent', '12-Apr-2022', '6744783055', 'fvicent1t@cdc.gov');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (67, 'Yuri', 'Gingold', '01-Apr-2022', '1684967011', 'ygingold1u@cargocollective.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (68, 'Marji', 'Messer', '16-Jul-2022', '5225658163', 'mmesser1v@imgur.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (69, 'Manuel', 'Midgley', '29-Mar-2022', '3467052781', 'mmidgley1w@elpais.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (70, 'Yuri', 'Dooney', '02-Feb-2023', '7766441822', 'ydooney1x@parallels.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (71, 'Sandye', 'Skein', '31-Mar-2022', '2594726567', 'sskein1y@apache.org');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (72, 'Guillemette', 'Sempill', '03-Nov-2022', '9269170021', 'gsempill1z@wisc.edu');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (73, 'Brok', 'Bowker', '04-Dec-2022', '6119913762', 'bbowker20@discuz.net');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (74, 'Fredi', 'Shire', '09-Sep-2022', '4378824516', 'fshire21@meetup.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (75, 'Lucy', 'Heinig', '18-Nov-2022', '5115520410', 'lheinig22@slashdot.org');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (76, 'Dana', 'Chasemore', '06-Oct-2022', '7118987485', 'dchasemore23@bbb.org');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (77, 'Renae', 'Semken', '12-May-2022', '4457880533', 'rsemken24@about.me');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (78, 'Emanuel', 'L'' Estrange', '23-Mar-2023', '9501650712', 'elestrange25@vkontakte.ru');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (79, 'Kaitlynn', 'Gyer', '28-Jun-2022', '5283795705', 'kgyer26@businesswire.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (80, 'Jessica', 'Forsbey', '04-Jun-2022', '1773800782', 'jforsbey27@biglobe.ne.jp');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (81, 'Enriqueta', 'Bellocht', '21-Apr-2022', '5714910429', 'ebellocht28@linkedin.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (82, 'Abelard', 'Ballendine', '09-Oct-2022', '3727653690', 'aballendine29@creativecommons.org');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (83, 'Carlota', 'McCard', '12-Feb-2023', '4052575398', 'cmccard2a@newyorker.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (84, 'Sheeree', 'Wrightson', '18-Apr-2022', '9783869183', 'swrightson2b@typepad.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (85, 'Tremain', 'Wormstone', '08-Apr-2022', '9376739060', 'twormstone2c@typepad.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (86, 'Mohandas', 'Whittlesey', '26-Jan-2023', '7785550347', 'mwhittlesey2d@google.nl');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (87, 'Conni', 'Berrey', '30-Oct-2022', '3155970719', 'cberrey2e@xing.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (88, 'Desdemona', 'Eslinger', '03-Jun-2022', '1373342716', 'deslinger2f@yahoo.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (89, 'Niel', 'Popplewell', '11-May-2022', '4964861222', 'npopplewell2g@amazon.de');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (90, 'Anjela', 'Briscow', '22-May-2022', '8978823689', 'abriscow2h@hhs.gov');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (91, 'Stoddard', 'Treverton', '26-May-2022', '9526154683', 'streverton2i@edublogs.org');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (92, 'Berenice', 'Scragg', '29-Oct-2022', '9323710692', 'bscragg2j@twitter.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (93, 'Loree', 'Sullens', '05-Dec-2022', '6716411927', 'lsullens2k@pbs.org');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (94, 'Nicholle', 'McColgan', '01-Apr-2022', '6363988154', 'nmccolgan2l@auda.org.au');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (95, 'Philippe', 'Dunsmore', '07-Aug-2022', '5664729290', 'pdunsmore2m@irs.gov');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (96, 'Godfrey', 'Folomkin', '11-Sep-2022', '5595733222', 'gfolomkin2n@yellowbook.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (97, 'Jemimah', 'Godsal', '08-Jun-2022', '8035561608', 'jgodsal2o@freewebs.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (98, 'Cherie', 'Forward', '03-Apr-2022', '5354591008', 'cforward2p@wordpress.com');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (99, 'Shaine', 'Robertsen', '29-Jun-2022', '9932137698', 'srobertsen2q@google.com.hk');
insert into customer (CustomerID, Customer_FirstName, Customer_LastName, Customer_DOB, Customer_PhoneNo, Customer_Email) values (100, 'Tamas', 'Inwood', '06-May-2022', '1399611774', 'tinwood2r@merriam-webster.com');

insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (1, 12, '57 Porter Alley', 'California', 'San Diego', '92127');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (2, 48, '63 Prentice Plaza', 'Pennsylvania', 'Pittsburgh', '15286');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (3, 35, '72041 Briar Crest Road', 'Tennessee', 'Memphis', '38143');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (4, 93, '5860 Service Lane', 'West Virginia', 'Huntington', '25726');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (5, 16, '3 Orin Plaza', 'California', 'Inglewood', '90305');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (6, 92, '1354 Pawling Court', 'Arizona', 'Phoenix', '85010');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (7, 23, '5564 Muir Place', 'Florida', 'Panama City', '32405');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (8, 94, '5 Morning Avenue', 'New Jersey', 'Newark', '07188');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (9, 44, '9 Carioca Street', 'Missouri', 'Kansas City', '64199');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (10, 9, '3 Melby Road', 'Arkansas', 'Fort Smith', '72916');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (11, 29, '563 Green Ridge Terrace', 'Pennsylvania', 'Levittown', '19058');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (12, 85, '7 Hoepker Pass', 'California', 'Santa Barbara', '93106');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (13, 69, '41539 Division Way', 'Florida', 'Miami', '33147');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (14, 98, '91 Jana Road', 'California', 'Pasadena', '91199');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (15, 83, '116 Sachtjen Street', 'Texas', 'Waco', '76705');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (16, 22, '90995 Golf View Crossing', 'Florida', 'Delray Beach', '33448');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (17, 54, '974 Garrison Pass', 'Missouri', 'Kansas City', '64199');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (18, 29, '48 Northview Junction', 'New York', 'New York City', '10024');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (19, 4, '7 Anniversary Place', 'New Jersey', 'Trenton', '08608');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (20, 33, '47659 Crescent Oaks Road', 'Arizona', 'Phoenix', '85083');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (21, 72, '458 Cardinal Point', 'Colorado', 'Denver', '80243');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (22, 29, '8 Iowa Court', 'California', 'Oakland', '94605');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (23, 45, '95494 Pierstorff Center', 'New York', 'Rochester', '14639');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (24, 27, '58256 Marcy Avenue', 'Michigan', 'Dearborn', '48126');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (25, 20, '0220 Katie Parkway', 'California', 'Redwood City', '94064');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (26, 86, '489 Judy Plaza', 'Pennsylvania', 'Philadelphia', '19125');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (27, 26, '3 Mcguire Circle', 'Missouri', 'Independence', '64054');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (28, 89, '6048 Melody Alley', 'New York', 'Buffalo', '14263');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (29, 31, '9 Comanche Crossing', 'New Jersey', 'Trenton', '08695');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (30, 55, '364 Mifflin Trail', 'Washington', 'Seattle', '98158');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (31, 62, '941 Chinook Plaza', 'Texas', 'Houston', '77065');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (32, 23, '23610 Carey Parkway', 'California', 'Fresno', '93773');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (33, 98, '58 Nelson Hill', 'Missouri', 'Saint Louis', '63158');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (34, 9, '7 Brown Junction', 'New York', 'Brooklyn', '11231');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (35, 99, '05 Hooker Hill', 'California', 'San Francisco', '94105');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (36, 39, '098 Burrows Point', 'Florida', 'Tallahassee', '32304');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (37, 84, '88074 Loftsgordon Road', 'Florida', 'Miami', '33169');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (38, 83, '78258 Hoffman Lane', 'Missouri', 'Kansas City', '64199');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (39, 79, '5 Division Hill', 'Kansas', 'Shawnee Mission', '66286');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (40, 52, '4657 Leroy Way', 'Florida', 'Gainesville', '32605');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (41, 42, '94045 Jenifer Road', 'Colorado', 'Boulder', '80328');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (42, 90, '29193 Judy Terrace', 'Florida', 'Miami', '33261');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (43, 29, '9 La Follette Alley', 'New York', 'New York City', '10175');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (44, 43, '05319 Ridgeview Junction', 'Florida', 'Homestead', '33034');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (45, 97, '803 Rigney Parkway', 'California', 'Brea', '92822');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (46, 33, '361 Hintze Court', 'North Carolina', 'Wilmington', '28405');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (47, 54, '007 Bayside Drive', 'Nevada', 'Reno', '89519');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (48, 36, '1 Vidon Street', 'Ohio', 'Cleveland', '44105');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (49, 2, '9794 Union Trail', 'Michigan', 'Kalamazoo', '49006');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (50, 98, '7 American Ash Plaza', 'Washington', 'Tacoma', '98464');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (51, 31, '394 7th Alley', 'Texas', 'San Angelo', '76905');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (52, 26, '85798 Lillian Pass', 'Virginia', 'Alexandria', '22333');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (53, 27, '7 Hanover Lane', 'Arizona', 'Glendale', '85311');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (54, 13, '0818 Superior Terrace', 'New Jersey', 'Jersey City', '07305');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (55, 99, '3604 Welch Lane', 'Alabama', 'Anniston', '36205');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (56, 37, '9054 La Follette Park', 'Alaska', 'Fairbanks', '99790');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (57, 27, '46179 Paget Terrace', 'Colorado', 'Colorado Springs', '80915');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (58, 81, '0 Meadow Ridge Center', 'Alaska', 'Anchorage', '99507');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (59, 32, '0 Cascade Drive', 'Texas', 'Corpus Christi', '78426');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (60, 5, '5 Hallows Road', 'Louisiana', 'Metairie', '70033');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (61, 61, '6 Beilfuss Trail', 'Tennessee', 'Memphis', '38104');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (62, 99, '747 Loftsgordon Pass', 'Virginia', 'Springfield', '22156');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (63, 60, '1142 Luster Avenue', 'Minnesota', 'Saint Paul', '55127');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (64, 66, '07359 Moulton Lane', 'Kansas', 'Kansas City', '66160');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (65, 26, '8 Farmco Parkway', 'Indiana', 'Terre Haute', '47805');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (66, 50, '90 Morrow Road', 'Colorado', 'Englewood', '80150');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (67, 60, '22531 Springview Way', 'District of Columbia', 'Washington', '20099');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (68, 60, '0026 Prairie Rose Lane', 'Texas', 'El Paso', '79950');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (69, 80, '731 Mitchell Way', 'Michigan', 'Kalamazoo', '49006');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (70, 84, '69525 Forest Dale Park', 'Colorado', 'Colorado Springs', '80935');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (71, 23, '634 Blaine Circle', 'Virginia', 'Richmond', '23213');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (72, 16, '9541 Portage Center', 'New York', 'Syracuse', '13205');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (73, 98, '35500 Ludington Crossing', 'Rhode Island', 'Providence', '02912');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (74, 75, '12 Dexter Drive', 'Georgia', 'Valdosta', '31605');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (75, 15, '62960 Carpenter Hill', 'Massachusetts', 'Newton', '02162');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (76, 79, '73 Eagan Plaza', 'South Carolina', 'Spartanburg', '29305');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (77, 58, '46652 Moland Terrace', 'Florida', 'Fort Lauderdale', '33336');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (78, 89, '56599 Upham Alley', 'Ohio', 'Toledo', '43610');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (79, 7, '24612 Debs Pass', 'Georgia', 'Columbus', '31904');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (80, 15, '5 Bellgrove Parkway', 'Louisiana', 'New Orleans', '70149');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (81, 91, '7 Summer Ridge Hill', 'Virginia', 'Falls Church', '22047');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (82, 30, '4828 Moulton Pass', 'South Carolina', 'Greenville', '29615');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (83, 61, '011 Hovde Trail', 'Alabama', 'Montgomery', '36177');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (84, 75, '1 Sauthoff Hill', 'New York', 'Syracuse', '13205');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (85, 30, '9472 Hallows Pass', 'Louisiana', 'New Orleans', '70142');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (86, 83, '7 Debra Lane', 'District of Columbia', 'Washington', '20210');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (87, 93, '10227 School Lane', 'Arizona', 'Tucson', '85732');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (88, 13, '189 Orin Way', 'Louisiana', 'Lake Charles', '70616');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (89, 99, '0 Shopko Place', 'Virginia', 'Richmond', '23272');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (90, 66, '125 Ramsey Crossing', 'Florida', 'West Palm Beach', '33405');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (91, 7, '212 Atwood Pass', 'California', 'Sacramento', '94263');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (92, 20, '8 Springs Point', 'Massachusetts', 'Lynn', '01905');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (93, 39, '853 West Avenue', 'Texas', 'San Antonio', '78245');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (94, 24, '097 Novick Drive', 'Minnesota', 'Monticello', '55565');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (95, 16, '52035 Grover Parkway', 'District of Columbia', 'Washington', '20016');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (96, 74, '06611 Alpine Terrace', 'Oklahoma', 'Oklahoma City', '73119');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (97, 79, '649 Merrick Alley', 'Ohio', 'Cleveland', '44197');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (98, 40, '05 Carioca Street', 'District of Columbia', 'Washington', '20420');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (99, 41, '9687 Spohn Lane', 'Delaware', 'Wilmington', '19892');
insert into customer_address (CustomerAdd_ID, CustomerID, Street, State, City, Zip) values (100, 57, '51 Melvin Pass', 'Arizona', 'Tucson', '85743');


insert into payment_type (Payment_type_ID, Payment_type_name) values (1, 'Bank Transfer');
insert into payment_type (Payment_type_ID, Payment_type_name) values (2, 'Cash On Delivery');
insert into payment_type (Payment_type_ID, Payment_type_name) values (3, 'Credit Card');
insert into payment_type (Payment_type_ID, Payment_type_name) values (4, 'GPay');
insert into payment_type (Payment_type_ID, Payment_type_name) values (5, 'Debit Card');
insert into payment_type (Payment_type_ID, Payment_type_name) values (6, 'Apple Pay');
insert into payment_type (Payment_type_ID, Payment_type_name) values (7, 'PayPal');


insert into product_type (Product_type_ID, Product_type_name, Product_Description) values (1, 'Computer', 'Major contusion of left kidney, subsequent encounter');
insert into product_type (Product_type_ID, Product_type_name, Product_Description) values (2, 'Pet', 'Other myositis, left lower leg');
insert into product_type (Product_type_ID, Product_type_name, Product_Description) values (3, 'Beauty', 'Subluxation of tarsometatarsal joint of unspecified foot, initial encounter');
insert into product_type (Product_type_ID, Product_type_name, Product_Description) values (4, 'Sports', 'Nasopharyngeal myiasis');
insert into product_type (Product_type_ID, Product_type_name, Product_Description) values (5, 'Headphones', 'Legal intervention involving injury by tear gas, law enforcement official injured, initial encounter');
insert into product_type (Product_type_ID, Product_type_name, Product_Description) values (6, 'Electronics', 'Legal intervention involving unspecified firearm discharge, law enforcement official injured, sequela');
insert into product_type (Product_type_ID, Product_type_name, Product_Description) values (7, 'Food and Gorcery', 'Traumatic hemorrhage of right cerebrum with loss of consciousness of unspecified duration, initial encounter');
insert into product_type (Product_type_ID, Product_type_name, Product_Description) values (8, 'Lifestyle', 'Nondisplaced fracture of anterior wall of unspecified acetabulum, initial encounter for open fracture');
insert into product_type (Product_type_ID, Product_type_name, Product_Description) values (9, 'Clothes', 'Other physeal fracture of upper end of unspecified fibula, sequela');
insert into product_type (Product_type_ID, Product_type_name, Product_Description) values (10, 'Books', 'Displaced fracture of neck of scapula, left shoulder, subsequent encounter for fracture with malunion');


insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (1, 1, 'apple', 773, 'Out of stock', 26);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (2, 2, 'dog lotion', 117, 'Out of stock', 80);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (3, 3, 'beauty soap', 189, 'In stock', 88);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (4, 4, 'cricket bat', 249, 'Out of stock', 16);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (5, 5, 'sony', 142, 'Out of stock', 53);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (6, 6, 'Tv', 823, 'Out of stock', 8);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (7, 7, 'Tomatoes', 691, 'Out of stock', 10);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (8, 8, 'Plants', 571, 'Out of stock', 45);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (9, 9, 'Hm', 519, 'Out of stock', 10);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (10, 10, 'a', 1055, 'Out of stock', 40);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (11, 1, 'acer', 1473, 'Out of stock', 74);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (12, 2, 'small pet soap', 258, 'Out of stock', 41);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (13, 3, 'beauty lotion', 1390, 'Out of stock', 9);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (14, 4, 'football', 1170, 'Out of stock', 99);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (15, 5, 'jbl', 130, 'In stock', 87);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (16, 6, 'watch', 1217, 'In stock', 70);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (17, 7, 'lettuce', 1130, 'In stock', 11);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (18, 8, 'Dining Table', 638, 'Out of stock', 99);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (19, 9, 'zara', 148, 'In stock', 9);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (20, 10, 'b', 329, 'In stock', 10);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (21, 1, 'asus', 1395, 'Out of stock', 87);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (22, 2, 'horse hair cleaner', 438, 'Out of stock', 71);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (23, 3, 'fair and lovely', 1494, 'In stock', 36);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (24, 4, 'cricket ball', 987, 'Out of stock', 85);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (25, 5, 'apple airpods', 1194, 'In stock', 33);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (26, 6, 'apple watch', 500, 'In stock', 99);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (27, 7, 'Banana', 485, 'In stock', 89);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (28, 8, 'Fancy lights', 615, 'In stock', 62);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (29, 9, 'gucci', 1366, 'In stock', 69);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (30, 10, 'c', 613, 'In stock', 71);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (31, 1, 'dell', 1070, 'Out of stock', 76);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (32, 2, 'cat lotion', 1125, 'Out of stock', 61);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (33, 3, 'face wash', 928, 'In stock', 37);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (34, 4, 'tennis ball', 124, 'In stock', 62);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (35, 5, 'nothing ear 1', 682, 'Out of stock', 99);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (36, 6, 'Speaker', 1369, 'Out of stock', 42);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (37, 7, 'Onions', 762, 'In stock', 14);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (38, 8, 'Photo Frames', 781, 'Out of stock', 23);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (39, 9, 'prada', 56, 'In stock', 76);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (40, 10, 'd', 1070, 'In stock', 17);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (41, 1, 'lenovo', 830, 'In stock', 10);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (42, 2, 'pet care', 344, 'Out of stock', 34);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (43, 3, 'shower gel', 225, 'In stock', 77);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (44, 4, 'ping pong ball', 350, 'Out of stock', 53);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (45, 5, 'soundcore', 1323, 'In stock', 44);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (46, 6, 'Mobile phones', 1244, 'Out of stock', 57);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (47, 7, 'Potatoes', 1154, 'In stock', 40);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (48, 8, 'Poster', 37, 'In stock', 41);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (49, 9, 'burberry', 417, 'Out of stock', 47);
insert into product (Product_ID, Product_type_ID, Product_name, Product_cost, Product_active, Product_quantity) values (50, 10, 'e', 500, 'Out of stock', 72);


INSERT INTO product_manufacturer VALUES (1, null);

INSERT INTO distributor VALUES (1, 1, 1, 10);
INSERT INTO distributor VALUES (2, 22, 1, 20);
INSERT INTO distributor VALUES (3, 3, 1, 30);
INSERT INTO distributor VALUES (4, 46, 1, 30);
INSERT INTO distributor VALUES (5, 31, 1, 30);
INSERT INTO distributor VALUES (6, 24, 1, 30);
INSERT INTO distributor VALUES (7, 1, 1, 30);
INSERT INTO distributor VALUES (8, 20, 1, 30);
INSERT INTO distributor VALUES (9, 50, 1, 30);
INSERT INTO distributor VALUES (10, 36, 1, 30);

UPDATE product_manufacturer SET Distributor_ID = 1 WHERE Product_manufacturer_ID = 1; 


insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (1, '06-Feb-2023', 5, 59);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (2, '14-Sep-2022', 1, 36);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (3, '08-Feb-2023', 1, 70);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (4, '27-Aug-2022', 3, 61);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (5, '09-Aug-2022', 6, 22);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (6, '24-Jun-2022', 2, 79);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (7, '11-Mar-2023', 7, 4);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (8, '12-Mar-2023', 6, 96);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (9, '26-Jan-2023', 5, 1);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (10, '02-Jul-2022', 7, 97);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (11, '27-Jul-2022', 2, 68);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (12, '23-Feb-2023', 6, 97);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (13, '28-Dec-2022', 2, 84);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (14, '17-May-2022', 3, 45);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (15, '07-Jul-2022', 1, 21);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (16, '08-Aug-2022', 5, 14);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (17, '11-Sep-2022', 2, 16);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (18, '17-Nov-2022', 2, 16);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (19, '17-Feb-2023', 2, 75);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (20, '18-Apr-2022', 7, 41);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (21, '25-Jul-2022', 5, 35);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (22, '10-Nov-2022', 2, 54);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (23, '08-Jan-2023', 5, 88);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (24, '28-Aug-2022', 5, 31);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (25, '29-Dec-2022', 2, 82);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (26, '08-Feb-2023', 3, 40);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (27, '13-Jul-2022', 6, 82);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (28, '24-Sep-2022', 7, 46);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (29, '07-May-2022', 1, 91);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (30, '14-Aug-2022', 7, 74);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (31, '18-Mar-2023', 5, 98);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (32, '06-Feb-2023', 3, 71);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (33, '07-Jun-2022', 4, 58);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (34, '02-Apr-2022', 6, 79);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (35, '13-Jun-2022', 7, 26);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (36, '20-Jan-2023', 3, 35);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (37, '08-Jan-2023', 1, 79);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (38, '29-Dec-2022', 3, 71);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (39, '16-Aug-2022', 1, 4);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (40, '18-Apr-2022', 1, 60);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (41, '21-Feb-2023', 3, 54);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (42, '26-Dec-2022', 4, 2);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (43, '29-Apr-2022', 7, 45);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (44, '10-Nov-2022', 4, 56);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (45, '27-Dec-2022', 6, 53);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (46, '26-Nov-2022', 2, 76);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (47, '29-Sep-2022', 7, 94);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (48, '14-Oct-2022', 5, 22);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (49, '04-Mar-2023', 2, 65);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (50, '03-Aug-2022', 6, 5);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (51, '02-May-2022', 1, 42);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (52, '30-Apr-2022', 1, 15);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (53, '05-Feb-2023', 1, 46);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (54, '15-Feb-2023', 3, 45);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (55, '16-Feb-2023', 6, 31);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (56, '06-Feb-2023', 5, 21);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (57, '29-Oct-2022', 6, 37);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (58, '10-Jun-2022', 6, 76);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (59, '03-Apr-2022', 2, 58);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (60, '19-Jun-2022', 7, 46);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (61, '22-Mar-2023', 1, 65);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (62, '08-Apr-2022', 5, 53);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (63, '27-Mar-2022', 5, 72);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (64, '16-Jan-2023', 7, 26);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (65, '08-Jun-2022', 6, 38);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (66, '25-Jan-2023', 3, 81);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (67, '06-Dec-2022', 1, 79);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (68, '24-Sep-2022', 6, 90);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (69, '03-Jun-2022', 3, 90);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (70, '09-Dec-2022', 5, 73);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (71, '19-Mar-2023', 5, 92);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (72, '20-Dec-2022', 1, 78);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (73, '22-Aug-2022', 7, 36);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (74, '27-Mar-2022', 7, 26);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (75, '07-Jun-2022', 4, 94);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (76, '20-Jul-2022', 2, 21);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (77, '27-May-2022', 4, 10);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (78, '29-Jan-2023', 5, 15);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (79, '10-Nov-2022', 7, 26);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (80, '29-Jul-2022', 7, 55);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (81, '14-Jun-2022', 2, 12);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (82, '28-Jun-2022', 5, 76);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (83, '15-Jul-2022', 2, 17);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (84, '20-Oct-2022', 3, 45);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (85, '26-Dec-2022', 2, 90);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (86, '11-May-2022', 5, 8);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (87, '22-Aug-2022', 2, 4);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (88, '30-Sep-2022', 3, 3);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (89, '30-Mar-2022', 6, 51);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (90, '23-Jul-2022', 6, 53);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (91, '04-Mar-2023', 4, 63);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (92, '10-May-2022', 1, 67);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (93, '17-Sep-2022', 6, 49);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (94, '22-Feb-2023', 4, 43);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (95, '11-Jun-2022', 3, 42);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (96, '10-Feb-2023', 1, 31);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (97, '22-Jul-2022', 2, 5);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (98, '17-Jun-2022', 3, 9);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (99, '20-Feb-2023', 5, 31);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (100, '03-Sep-2022', 2, 66);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (101, '03-Nov-2022', 1, 9);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (102, '10-Oct-2022', 3, 66);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (103, '20-Jan-2023', 4, 51);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (104, '12-Sep-2022', 6, 54);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (105, '11-Jul-2022', 1, 35);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (106, '05-Apr-2022', 1, 85);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (107, '01-Oct-2022', 3, 6);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (108, '21-Nov-2022', 6, 17);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (109, '10-Oct-2022', 3, 23);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (110, '11-Dec-2022', 5, 91);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (111, '15-Oct-2022', 6, 28);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (112, '11-Jun-2022', 2, 1);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (113, '12-Sep-2022', 5, 17);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (114, '22-Oct-2022', 2, 96);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (115, '31-Jul-2022', 5, 96);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (116, '04-Oct-2022', 5, 93);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (117, '09-Oct-2022', 2, 61);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (118, '03-Dec-2022', 6, 9);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (119, '27-Mar-2022', 6, 91);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (120, '24-Jun-2022', 4, 41);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (121, '03-Jun-2022', 2, 68);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (122, '11-Jan-2023', 5, 11);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (123, '19-Nov-2022', 7, 82);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (124, '03-Apr-2022', 6, 12);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (125, '30-Aug-2022', 6, 65);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (126, '02-Nov-2022', 6, 22);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (127, '17-Oct-2022', 2, 44);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (128, '08-Aug-2022', 2, 45);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (129, '23-Jun-2022', 3, 10);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (130, '27-Oct-2022', 2, 55);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (131, '15-Apr-2022', 4, 23);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (132, '13-Oct-2022', 2, 5);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (133, '18-Apr-2022', 5, 5);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (134, '14-Sep-2022', 1, 54);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (135, '27-May-2022', 7, 10);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (136, '22-Apr-2022', 5, 32);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (137, '17-Apr-2022', 2, 14);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (138, '08-Nov-2022', 3, 15);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (139, '18-Aug-2022', 3, 18);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (140, '15-Nov-2022', 3, 61);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (141, '03-Dec-2022', 6, 31);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (142, '13-Nov-2022', 6, 64);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (143, '07-Apr-2022', 3, 72);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (144, '20-Oct-2022', 5, 46);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (145, '01-Sep-2022', 3, 20);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (146, '29-Nov-2022', 3, 36);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (147, '11-Apr-2022', 2, 55);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (148, '01-Jan-2023', 1, 31);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (149, '19-Feb-2023', 4, 59);
insert into customer_order (Order_ID, Order_date, Payment_type_ID, CustomerID) values (150, '11-Mar-2023', 2, 84);


insert into order_details (Order_details_ID, Product_ID, Order_ID) values (1, 31, 2);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (2, 36, 127);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (3, 47, 136);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (4, 22, 101);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (5, 50, 74);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (6, 22, 33);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (7, 4, 26);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (8, 47, 21);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (9, 43, 144);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (10, 3, 11);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (11, 49, 97);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (12, 41, 85);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (13, 50, 118);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (14, 34, 125);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (15, 23, 9);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (16, 36, 91);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (17, 7, 84);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (18, 11, 42);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (19, 49, 149);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (20, 48, 31);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (21, 29, 131);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (22, 23, 13);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (23, 22, 28);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (24, 41, 20);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (25, 25, 3);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (26, 1, 117);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (27, 39, 75);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (28, 42, 139);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (29, 45, 43);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (30, 45, 3);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (31, 17, 94);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (32, 38, 3);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (33, 22, 46);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (34, 14, 4);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (35, 27, 23);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (36, 30, 77);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (37, 39, 21);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (38, 5, 5);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (39, 49, 75);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (40, 38, 104);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (41, 46, 100);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (42, 24, 59);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (43, 13, 140);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (44, 26, 41);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (45, 15, 104);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (46, 30, 137);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (47, 39, 121);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (48, 7, 15);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (49, 11, 20);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (50, 1, 83);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (51, 12, 48);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (52, 48, 76);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (53, 13, 39);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (54, 13, 70);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (55, 21, 39);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (56, 9, 38);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (57, 28, 99);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (58, 47, 22);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (59, 7, 83);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (60, 35, 22);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (61, 43, 69);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (62, 21, 107);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (63, 43, 37);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (64, 20, 131);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (65, 23, 65);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (66, 12, 85);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (67, 48, 20);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (68, 42, 134);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (69, 32, 1);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (70, 15, 14);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (71, 21, 122);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (72, 27, 135);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (73, 43, 124);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (74, 46, 61);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (75, 36, 14);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (76, 17, 4);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (77, 8, 11);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (78, 27, 46);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (79, 18, 2);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (80, 36, 131);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (81, 48, 71);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (82, 5, 64);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (83, 30, 51);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (84, 29, 81);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (85, 1, 46);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (86, 36, 43);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (87, 2, 92);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (88, 13, 131);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (89, 18, 17);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (90, 25, 135);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (91, 3, 44);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (92, 12, 68);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (93, 37, 117);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (94, 18, 72);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (95, 38, 148);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (96, 11, 3);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (97, 20, 74);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (98, 38, 74);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (99, 8, 97);
insert into order_details (Order_details_ID, Product_ID, Order_ID) values (100, 19, 146);


insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (1, 'Benton Hurdedge', '2914802627', 'bhurdedge0@globo.com');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (2, 'Yevette Tremblet', '5629934033', 'ytremblet1@skyrock.com');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (3, 'Martyn Summerlie', '8806861058', 'msummerlie2@wunderground.com');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (4, 'Tirrell Annwyl', '6252777929', 'tannwyl3@washington.edu');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (5, 'Laryssa Hassell', '7492449872', 'lhassell4@chicagotribune.com');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (6, 'Star Durtnel', '9432148907', 'sdurtnel5@nyu.edu');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (7, 'Panchito Stolze', '4553461210', 'pstolze6@comcast.net');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (8, 'Phyllys Lempenny', '4882402681', 'plempenny7@plala.or.jp');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (9, 'Kamilah Bullent', '6448883809', 'kbullent8@usgs.gov');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (10, 'Delmar Hinsche', '4395142702', 'dhinsche9@mtv.com');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (11, 'Mitzi Redmille', '9239928898', 'mredmillea@illinois.edu');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (12, 'Noemi Aleswell', '3323132147', 'naleswellb@comcast.net');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (13, 'Westbrook Wathall', '9178412151', 'wwathallc@marketwatch.com');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (14, 'Hermon Steere', '8553042354', 'hsteered@a8.net');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (15, 'Durand Alexsandrev', '7143038957', 'dalexsandreve@howstuffworks.com');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (16, 'Doroteya Plank', '4094344369', 'dplankf@google.ca');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (17, 'Karlan Gothup', '7106212990', 'kgothupg@simplemachines.org');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (18, 'Modesta D''Avaux', '6759934645', 'mdavauxh@reuters.com');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (19, 'Denis Mingaye', '6049811300', 'dmingayei@drupal.org');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (20, 'Renie Baumert', '1814811972', 'rbaumertj@tripod.com');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (21, 'Chic Perrins', '2429696730', 'cperrinsk@nymag.com');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (22, 'Cindy O''Geaney', '3522130005', 'cogeaneyl@un.org');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (23, 'Griselda Colloby', '3744468222', 'gcollobym@feedburner.com');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (24, 'Deeanne Hemeret', '2023842831', 'dhemeretn@nasa.gov');
insert into delivery_partner (Delivery_partner_ID, Delivery_partner_Name, Delivery_partner_PhoneNo, Deliver_partner_Email) values (25, 'Cointon Grubey', '7205991546', 'cgrubeyo@accuweather.com');


insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (1, 'Order Received', 36, 22);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (2, 'Order processing', 145, 8);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (3, 'Order Received', 25, 17);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (4, 'Order Shipped', 72, 22);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (5, 'Order Received', 17, 15);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (6, 'Order Delivered', 117, 22);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (7, 'Order Shipped', 142, 22);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (8, 'Order processing', 36, 15);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (9, 'Order Delivered', 68, 18);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (10, 'Order Received', 135, 11);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (11, 'Order Received', 16, 10);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (12, 'Order Received', 9, 4);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (13, 'Order Received', 49, 5);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (14, 'Order Received', 21, 15);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (15, 'Order processing', 1, 21);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (16, 'Order Received', 41, 14);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (17, 'Order Received', 146, 24);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (18, 'Order Delivered', 23, 11);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (19, 'Order Shipped', 7, 13);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (20, 'Order processing', 14, 24);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (21, 'Order Received', 72, 21);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (22, 'Order Delivered', 56, 8);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (23, 'Order processing', 117, 17);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (24, 'Order Received', 8, 6);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (25, 'Order processing', 143, 5);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (26, 'Order processing', 91, 16);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (27, 'Order processing', 100, 25);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (28, 'Order Delivered', 55, 15);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (29, 'Order Received', 150, 12);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (30, 'Order processing', 60, 25);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (31, 'Order Shipped', 145, 25);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (32, 'Order Shipped', 45, 20);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (33, 'Order Delivered', 49, 4);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (34, 'Order processing', 62, 17);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (35, 'Order processing', 145, 11);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (36, 'Order Received', 73, 7);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (37, 'Order Shipped', 90, 23);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (38, 'Order Delivered', 128, 2);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (39, 'Order processing', 18, 18);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (40, 'Order processing', 119, 10);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (41, 'Order Received', 51, 1);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (42, 'Order Received', 4, 14);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (43, 'Order Delivered', 66, 21);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (44, 'Order processing', 38, 5);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (45, 'Order Shipped', 18, 3);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (46, 'Order processing', 96, 11);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (47, 'Order Received', 51, 21);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (48, 'Order Delivered', 34, 7);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (49, 'Order Shipped', 17, 18);
insert into order_delivery_status (Order_delivery_status_ID, Order_delivery_status_Name, Order_ID, Delivery_partner_ID) values (50, 'Order Received', 71, 4);


-- CUSTOMER INFORMATION VIEW

drop view customer_info;

CREATE VIEW customer_info AS
SELECT Customer_FirstName, Customer_LastName, Customer_Email
FROM customer;

--select * from customer_info;

-- CUSTOMER DETAILS WITH TOTAL COST

drop view customer_order_details;

CREATE VIEW customer_order_details AS
SELECT distinct(o.Order_ID), p.Product_name, p.Product_quantity, p.Product_cost, p.Product_quantity * p.Product_cost as total_cost
FROM customer_order o
JOIN order_details od ON o.Order_ID = od.Order_ID
JOIN product p ON od.Product_ID = p.Product_ID;

--select * from customer_order_details order by order_id;

-- TOTAL SALES BY PRODUCT TYPE
drop view product_type_sales;


CREATE VIEW product_type_sales AS
SELECT pt.Product_type_name, SUM(p.Product_cost * p.Product_quantity) AS Total_Sales
FROM product_type pt
JOIN product p ON pt.Product_type_ID = p.Product_type_ID
JOIN order_details od ON p.Product_ID = od.Product_ID
GROUP BY pt.Product_type_name;

--select * from product_type_sales;


-- PRODUCT INVENTORY QUANTITY STATUS
drop view product_inventory;

CREATE VIEW product_inventory AS
SELECT p.Product_name, d.Product_Quantity
FROM distributor d
JOIN product p ON d.Product_ID = p.Product_ID;

--select * from product_inventory;

-- CUSTOMERS WITHOUT ANY ORDER
 
drop view customers_without_orders;

CREATE VIEW customers_without_orders AS
SELECT c.CustomerID, c.Customer_FirstName, c.Customer_LastName
FROM customer c
WHERE NOT EXISTS (SELECT * FROM customer_order o WHERE o.CustomerID = c.CustomerID);

--select * from customers_without_orders;


-- DELIVERY STATUS OF EACH ORDER SORT BY ORDER ID
drop view order_delivery_info;

CREATE VIEW order_delivery_info AS
SELECT o.Order_ID, s.Order_delivery_status_Name, dp.Delivery_partner_Name
FROM customer_order o
JOIN order_delivery_status s ON o.Order_ID = s.Order_ID
JOIN delivery_partner dp ON s.Delivery_partner_ID = dp.Delivery_partner_ID;

--select * from order_delivery_info order by order_id;

--TOTAL INDIVIDUAL SALES BY AN CUSTOMER

drop view customer_sales;

CREATE VIEW customer_sales AS
SELECT c.CustomerID, c.Customer_FirstName, c.Customer_LastName, SUM(p.Product_cost * p.Product_quantity) AS Total_Sales
FROM customer c
JOIN customer_order o ON c.CustomerID = o.CustomerID
JOIN order_details od ON o.Order_ID = od.Order_ID
JOIN product p ON od.Product_ID = p.Product_ID
GROUP BY c.CustomerID, c.Customer_FirstName, c.Customer_LastName;

--select * from customer_sales order by customerid;

-- FULL ORDER DETAILS WITH DELIVERY STATUS , PRODUCT, PRODUCT COST
drop view a;

CREATE VIEW a AS 
SELECT o.Order_ID, o.Order_date, c.Customer_FirstName, c.Customer_LastName, p.Product_name, p.Product_cost, od.Order_details_ID, 
       os.Order_delivery_status_Name, dp.Delivery_partner_Name, dp.Delivery_partner_PhoneNo
FROM customer_order o
JOIN customer c ON c.CustomerID = o.CustomerID
JOIN order_details od ON od.Order_ID = o.Order_ID
JOIN product p ON p.Product_ID = od.Product_ID
LEFT JOIN order_delivery_status ods ON ods.Order_ID = o.Order_ID
LEFT JOIN delivery_partner dp ON dp.Delivery_partner_ID = ods.Delivery_partner_ID
LEFT JOIN order_delivery_status os ON os.Order_delivery_status_ID = ods.Order_delivery_status_ID;

--select * from a order by order_id;

-- MONTHLY SALES WITH AVERAGE ORDER VALUE

drop view monthly_sales;


CREATE VIEW monthly_sales AS
SELECT TO_CHAR(o.Order_date, 'YYYY-MM') AS Month, 
       SUM(p.Product_cost * p.Product_Quantity) AS Total_Sales, 
       round(AVG(p.Product_cost * p.Product_Quantity), 2) AS Avg_Order_Value
FROM customer_order o
JOIN order_details od ON od.Order_ID = o.Order_ID
JOIN product p ON p.Product_ID = od.Product_ID
GROUP BY TO_CHAR(o.Order_date, 'YYYY-MM');

--select * from monthly_sales;

 commit;


--select * from USER_TABLES;




















