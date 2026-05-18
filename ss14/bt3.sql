USE RikkeiClinicDB;

DROP PROCEDURE IF EXISTS DispenseMedicine;

DELIMITER //

CREATE PROCEDURE DispenseMedicine(
    IN p_patient_id INT,
    IN p_medicine_id INT,
    IN p_quantity INT,
    OUT p_message VARCHAR(255)
)
BEGIN

    START TRANSACTION;

    IF p_quantity <= (
        SELECT stock
        FROM Medicines
        WHERE medicine_id = p_medicine_id
    ) THEN

        UPDATE Medicines
        SET stock = stock - p_quantity
        WHERE medicine_id = p_medicine_id;

        UPDATE Patient_Invoices
        SET total_due = total_due + (
            p_quantity * (
                SELECT price
                FROM Medicines
                WHERE medicine_id = p_medicine_id
            )
        )
        WHERE patient_id = p_patient_id;

        COMMIT;

        SET p_message = 'Đã cấp phát thành công';

    ELSE

        ROLLBACK;

        SET p_message = 'Lỗi: Số lượng tồn kho không đủ';

    END IF;

END //

DELIMITER ;

call  DispenseMedicine(1,1,4,@thongbao);
select @thongbao;