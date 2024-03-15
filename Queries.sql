--1.Product isimlerini (`ProductName`) ve birim başına miktar (`QuantityPerUnit`) değerlerini almak için sorgu yazın.
SELECT product_name,quantity_per_unit FROM products;

--2.Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) değerlerini almak için sorgu yazın. Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.
SELECT product_id,product_name FROM products
WHERE Discontinued=1;

--3.Durdurulmayan (`Discontinued`) Ürün Listesini, Ürün kimliği ve ismi (`ProductID`, `ProductName`) değerleriyle almak için bir sorgu yazın.
SELECT product_id,product_name FROM products
WHERE Discontinued=0;

--4.Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
SELECT product_id,product_name,unit_price FROM products
WHERE unit_price<20;

--5.Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
SELECT product_id,product_name,unit_price FROM products
WHERE unit_price BETWEEN 15 AND 25;

--6.Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.
SELECT product_name,units_on_order,units_in_stock FROM products
WHERE units_in_stock<units_on_order;

--7.İsmi `a` ile başlayan ürünleri listeleyeniz.
SELECT * FROM products
WHERE product_name ILIKE 'a%';

--8.İsmi `i` ile biten ürünleri listeleyeniz.
SELECT * FROM products
WHERE product_name LIKE '%i';

--9.Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak (ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.
SELECT product_name,unit_price, (unit_price*1.18) AS unit_price_kdv FROM products;

--10.Fiyatı 30 dan büyük kaç ürün var?
SELECT COUNT (*) AS product_count FROM products
WHERE unit_price>30;

--11.Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele.
SELECT LOWER(product_name) AS product_name,unit_price FROM products
ORDER BY unit_price DESC;

--12.Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır.
SELECT CONCAT(first_name,' ',last_name) AS employee_name FROM employees;

--13.Region alanı NULL olan kaç tedarikçim var?
SELECT COUNT (*) AS null_region_suppliers FROM suppliers
WHERE region IS NULL;

--14.Region alanı NULL olmayan kaç tedarikçim var?
SELECT COUNT (*) AS not_null_region_suppliers FROM suppliers
WHERE region IS NOT NULL;

--15.Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.
SELECT UPPER(CONCAT('TR ',product_name)) AS new_product_name FROM products;

--16.Fiyatı 20den küçük ürünlerin adının başına TR ekle.
SELECT CONCAT('TR ',product_name) AS new_product_name FROM products
WHERE unit_price<20;

--17.En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name,unit_price FROM products
ORDER BY unit_price DESC LIMIT 1;

--18.En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name,unit_price FROM products
ORDER BY unit_price DESC LIMIT 10;

--19.Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name,unit_price FROM products
WHERE unit_price > (SELECT AVG(unit_price) FROM products);

--20.Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.
SELECT SUM(unit_price*units_in_stock) AS total_amount FROM products
WHERE units_in_stock !=0;

--21.Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
SELECT COUNT(*) FILTER (WHERE discontinued = 0) AS active_products,
COUNT(*) FILTER (WHERE discontinued = 1) AS discontinued_products FROM products;

--22.Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.
SELECT p.product_name,c.category_name FROM products AS p
INNER JOIN categories AS c ON p.category_id = c.category_id;

--23.Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.
SELECT c.category_name, AVG(unit_price) AS average_price FROM categories as c
INNER JOIN products AS p ON p.category_id = c.category_id
GROUP BY category_name;

--24.En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?
SELECT p.product_name,p.unit_price,c.category_name FROM products AS p
INNER JOIN categories AS c ON p.category_id = c.category_id
ORDER BY unit_price DESC LIMIT 1;

--25.En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı nedir?
SELECT p.product_name,c.category_name,s.company_name,SUM(quantity) AS total_purchased_quantity FROM products AS p
INNER JOIN order_details AS od ON od.product_id = p.product_id
INNER JOIN categories AS c ON p.category_id = c.category_id
INNER JOIN suppliers AS s ON p.supplier_id = s.supplier_id
GROUP BY p.product_name,c.category_name,s.company_name
ORDER BY total_purchased_quantity DESC LIMIT 1;

--26.Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını(`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
SELECT p.product_id,p.product_name,s.company_name,s.phone FROM products AS p
INNER JOIN suppliers AS s ON s.supplier_id = p.supplier_id
WHERE units_in_stock = 0;

--27.1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
SELECT o.ship_address,e.first_name,e.last_name FROM employees AS e
INNER JOIN orders AS o ON e.employee_id = o.employee_id
WHERE to_char(order_date,'YYYY-MM') = '1998-03';

--28.1997 yılı şubat ayında kaç siparişim var?
SELECT COUNT(*) AS total_orders FROM orders
WHERE to_char(order_date,'YYYY-MM') = '1997-02';

--29.London şehrinden 1998 yılında kaç siparişim var?
SELECT COUNT(*) AS total_orders FROM orders
WHERE ship_city = 'London' AND to_char(order_date,'YYYY') = '1998';

--30.1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
SELECT DISTINCT c.contact_name,c.phone FROM orders AS o
INNER JOIN customers AS c ON c.customer_id = o.customer_id
WHERE to_char(order_date,'YYYY') = '1997';

--31. Taşıma ücreti 40 üzeri olan siparişlerim
SELECT * FROM orders
WHERE freight >40;

--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
SELECT o.ship_city,c.contact_name FROM orders AS o
INNER JOIN customers AS c ON c.customer_id = o.customer_id
WHERE freight >40;

--33.1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf)
SELECT o.order_date,o.ship_city,UPPER(CONCAT(e.first_name,' ',e.last_name)) AS employee_name FROM orders AS o
INNER JOIN employees AS e ON o.employee_id = e.employee_id
WHERE to_char(order_date,'YYYY') = '1997';

--34.1997 yılında sipariş veren müşterilerin contactname ve telefon numaraları(telefon formatı 2223322 gibi olmalı)
SELECT DISTINCT c.contact_name,regexp_replace(c.phone, '\D', '', 'g') AS formatted_phone FROM orders AS o
INNER JOIN customers AS c ON c.customer_id = o.customer_id
WHERE to_char(order_date,'YYYY') = '1997'; 

--35.Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
SELECT o.order_date,c.contact_name,e.first_name,e.last_name FROM orders AS o
INNER JOIN employees AS e ON e.employee_id = o.employee_id
INNER JOIN customers AS c ON c.customer_id = o.customer_id;

--36.Geciken siparişlerim?
SELECT * FROM orders
WHERE shipped_date > required_date;

--37.Geciken siparişlerimin tarihi, müşterisinin adı
SELECT order_date,contact_name FROM orders AS o
INNER JOIN customers AS c ON c.customer_id = o.customer_id
WHERE shipped_date > required_date;

--38.10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
SELECT p.product_name,c.category_name,od.quantity FROM products AS p
INNER JOIN categories AS c ON c.category_id = p.category_id
INNER JOIN order_details AS od ON od.product_id = p.product_id
WHERE order_id = 10248;

--39.10248 nolu siparişin ürünlerinin adı , tedarikçi adı
SELECT p.product_name,s.company_name FROM products AS p
INNER JOIN suppliers AS s ON s.supplier_id = p.supplier_id
INNER JOIN order_details AS od ON od.product_id = p.product_id
WHERE od.order_id = 10248;

--40.3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT p.product_name,SUM(od.quantity) AS total_quantity FROM employees e
INNER JOIN orders o ON e.employee_id = o.employee_id
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN products p ON od.product_id = p.product_id
WHERE e.employee_id = 3 AND to_char(order_date,'YYYY') = '1997'
GROUP BY p.product_name;

--41.1997 yılında bir defasında en çok satış yapan çalışanımın ID,Ad soyad
SELECT DISTINCT e.employee_id,e.first_name,e.last_name,od.quantity AS total FROM employees AS e
INNER JOIN orders AS o ON o.employee_id = e.employee_id
INNER JOIN order_details AS od ON o.order_id = od.order_id
WHERE to_char(order_date,'YYYY') = '1997'
ORDER BY total DESC LIMIT 1;

--42.1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT DISTINCT e.employee_id,e.first_name,e.last_name,SUM(od.quantity) AS total FROM employees AS e
INNER JOIN orders AS o ON o.employee_id = e.employee_id
INNER JOIN order_details AS od ON o.order_id = od.order_id
WHERE to_char(order_date,'YYYY') = '1997'
GROUP BY e.employee_id,e.first_name,e.last_name
ORDER BY total DESC LIMIT 1;

--43.En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT p.product_name,p.unit_price,c.category_name FROM products AS p
INNER JOIN categories AS c ON p.category_id = c.category_id
ORDER BY unit_price DESC LIMIT 1;

--44.Siparişi alan personelin adı,soyadı,sipariş tarihi,sipariş ID.Sıralama sipariş tarihine göre
SELECT first_name,last_name,order_date,order_id FROM employees AS e
INNER JOIN orders AS o ON o.employee_id = e.employee_id
ORDER BY order_date;

--45.Son 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT AVG(od.unit_price) AS AVG,o.order_id FROM order_details AS od
INNER JOIN orders AS o ON od.order_id = o.order_id
GROUP BY o.order_id
ORDER BY o.order_date DESC LIMIT 5;

--46.Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT p.product_name,c.category_name,SUM(od.quantity*od.unit_price) FROM products AS p
INNER JOIN categories AS c ON p.category_id = c.category_id
INNER JOIN order_details AS od ON od.product_id = p.product_id
GROUP BY p.product_name,c.category_name;

--47.Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT * FROM order_details
WHERE quantity > (SELECT AVG(quantity) FROM order_details);

--48.En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
SELECT p.product_name,c.category_name,s.company_name FROM products AS p
INNER JOIN categories AS c ON p.category_id = c.category_id
INNER JOIN suppliers AS s ON s.supplier_id = p.supplier_id
INNER JOIN order_details AS od ON p.product_id = od.product_id
ORDER BY od.quantity DESC LIMIT 1;

--49.Kaç ülkeden müşterim var
SELECT COUNT(country) AS number_of_countries FROM customers;

--50.3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
SELECT SUM(od.unit_price * quantity) FROM order_details AS od
INNER JOIN orders AS o ON od.order_id = o.order_id
WHERE o.employee_id=3 and o.order_date BETWEEN '1998-01-01' AND current_date;

--51.Hangi ülkeden kaç müşterimiz var
SELECT country,COUNT(company_name) FROM customers
GROUP BY country;

--52.10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
SELECT SUM(od.unit_price * od.quantity) AS revenue FROM orders AS o
INNER JOIN order_details AS od ON o.order_id = od.order_id
WHERE product_id = 10
AND o.order_date >= (SELECT DATE_TRUNC('MONTH', MAX(order_date) - INTERVAL '3 MONTHS') FROM orders)
AND o.order_date <= (SELECT DATE_TRUNC('MONTH', MAX(order_date)) FROM orders);

--53.Hangi çalışan şimdiye kadar toplam kaç sipariş almış?
SELECT CONCAT(e.first_name,' ',e.last_name) AS employee_name,COUNT(*)FROM orders AS o
INNER JOIN employees AS e ON o.employee_id = e.employee_id
GROUP BY e.employee_id;

--54.91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
SELECT * FROM customers AS c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id ISNULL;

--55.Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
SELECT company_name,contact_name,address,city,country FROM customers
WHERE country = 'Brazil';

--56.Brezilya’da olmayan müşteriler
SELECT company_name,contact_name,address,city,country FROM customers
WHERE country != 'Brazil';

--57.Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT * FROM customers
WHERE country IN ('Spain','France','Germany');

--58.Faks numarasını bilmediğim müşteriler
SELECT * FROM customers
WHERE fax ISNULL;

--59.Londra’da ya da Paris’de bulunan müşterilerim
SELECT * FROM customers
WHERE city IN ('London','Paris');

--60.Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
SELECT * FROM customers
WHERE city = 'México D.F.' AND contact_title = 'Owner';

--61.C ile başlayan ürünlerimin isimleri ve fiyatları
SELECT product_name,unit_price FROM products
WHERE product_name ILIKE 'c%';

--62.Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
SELECT first_name,last_name,birth_date FROM employees
WHERE first_name ILIKE 'a%';

--63.İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
SELECT company_name FROM customers
WHERE company_name ILIKE '%restaurant%';

--64.50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
SELECT product_name,unit_price FROM products
WHERE unit_price BETWEEN 50 AND 100;

--65.1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
SELECT order_id,order_date FROM orders
WHERE order_date BETWEEN '1996-07-01' AND '1996-12-31';

--66.Müşterilerimi ülkeye göre sırala
SELECT * FROM customers
ORDER BY country;

--67.Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
SELECT product_name,unit_price FROM products
ORDER BY unit_price DESC;

--68.Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
SELECT product_name, unit_price, units_in_stock FROM products 
ORDER BY unit_price DESC, units_in_stock ASC;

--69.1 Numaralı kategoride kaç ürün vardır?
SELECT c.category_id,c.category_name,COUNT(p.product_id) FROM products AS p
INNER JOIN categories AS c ON p.category_id = c.category_id
GROUP BY c.category_id 
HAVING c.category_id = 1;

--70.Kaç farklı ülkeye ihracat yapıyorum?
SELECT COUNT(DISTINCT(ship_country)) AS exported_countries FROM orders;

--71.Bu ülkeler hangileri?
SELECT DISTINCT ship_country FROM orders;

--72.En Pahalı 5 ürün
SELECT * FROM products
ORDER BY unit_price DESC LIMIT 5;

--73.ALFKI CustomerID’sine sahip müşterimin sipariş sayısı?
SELECT COUNT(order_id) FROM orders
WHERE customer_id = 'ALFKI';

--74.Ürünlerimin toplam maliyeti
SELECT SUM(quantity * unit_price) AS total_cost FROM order_details;

--75.Şirketim, şimdiye kadar ne kadar ciro yapmış?
SELECT SUM(unit_price*quantity*(1-discount)) AS total_revenue FROM order_details;

--76.Ortalama Ürün Fiyatım
SELECT AVG(unit_price) AS avg_product_price FROM Products;

--77.En Pahalı Ürünün Adı
SELECT product_name FROM products
ORDER BY unit_price DESC LIMIT 1;

--78.En az kazandıran sipariş
SELECT SUM(unit_price*quantity*(1-discount)) FROM order_details
GROUP BY order_id
ORDER BY SUM(unit_price*quantity*(1-discount)) ASC LIMIT 1;

--79.Müşterilerimin içinde en uzun isimli müşteri
SELECT contact_name FROM customers
ORDER BY LENGTH(contact_name) DESC LIMIT 1;

--80.Çalışanlarımın Ad, Soyad ve Yaşları nedir ?
SELECT first_name||' '||last_name AS employee_name,birth_date FROM employees;

--81.Hangi üründen toplam kaç adet alınmış ?
SELECT p.product_name, SUM(od.quantity) AS total_products_sold FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name;

--82.Hangi siparişte toplam ne kadar kazanmışım ?
SELECT order_id,SUM(unit_price*quantity*(1-discount)) FROM order_details
GROUP BY order_id
ORDER BY order_id;

--83.Hangi kategoride toplam kaç adet ürün bulunuyor ?
SELECT category_id,SUM(units_in_stock) FROM products
GROUP BY category_id
ORDER BY category_id;

--84.1000 Adetten fazla satılan ürünler hangileridir ?
SELECT p.product_name,SUM(od.quantity) FROM order_details AS od
INNER JOIN products AS p ON p.product_id = od.product_id
GROUP BY p.product_id
HAVING SUM(od.quantity) > 1000
ORDER BY p.product_id;