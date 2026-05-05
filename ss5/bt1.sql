-- code ban đầu
SELECT restaurant_name, address, rating
FROM Restaurants
WHERE district = 'Quận 1' OR district = 'Quận 3' AND rating > 4.0;

-- sửa
SELECT restaurant_name, address, rating
FROM Restaurants
WHERE (district = 'Quận 1' OR district = 'Quận 3' )
AND rating > 4.0;

-- vì khi ghi WHERE district = 'Quận 1' OR district = 'Quận 3' AND rating > 4.0; chưa đủ chi tiết và rõ ràng điều kiện , phải cho vào ngoặc để vừa lấy ra QUẬN 1 , vừa lấy ra QUẬN 3 và đồng thời khỏa điều kiện là rating > 4 
-- ghi như ban đầu nó sẽ tách ra và chỉ lấy rating >4 cho QUẬN 3 thôi , còn QUẬN 1 thì nó k sét điều kiện rating nên có thể sẽ lẫn vào những đánh giá rất tệ (rating 2.0 - 3.0) gây phẫn nộ cho khách hàng VIP.