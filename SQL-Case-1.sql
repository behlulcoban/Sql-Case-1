﻿-- Soru 1: Customers isimli bir veritabanı ve verilen veri setindeki değişkenleri içerecek FLO isimli bir tablo oluşturunuz.
Create Database CUSTOMERS

Create table FLO(
master_id nvarchar(50) primary key,
order_channel nvarchar(50),
last_order_channel nvarchar(50),
first_order_date date,
last_order_date date,
last_order_date_online date,
last_order_date_offline date,
order_num_total_ever_online float,
order_num_total_ever_offline float,
customer_value_total_ever_offline float,
customer_value_total_ever_online float,
interested_in_categories_12 nvarchar(50),
store_type nvarchar(50)
)

-- Soru 2: Kaç farklı müşterinin alışveriş yaptığını gösterecek sorguyu yazınız. 

Select count(distinct master_id) ToplamMusteri from FLO

-- Soru 3: Toplam yapılan alışveriş sayısı ve ciroyu getirecek sorguyu yazınız.