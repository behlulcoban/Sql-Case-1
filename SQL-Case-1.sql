-- Soru 1: Customers isimli bir veritabanı ve verilen veri setindeki değişkenleri içerecek FLO isimli bir tablo oluşturunuz.
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

Select Count(order_num_total_ever_online + order_num_total_ever_offline) ToplamSiparisSayisi,
round(sum(customer_value_total_ever_offline + customer_value_total_ever_online),2) ToplamCiro
from FLO

--Soru 4: Alışveriş başına ortalama ciroyu getirecek sorguyu yazınız.

select round(sum(customer_value_total_ever_offline + customer_value_total_ever_online) / sum(order_num_total_ever_online + order_num_total_ever_offline) ,2) OrtalamaCiro
from FLO

-- Soru 5: En son alışveriş yapılan kanal (last_order_channel) üzerinden yapılan alışverişlerin toplam ciro ve alışveriş sayılarını getirecek sorguyu yazınız.

Select last_order_channel,  
sum(customer_value_total_ever_offline + customer_value_total_ever_online) ToplamCiro,
sum(order_num_total_ever_online + order_num_total_ever_offline) ToplamSiparisSayisi
from FLO
group by last_order_channel

--Soru 6: Store type kırılımında elde edilen toplam ciroyu getiren sorguyu yazınız.

Select store_type,
sum(customer_value_total_ever_offline + customer_value_total_ever_online) ToplamCiro
from FLO
group by store_type

--Soru 7: Yıl kırılımında alışveriş sayılarını getirecek sorguyu yazınız (Yıl olarak müşterinin ilk alışveriş tarihi (first_order_date) yılını baz alınız.

Select year(first_order_date) IlkAlisveris,
count(order_num_total_ever_online + order_num_total_ever_offline) ToplamSiparis
from FLO
group by year(first_order_date)
order by 1 desc

--Soru 8: En son alışveriş yapılan kanal kırılımında alışveriş başına ortalama ciroyu hesaplayacak sorguyu yazınız. 

Select last_order_channel SonAlisveris, 
round(sum(customer_value_total_ever_offline + customer_value_total_ever_online),2) ToplamCiro,
sum(order_num_total_ever_online + order_num_total_ever_offline) ToplamSiparis,
round(sum(customer_value_total_ever_offline + customer_value_total_ever_online) / sum(order_num_total_ever_online + order_num_total_ever_offline) ,2) OrtalamaCiro
from FLO
group by last_order_channel

--Soru 9: Son 12 ayda en çok ilgi gören kategoriyi getiren sorguyu yazınız.

select interested_in_categories_12,
count(*) FrekansBilgisi
from FLO
group by interested_in_categories_12
order by 2 desc

--Soru 10:En çok tercih edilen store_type bilgisini getiren sorguyu yazınız. 

Select top 1 store_type,
count(*) FrekansBilgisi
from FLO
group by store_type
order by 2 desc

-- Soru 11: En son alışveriş yapılan kanal (last_order_channel) bazında, en çok ilgi gören kategoriyi ve bu kategoriden ne kadarlık alışveriş yapıldığını getiren sorguyu yazınız.

Select distinct last_order_channel,
(Select top 1 interested_in_categories_12 from FLO
where last_order_channel=f.last_order_channel
group by interested_in_categories_12
order by sum(order_num_total_ever_online + order_num_total_ever_offline) desc 
)  Kategori,
(Select top 1 
sum(order_num_total_ever_online + order_num_total_ever_offline)
from FLO
where last_order_channel = f.last_order_channel
group by interested_in_categories_12
order by Sum(order_num_total_ever_online + order_num_total_ever_offline) desc) AlisverisSayisi
from FLO f

--Soru 12: En çok alışveriş yapan kişinin ID’ sini getiren sorguyu yazınız.

Select top 1 master_id,
sum(order_num_total_ever_online + order_num_total_ever_offline) ToplamAlisveris

from FLO
group by master_id
order by sum(order_num_total_ever_online + order_num_total_ever_offline) desc

--Soru 13: En çok alışveriş yapan kişinin alışveriş başına ortalama cirosunu ve alışveriş yapma gün ortalamasını (alışveriş sıklığını) getiren sorguyu yazınız. 

Select *, 
round((d.ToplamCiro / d.ToplamSiparisSayisi),2) SiparisBasinaOrtalama
from 
(
Select top 1 master_id,
sum(customer_value_total_ever_offline + customer_value_total_ever_online) ToplamCiro,
sum(order_num_total_ever_online + order_num_total_ever_offline) ToplamSiparisSayisi
from CUSTOMERS.dbo.FLO 
group by master_id
order by ToplamCiro desc
) d

--Soru 14:  En çok alışveriş yapan (ciro bazında) ilk 100 kişinin alışveriş yapma gün ortalamasını (alışveriş sıklığını) getiren sorguyu yazınız. 

Select 
d.master_id, d.ToplamCiro, d.ToplamSiparisSayisi,
round((d.ToplamCiro / d.ToplamSiparisSayisi),2) SiparisBasinaOrtalama,
DATEDIFF(day, first_order_date,last_order_date) IlkSonAlisverisGunFark,
round((DATEDIFF(day, first_order_date,last_order_date) / d.ToplamSiparisSayisi), 1) AlisverisOrtalama
from (
Select top 100
master_id,
first_order_date,
last_order_date,
sum(customer_value_total_ever_offline + customer_value_total_ever_online) ToplamCiro,
sum(order_num_total_ever_online + order_num_total_ever_offline) ToplamSiparisSayisi
from FLO 
group by master_id, first_order_date, last_order_date
order by ToplamCiro desc
) d

--Soru 15: En son alışveriş yapılan kanal (last_order_channel) kırılımında en çok alışveriş yapan müşteriyi getiren sorguyu yazınız. 

select distinct last_order_channel,
(Select top 1 master_id
from FLO where last_order_channel = f.last_order_channel
group by master_id
order by sum(customer_value_total_ever_offline + customer_value_total_ever_online) desc
) EnCokAlisverisYapanMusteri,
(Select top 1 
sum(customer_value_total_ever_offline + customer_value_total_ever_online)
from FLO where last_order_channel = f.last_order_channel
group by master_id
order by sum(customer_value_total_ever_offline + customer_value_total_ever_online) desc
) Ciro

from FLO f

--Soru 16: En son alışveriş yapan kişinin ID’ sini getiren sorguyu yazınız. (Max son tarihte birden fazla alışveriş yapan ID bulunmakta. Bunları da getiriniz.)

Select master_id, last_order_date 
from FLO
where 
last_order_date = (Select Max(last_order_date)
from FLO)
