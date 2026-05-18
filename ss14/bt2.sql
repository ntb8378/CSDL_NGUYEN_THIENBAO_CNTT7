USE RikkeiClinicDB;

DELIMITER //

CREATE PROCEDURE TransferBed(IN p_patient_id INT, IN p_new_bed_id INT)
BEGIN
-- Thao tắc 1: Giải phóng giường cũ
UPDATE Beds SET patient_id = NULL WHERE patient_id = p_patient_id;

-- Thao tắc 2: Gắn giường mới
UPDATE Beds SET patient_id = p_patient_id WHERE bed_id = p_new_bed_id;
END //

DELIMITER ;

-- phần A:
-- Đồng thời thực hiện 2 bước giải phóng giường cũ và gán bệnh nhân , 
-- nhưng máy chỉ bị treo nên chỉ giải phóng giường mà chưa gán , kết nối lại 
-- thì người mất tích , vi phạm vào tính nguyên tử, vì một là làm hết , còn 2 là
-- không làm gì cả rollback luôn, còn cái này nó lững giữa chừng.


-- phần B: 

drop PROCEDURE TransferBed;
USE RikkeiClinicDB;

DROP PROCEDURE IF EXISTS TransferBed;

DELIMITER //

CREATE PROCEDURE TransferBed(
    IN p_patient_id INT,
    IN p_new_bed_id INT
)
BEGIN
    START TRANSACTION;
    IF p_new_bed_id IS NOT NULL THEN
        UPDATE Beds
        SET patient_id = NULL
        WHERE patient_id = p_patient_id;
        UPDATE Beds
        SET patient_id = p_patient_id
        WHERE bed_id = p_new_bed_id;
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;

END //

DELIMITER ;
CALL TransferBed(1,201);
SELECT * FROM Beds;