USE RikkeiClinicDB;


DELIMITER //

CREATE TRIGGER trg_check_doctor_schedule_insert
BEFORE INSERT ON Appointments
FOR EACH ROW
BEGIN

    DECLARE schedule_count INT;

    SELECT COUNT(*)
    INTO schedule_count
    FROM Appointments
    WHERE doctor_id = NEW.doctor_id
    AND appointment_date = NEW.appointment_date
    AND status <> 'Cancelled';

    IF schedule_count > 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Bác sĩ đã có lịch hẹn vào khung giờ này';

    END IF;

END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_check_doctor_schedule_update
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN

    DECLARE schedule_count INT;

    SELECT COUNT(*)
    INTO schedule_count
    FROM Appointments
    WHERE doctor_id = NEW.doctor_id
    AND appointment_date = NEW.appointment_date
    AND status <> 'Cancelled'
    AND appointment_id <> NEW.appointment_id;

    IF schedule_count > 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Bác sĩ đã có lịch hẹn vào khung giờ này';

    END IF;

END //

DELIMITER ;
INSERT INTO Appointments(
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    status
)
VALUES(
    200,
    1,
    101,
    '2026-06-11 08:00:00',
    'Pending'
);



INSERT INTO Appointments(
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    status
)
VALUES(
    201,
    2,
    101,
    '2026-06-11 08:00:00',
    'Pending'
);

INSERT INTO Appointments(
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    status
)
VALUES(
    202,
    2,
    102,
    '2026-06-12 09:00:00',
    'Cancelled'
);

INSERT INTO Appointments(
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    status
)
VALUES(
    203,
    3,
    102,
    '2026-06-12 09:00:00',
    'Pending'
);

UPDATE Appointments
SET status = 'Completed'
WHERE appointment_id = 200;