DELIMITER //

CREATE PROCEDURE GetPatientDebt(
    IN input_id INT,
    IN input_phone VARCHAR(15),
    OUT total_debt DECIMAL(18,2),
    OUT status_message VARCHAR(100)
)
BEGIN
    DECLARE temp_debt DECIMAL(18,2);
    IF input_id IS NULL AND input_phone IS NULL THEN
        SET total_debt = 0;
        SET status_message = 'Lỗi: Không được bỏ trống cả ID và Phone';
    ELSE
        IF input_id IS NOT NULL THEN
            SELECT total_due INTO temp_debt
            FROM Patient_Invoices
            WHERE patient_id = input_id;
            IF temp_debt IS NULL THEN
                SET total_debt = 0;
                SET status_message = 'Không tìm thấy bệnh nhân theo ID';
            ELSE
                SET total_debt = temp_debt;
                SET status_message = 'Đã tra cứu thành công';
            END IF;
        ELSE
            SELECT pi.total_due INTO tmp_debt
            FROM Patient_Invoices pi
            JOIN Patients p ON pi.patient_id = p.patient_id
            WHERE p.phone = input_phone;
            IF tmp_debt IS NULL THEN
                SET total_debt = 0;
                SET status_message = 'Không tìm thấy bệnh nhân theo Phone';
            ELSE
                SET total_debt = tmp_debt;
                SET status_message = 'Đã tra cứu thành công';
            END IF;
        END IF;
    END IF;
END //

DELIMITER ;
