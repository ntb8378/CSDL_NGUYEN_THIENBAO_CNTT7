-- ===== 1. GIẢI PHÁP KIẾN TRÚC =====
-- Dùng CASE WHEN trong SQL để:
--  + Rẽ nhánh logic (if/else)
--  + Tạo cột ảo Xep_Hang ngay trong SELECT

-- ===== 2. XỬ LÝ NGOẠI LỆ (NULL) =====
-- total_orders có thể = NULL
-- → nếu không xử lý:
--    NULL không thỏa điều kiện >, < → dễ bị gán sai

-- Cách xử lý:
-- Dùng COALESCE(total_orders, 0)
-- → nếu NULL → tự động chuyển thành 0

-- ===== 3. CODE HOÀN CHỈNH =====
SELECT 
    user_name AS Ten_Khach_Hang,
    CASE
        WHEN COALESCE(total_orders, 0) > 500 THEN 'Kim Cương'
        WHEN COALESCE(total_orders, 0) BETWEEN 100 AND 500 THEN 'Vàng'
        ELSE 'Bạc'
    END AS Xep_Hang
FROM Users;

-- ===== 4. GIẢI THÍCH =====
-- CASE:
--  + giống if/else trong lập trình

-- COALESCE(total_orders, 0):
--  + nếu NULL → chuyển thành 0
--  + tránh lỗi logic khi so sánh

-- Logic:
--  > 500 → Kim Cương
--  100 - 500 → Vàng
--  < 100 → Bạc (bao gồm cả NULL sau khi convert = 0)

-- ===== 5. KẾT LUẬN =====
-- CASE = rẽ nhánh
-- COALESCE = xử lý NULL
-- → tạo được cột Xep_Hang an toàn, đúng nghiệp vụ