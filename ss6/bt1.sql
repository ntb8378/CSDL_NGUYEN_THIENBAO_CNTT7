-- code cũ:
SELECT city, SUM(total_price) AS revenue
FROM Bookings
WHERE status = 'COMPLETED' AND SUM(total_price) > 0
GROUP BY city;

-- sửa
SELECT city, SUM(total_price) AS revenue
FROM Bookings
WHERE status = 'COMPLETED' 
GROUP BY city
having SUM(total_price) > 0;

-- không thể đặt Sum ở trong where được , phải đặt trong hàm having bởi vì having là lọc dữ liệu sau khi nhóm 