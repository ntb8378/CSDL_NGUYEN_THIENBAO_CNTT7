-- =========================================
-- BÀI: DRIVER MATCHING - GÁN ĐƠN TỰ ĐỘNG
-- =========================================

-- ===== 1. I/O =====
-- Input:
--  + order_id
--  + restaurant_location
--  + min_trust_score (từ config)

-- Output:
--  + Danh sách driver:
--      driver_id, status, trust_score, distance_km
--  + Đã lọc và sắp xếp theo ưu tiên

-- ===== 2. BACKEND LOGIC (if/else - mô tả) =====
-- Lấy min_trust_score từ config

-- if (min_trust_score IS NULL) then
--     set = 80
-- else if (min_trust_score < 0) then
--     set = 0     -- chặn bẫy âm (tránh lọc sai)
-- else if (min_trust_score > 100) then
--     set = 100
-- else
--     giữ nguyên

-- Giải thích bẫy:
-- Nếu min_trust_score = -10
-- → điều kiện trust_score >= -10
-- → tất cả driver đều pass → sai nghiệp vụ

-- ===== 3. SQL TRIỂN KHAI =====
SELECT 
    driver_id,
    status,
    trust_score,
    distance_km
FROM Drivers
WHERE status = 'AVAILABLE'
  AND trust_score >= 80   -- sau khi đã validate ở backend
ORDER BY distance_km ASC, trust_score DESC
LIMIT 5;

-- ===== 4. GIẢI THÍCH =====
-- WHERE:
--  + status = 'AVAILABLE' → chỉ lấy tài xế đang hoạt động
--  + trust_score >= 80 → đảm bảo chất lượng

-- ORDER BY:
--  + distance_km ASC → gần nhất lên đầu
--  + trust_score DESC → cùng khoảng cách thì ưu tiên điểm cao

-- LIMIT:
--  + lấy 5 tài xế phù hợp nhất để gán đơn

-- ===== 5. KẾT LUẬN =====
-- Backend: xử lý dữ liệu sai (validate input)
-- SQL: lọc + sắp xếp đúng logic nghiệp vụ