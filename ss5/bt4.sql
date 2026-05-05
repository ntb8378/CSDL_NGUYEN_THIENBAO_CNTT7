
-- ===== 1. GIẢI PHÁP 1: DÙNG OR =====
SELECT *
FROM Orders
WHERE reason = 'KHACH_HUY'
   OR reason = 'QUAN_DONG_CUA'
   OR reason = 'KHONG_CO_TAI_XE'
   OR reason = 'BOM_HANG';


-- ===== 2. GIẢI PHÁP 2: DÙNG IN (khuyến nghị) =====
SELECT *
FROM Orders
WHERE reason IN (
    'KHACH_HUY',
    'QUAN_DONG_CUA',
    'KHONG_CO_TAI_XE',
    'BOM_HANG'
);


-- ===== 3. BẢNG SO SÁNH =====
-- Tiêu chí                | OR                          | IN
-- ---------------------------------------------------------------
-- Code sạch              | Dài, lặp lại nhiều          | Ngắn gọn, dễ đọc
-- Mở rộng (nhiều giá trị)| Khó viết, dễ sai            | Thêm vào list rất dễ
-- Hiệu năng              | Tương đương (SQL tự tối ưu) | Tương đương


-- ===== 4. XỬ LÝ BẪY (ARRAY RỖNG) =====
-- Nếu mảng rỗng:
-- WHERE reason IN () → lỗi syntax

-- Backend cần xử lý:

-- if (list_reason IS NULL OR list_reason.length == 0) then
--     không gọi SQL
--     hoặc trả về []
--     hoặc thêm điều kiện FALSE (1=0)

-- Ví dụ safe:
-- WHERE 1 = 0  → không trả bản ghi nào nhưng không lỗi


-- ===== 5. CODE TỐT NHẤT (KHUYẾN NGHỊ DÙNG IN) =====
SELECT *
FROM Orders
WHERE reason IN (
    'KHACH_HUY',
    'QUAN_DONG_CUA',
    'KHONG_CO_TAI_XE',
    'BOM_HANG'
);