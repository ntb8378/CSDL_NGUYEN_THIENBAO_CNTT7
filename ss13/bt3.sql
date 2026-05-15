USE RikkeiClinicDB;

CREATE TABLE Price_Changes_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT,
    old_price DECIMAL(18,2),
    new_price DECIMAL(18,2),
    status_change VARCHAR(20),
    difference_amount DECIMAL(18,2),
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER trg_check_price
BEFORE UPDATE ON Medicines
FOR EACH ROW
BEGIN

    IF NEW.price <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Giá thuốc mới không hợp lệ';

    END IF;

END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_log_price_change
AFTER UPDATE ON Medicines
FOR EACH ROW
BEGIN

    IF OLD.price <> NEW.price THEN

        IF NEW.price > OLD.price THEN

            INSERT INTO Price_Changes_Log(
                medicine_id,
                old_price,
                new_price,
                status_change,
                difference_amount
            )
            VALUES(
                OLD.medicine_id,
                OLD.price,
                NEW.price,
                'TĂNG GIÁ',
                NEW.price - OLD.price
            );

        ELSE

            INSERT INTO Price_Changes_Log(
                medicine_id,
                old_price,
                new_price,
                status_change,
                difference_amount
            )
            VALUES(
                OLD.medicine_id,
                OLD.price,
                NEW.price,
                'GIẢM GIÁ',
                OLD.price - NEW.price
            );

        END IF;

    END IF;

END //

DELIMITER ;

UPDATE Medicines
SET price = 20000
WHERE medicine_id = 1;


UPDATE Medicines
SET price = 10000
WHERE medicine_id = 1;


UPDATE Medicines
SET stock = 500
WHERE medicine_id = 1;


UPDATE Medicines
SET price = -1000
WHERE medicine_id = 1;

SELECT * FROM Price_Changes_Log;