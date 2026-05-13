DELIMITER //

CREATE PROCEDURE FindEmptyBed(
    IN input_dept INT,
    OUT empty_bed_id INT
)
BEGIN
    SELECT bed_id INTO empty_bed_id
    FROM Beds
    WHERE dept_id = input_dept AND patient_id IS NULL
    LIMIT 1;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE TransferBed(
    IN input_patient INT,
    IN target_dept INT,
    OUT new_bed_id INT,
    OUT status_message VARCHAR(100)
)
BEGIN
    DECLARE old_bed INT;
    DECLARE dept_name VARCHAR(100);
    DECLARE tmp_bed INT;

    -- Kiểm tra bệnh nhân đã xuất viện chưa
    IF EXISTS (
        SELECT 1 FROM Appointments
        WHERE patient_id = input_patient AND status = 'Completed'
    ) THEN
        SET new_bed_id = NULL;
        SET status_message = 'Lỗi: Bệnh nhân đã xuất viện';
        LEAVE proc;
    END IF;

    CALL FindEmptyBed(target_dept, tmp_bed);
    
    IF tmp_bed IS NULL THEN
        SELECT dept_name INTO dept_name FROM Departments WHERE dept_id = target_dept;
        SET new_bed_id = NULL;
        SET status_message = CONCAT('Từ chối: Khoa ', dept_name, ' đã hết giường');
    ELSE
        UPDATE Beds SET patient_id = NULL WHERE patient_id = input_patient;

        UPDATE Beds SET patient_id = input_patient WHERE bed_id = tmp_bed;

        SET new_bed_id = tmp_bed;
        SET status_message = 'Chuyển giường thành công';
    END IF;
END //

DELIMITER ;



CALL TransferBed(1, 2, @bed, @msg);
SELECT @bed, @msg;
CALL TransferBed(2, 3, @bed, @msg);
SELECT @bed, @msg;
CALL TransferBed(2, 1, @bed, @msg);
SELECT @bed, @msg;
CALL TransferBed(1, 999, @bed, @msg);
SELECT @bed, @msg;
