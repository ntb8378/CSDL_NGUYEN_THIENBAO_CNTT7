DELIMITER //

CREATE PROCEDURE ProcessPrescription(
    IN input_patient_id INT,
    IN input_medicine_id INT,
    IN input_quantity INT,
    IN input_discount_code VARCHAR(20),
    OUT status_message VARCHAR(100)
)
BEGIN
    DECLARE current_stock INT;
    DECLARE unit_price DECIMAL(18,2);
    DECLARE amount DECIMAL(18,2);

    -- Lấy thông tin thuốc
    SELECT stock, price INTO current_stock, unit_price
    FROM Medicines
    WHERE medicine_id = input_medicine_id;

    -- Kiểm tra tồn kho
    IF current_stock IS NULL THEN
        SET status_message = 'Thất bại: Mã thuốc không tồn tại';
    ELSEIF input_quantity > current_stock THEN
        SET status_message = 'Thất bại: Kho không đủ thuốc';
    ELSE
        -- Tính tiền
        SET amount = input_quantity * unit_price;

        IF input_discount_code = 'NV-RIKKEI' THEN
            SET amount = amount * 0.5;
        END IF;

        -- Trừ kho
        UPDATE Medicines
        SET stock = stock - input_quantity
        WHERE medicine_id = input_medicine_id;

        -- Cộng dồn công nợ
        UPDATE Patient_Invoices
        SET total_due = total_due + amount
        WHERE patient_id = input_patient_id;

        SET status_message = 'Thành công: Đã xử lý đơn thuốc';
    END IF;
END //

DELIMITER ;


CALL ProcessPrescription(1, 1, 10, NULL, @msg);
SELECT @msg AS 'Trạng thái';


CALL ProcessPrescription(1, 1, 5, 'NV-RIKKEI', @msg);
SELECT @msg;


CALL ProcessPrescription(2, 2, 10, NULL, @msg);
SELECT @msg;
