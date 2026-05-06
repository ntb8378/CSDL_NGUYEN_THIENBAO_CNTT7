-- code cũ
SELECT hotel_id, room_name, MIN(price_per_night)
FROM Rooms
GROUP BY hotel_id;
-- sửa
SELECT hotel_id, MIN(price_per_night) AS minPrice 
FROM Rooms
GROUP BY hotel_id;

-- bởi vì group by là gom nhóm id khách sạn , trong đó có nhiều phòng , không thể chèn thêm room name vào được , bởi vì ở trong khách sạn nó sẽ có nhiều phòng , và thiếu phần bí danh 
