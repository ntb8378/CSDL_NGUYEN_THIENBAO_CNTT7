CREATE DATABASE if not exists RikkeiClinicDB;
USE RikkeiClinicDB;

delimiter //
create procedure CalcHospitalFee(
	IN total_cost DECIMAL(18,2),
    IN patient_type VARCHAR(20),
    OUT final_amount DECIMAL(18,2),
    OUT status_message VARCHAR(100)
)
begin 
	 IF total_cost < 0 THEN
        SET final_amount = 0;
        SET status_message = 'Lỗi: Chi phí không hợp lệ';
    ELSE
        IF patient_type = 'BHYT' THEN
            SET final_amount = total_cost * 0.2;
        ELSEIF patient_type = 'VIP' THEN
            SET final_amount = total_cost * 0.9;
        ELSEIF patient_type = 'THUONG' THEN
            SET final_amount = total_cost;
        ELSE
            SET final_amount = total_cost;
        END IF;

        SET status_message = 'Đã tính toán xong';
    END IF;
end //
delimiter ;

CALL CalcHospitalFee(1000000, 'BHYT', @amount, @msg);
SELECT @amount AS 'Số tiền phải thu', @msg AS 'Trạng thái';