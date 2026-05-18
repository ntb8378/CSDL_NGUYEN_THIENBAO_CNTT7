USE RikkeiClinicDB;

drop procedure if exists Onetap_payment;

delimiter //
	create procedure Onetap_payment(
		IN o_patient_id INT,
        in o_Payment_amount decimal(10,0),
        out o_message varchar(255)
    )
begin
START TRANSACTION;
    IF o_payment_amount <= 0 THEN
        ROLLBACK;
        SET o_message = 'Lỗi: Số tiền thanh toán không hợp lệ';
    ELSEIF o_payment_amount > (
        SELECT balance
        FROM Wallets
        WHERE patient_id = o_patient_id
    ) THEN
        ROLLBACK;
        SET o_message = 'Lỗi: Số dư ví không đủ';
    ELSE
        UPDATE Wallets
        SET balance = balance - o_payment_amount
        WHERE patient_id = o_patient_id;
        UPDATE Patient_Invoices
        SET total_due = total_due - o_payment_amount
        WHERE patient_id = o_patient_id;
        COMMIT;
        SET o_message = 'Thanh toán thành công';
    END IF;
end //
delimiter ;

-- dịch hợp lệ
CALL Onetap_payment(1, 100000, @msg);
SELECT @msg;

-- lỗi khi số dư ví không đủ
CALL Onetap_payment(2, 100000, @msg);
SELECT @msg;

-- lỗi khi truyền số âm
CALL Onetap_payment(1, -50000, @msg);
SELECT @msg;