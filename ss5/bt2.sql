-- code cũ
SELECT restaurant_name, created_at
FROM Restaurants
LIMIT 5;
-- code mới
SELECT restaurant_name, created_at
FROM Restaurants
order by created_at desc
LIMIT 5;
-- oder by dùng để sắp xếp dữ liệu cần truy vấn , ví dụ như code em vừa làm , oder by + tên của dữ liệu muốn sắp xếp + desc là sắp xếp thứ tự giảm dần , từ mới xuống cũ nên nó sẽ lấy và hiển thị 5 cái mới nhất
