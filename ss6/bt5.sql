-- Tìm "phòng chết" (room không có booking nào) - cách an toàn nhất
SELECT 
    r.room_id,
    r.room_name
FROM rooms r
LEFT JOIN bookings b 
    ON r.room_id = b.room_id
WHERE b.room_id IS NULL;