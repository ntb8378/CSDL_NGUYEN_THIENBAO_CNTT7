USE RikkeiClinicDB;

DROP PROCEDURE IF EXISTS ProcessEquipmentPurchase;

DELIMITER //

CREATE PROCEDURE ProcessEquipmentPurchase(
    IN p_patient_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    OUT p_message VARCHAR(255)
)
BEGIN

    START TRANSACTION;

    IF p_quantity > (
        SELECT stock
        FROM Products
        WHERE product_id = p_product_id
    ) THEN

        ROLLBACK;

        SET p_message = 'Thất bại: Kho không đủ sản phẩm';

    ELSEIF (
        SELECT status
        FROM Wallets
        WHERE patient_id = p_patient_id
    ) = 'Inactive' THEN

        ROLLBACK;

        SET p_message = 'Thất bại: Ví đang bị khóa';

    ELSEIF (
        p_quantity * (
            SELECT price
            FROM Products
            WHERE product_id = p_product_id
        )
    ) > (
        SELECT balance
        FROM Wallets
        WHERE patient_id = p_patient_id
    ) THEN

        ROLLBACK;

        SET p_message = 'Thất bại: Số dư ví không đủ';

    ELSE

        UPDATE Products
        SET stock = stock - p_quantity
        WHERE product_id = p_product_id;

        UPDATE Wallets
        SET balance = balance - (
            p_quantity * (
                SELECT price
                FROM Products
                WHERE product_id = p_product_id
            )
        )
        WHERE patient_id = p_patient_id;

        COMMIT;

        SET p_message = 'Thành công: Đã xử lý đơn hàng';

    END IF;

END //

DELIMITER ;

CALL ProcessEquipmentPurchase(1, 1, 1, @msg);
SELECT @msg;

CALL ProcessEquipmentPurchase(1, 1, 100, @msg);
SELECT @msg;

CALL ProcessEquipmentPurchase(2, 1, 1, @msg);
SELECT @msg;

CALL ProcessEquipmentPurchase(3, 2, 1, @msg);
SELECT @msg;