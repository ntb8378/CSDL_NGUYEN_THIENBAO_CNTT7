USE RikkeiClinicDB;

DROP PROCEDURE IF EXISTS FindEmptyBed;
DROP PROCEDURE IF EXISTS EmergencyAdmission;

DELIMITER //

CREATE PROCEDURE FindEmptyBed(
    IN p_dept_id INT,
    OUT p_bed_id INT
)
BEGIN

    SELECT bed_id
    INTO p_bed_id
    FROM Beds
    WHERE dept_id = p_dept_id
    AND patient_id IS NULL
    LIMIT 1;

END //

CREATE PROCEDURE EmergencyAdmission(
    IN p_patient_id INT,
    IN p_doctor_id INT,
    IN p_appointment_date DATETIME,
    IN p_dept_id INT,
    OUT p_message VARCHAR(255)
)
BEGIN

    START TRANSACTION;

    SET @bed_id = NULL;

    IF EXISTS (
        SELECT *
        FROM Beds
        WHERE patient_id = p_patient_id
    ) THEN

        ROLLBACK;

        SET p_message = 'Từ chối: Bệnh nhân đang lưu trú';

    ELSEIF NOT EXISTS (
        SELECT *
        FROM Departments
        WHERE dept_id = p_dept_id
    ) THEN

        ROLLBACK;

        SET p_message = 'Từ chối: Khoa không tồn tại';

    ELSE

        CALL FindEmptyBed(p_dept_id, @bed_id);

        IF @bed_id IS NULL THEN

            ROLLBACK;

            SET p_message = 'Từ chối: Khoa hiện đã hết giường';

        ELSE

            INSERT INTO Appointments(
                appointment_id,
                patient_id,
                doctor_id,
                appointment_date,
                status
            )
            VALUES(
                FLOOR(RAND() * 10000),
                p_patient_id,
                p_doctor_id,
                p_appointment_date,
                'Pending'
            );

            UPDATE Beds
            SET patient_id = p_patient_id
            WHERE bed_id = @bed_id;

            COMMIT;

            SET p_message = 'Nhập viện thành công';

        END IF;

    END IF;

END //

DELIMITER ;

CALL EmergencyAdmission(
    3,
    101,
    '2026-06-20 08:00:00',
    2,
    @msg
);

SELECT @msg;

CALL EmergencyAdmission(
    3,
    101,
    '2026-06-20 09:00:00',
    1,
    @msg
);

SELECT @msg;

CALL EmergencyAdmission(
    1,
    101,
    '2026-06-20 10:00:00',
    2,
    @msg
);

SELECT @msg;

CALL EmergencyAdmission(
    3,
    101,
    '2026-06-20 11:00:00',
    99,
    @msg
);

SELECT @msg;