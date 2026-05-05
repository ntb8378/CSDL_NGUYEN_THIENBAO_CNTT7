-- ===== 1. GIẢI THÍCH BẪY (comment) =====
-- Nếu viết sai:
-- WHERE A AND B OR C
-- → SQL hiểu: (A AND B) OR C
-- → chỉ cần C đúng → lọt cả dữ liệu sai (CANCELLED, >5tr)

-- Cách đúng:
-- Dùng ngoặc:
-- A AND B AND (C OR D)

-- ===== 2. BACKEND VALIDATION (comment) =====
-- page = input.page
-- limit = 20

-- if (page IS NULL) → page = 1
-- if (page <= 0) → page = 1

-- OFFSET = (page - 1) * limit
-- Page 3 → OFFSET = (3 - 1) * 20 = 40

-- ===== 3. SQL HOÀN CHỈNH =====
SELECT 
    order_id,
    total_amount,
    status,
    note,
    user_id,
    CASE
        WHEN total_amount > 4000000 THEN 'Nguy hiểm'
        ELSE 'Bình thường'
    END AS Alert_Level
FROM Orders
WHERE total_amount BETWEEN 2000000 AND 5000000
  AND status != 'CANCELLED'
  AND (
        note LIKE '%gấp%'
        OR user_id IS NULL
      )
ORDER BY total_amount DESC
LIMIT 20 OFFSET 40;

-- ===== 4. GIẢI THÍCH =====
-- WHERE:
--  + Lọc giá trị từ 2tr → 5tr
--  + Loại bỏ đơn CANCELLED
--  + Chỉ lấy:
--      note có 'gấp' HOẶC user_id NULL

-- ORDER BY:
--  + total_amount DESC → đơn đắt nhất lên đầu

-- LIMIT + OFFSET:
--  + Trang 3 (20 dòng/trang) → OFFSET 40

-- CASE:
--  + > 4tr → 'Nguy hiểm'
--  + còn lại → 'Bình thường'