-- đoạn code bị lỗi
DELIMITER //

CREATE PROCEDURE AddInventory(IN p_item_id INT, IN p_quantity INT)
BEGIN
UPDATE Inventory
SET stock_quantity = stock_quantity + p_quantity
WHERE item_id = p_item_id;
END //

DELIMITER ;

select * from  Inventory;

call  AddInventory(10,-500);
-- câu lệnh hiện tại đang có điều kiện theo id thôi , nó chưa xử lý nhỏ hơn 0 cho số lượng tồn kho 
-- nên mỗi khi update soosluowngj là âm thì nó trừ thẳng vào bảng luôn

drop PROCEDURE AddInventory;
DELIMITER //

CREATE PROCEDURE AddInventory(IN p_item_id INT, IN p_quantity INT)
BEGIN
IF p_quantity <= 0 THEN
        select 'Số lượng nhập kho phải lớn hơn 0';
    ELSE
        UPDATE Inventory
        SET stock_quantity = stock_quantity + p_quantity
        WHERE item_id = p_item_id;
    END IF;
END //

DELIMITER ;

call  AddInventory(10,1000);