USE RikkeiClinicDB;

DELIMITER //

CREATE TRIGGER PreventStatusRevert
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
-- Lôi logic: Dùng NEW thay vì OLD khiến toàn bộ hệ thông bị "tê liệt"
IF new.status = 'Completed' THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lôi: Không được phép thao tác trên lịch khám
này!';
end IF;
END //

DELIMITER ;


drop  TRIGGER PreventStatusRevert;

update Appointments
set status ='Completed'
where appointment_id = 104;

select * from Appointments;
--  nếu như v thì nó sẽ lỗi là mỗi khi khách hàng muốn đổi trạng thái từ penting sang complete thì nó sẽ không cho , nhưng đổi ngược lại thì mới được 
-- như v thì nó lại bị ngược với để bài là không được đổi trạng thái khi nó đang là complete

-- cách sửa:

DELIMITER //

CREATE TRIGGER PreventStatusRevert
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
    -- Nếu lịch khám đã Completed mà muốn đổi sang trạng thái khác => chặn
    IF OLD.status = 'Completed' AND NEW.status != 'Completed' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Không được phép thay đổi trạng thái của lịch khám đã Completed!';
    END IF;
END //

DELIMITER ;

select * from Appointments;

update Appointments
set status ='panting'
where appointment_id = 104;