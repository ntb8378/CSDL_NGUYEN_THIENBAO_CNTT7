create database Spam_FraudDetection_db;
use Spam_FraudDetection_db;

CREATE TABLE users (
    user_id INT PRIMARY KEY
);
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    status ENUM('PLACED', 'CANCELLED'),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
INSERT INTO users VALUES (1), (2);
INSERT INTO bookings (user_id, status) VALUES
(1,'PLACED'),(1,'PLACED'),(1,'PLACED'),(1,'PLACED'),
(1,'CANCELLED'),(1,'CANCELLED'),(1,'CANCELLED'),
(1,'CANCELLED'),(1,'CANCELLED'),(1,'CANCELLED'),
(2,'PLACED'),(2,'PLACED'),(2,'PLACED'),(2,'CANCELLED'),
(2,'CANCELLED'),(2,'CANCELLED'),(2,'CANCELLED'),
(2,'CANCELLED'),(2,'CANCELLED'),(2,'CANCELLED');

SELECT user_id, 
 -- Đếm tổng số đơn của mỗi user 
 -- SUM sẽ cộng các giá trị này → chỉ đếm những đơn CANCELLED
COUNT(*) AS total_orders, SUM( status = 'CANCELLED' ) total_cancelled 
FROM bookings
-- Gom các đơn theo từng user
GROUP BY user_id
-- Lọc sau khi đã nhóm:
HAVING COUNT(*) >= 10 AND SUM( status = 'CANCELLED' )