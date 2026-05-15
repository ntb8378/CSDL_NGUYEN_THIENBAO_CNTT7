USE RikkeiClinicDB;

DELIMITER //

CREATE TRIGGER AutoDeductWallet
BEFORE INSERT ON Service_Usages
FOR EACH ROW
BEGIN

    DECLARE service_price DECIMAL(18,2);
    DECLARE wallet_balance DECIMAL(18,2);
    DECLARE wallet_status VARCHAR(20);



    -- LẤY GIÁ DỊCH VỤ
    SELECT price
    INTO service_price
    FROM Services
    WHERE service_id = NEW.service_id;



    -- GÁN GIÁ THỰC TẾ
    SET NEW.actual_price = service_price;



    -- LẤY THÔNG TIN VÍ
    SELECT balance, status
    INTO wallet_balance, wallet_status
    FROM Wallets
    WHERE patient_id = NEW.patient_id;



    -- KIỂM TRA THẺ KHÓA
    IF wallet_status = 'Inactive' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Thất bại: Ví trả trước đang bị khóa';

    END IF;



    -- KIỂM TRA SỐ DƯ
    IF wallet_balance < service_price THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Thất bại: Số dư ví không đủ để thanh toán';

    END IF;



    -- TRỪ TIỀN VÍ
    UPDATE Wallets
    SET balance = balance - service_price
    WHERE patient_id = NEW.patient_id;

END //

DELIMITER ;