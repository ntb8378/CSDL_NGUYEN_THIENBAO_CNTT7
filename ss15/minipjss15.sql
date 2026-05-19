create database Centric;
use Centric;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    content TEXT NOT NULL,
    like_count INT DEFAULT 0,
    comment_count INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    
);

CREATE TABLE friends (
    friendship_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    friend_id INT,
    status VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (friend_id) REFERENCES users(user_id),

    CHECK (status IN ('pending', 'accepted'))
);

alter table friends
add CHECK (user_id != friend_id);

CREATE UNIQUE INDEX unique_friendship
ON friends (
    (LEAST(user_id, friend_id)),
    (GREATEST(user_id, friend_id))
);

CREATE TABLE likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    post_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE
);

ALTER TABLE likes
ADD CONSTRAINT unique_user_post_like UNIQUE (user_id, post_id);

-- 1
create view view_user_info as
select user_id, username, email, created_at
from users;

-- 2
delimiter //
create procedure sp_add_user (
	in p_username varchar(50), 
    in p_password varchar(50), 
    in p_email varchar(50)
)
begin 
	if exists ( select 1 from users where email =  p_email or username = p_username) then 
	select  'lỗi' AS message;
    else 
    insert into users (username,password,email)
    values(p_username,p_password,p_email);
    select 'thành công' as message;
    end if;
end //
delimiter ;
call sp_add_user('bao','12325543','ntb@gmail.com');

-- 3
delimiter //
create trigger tg_after_like_insert
after insert on likes
for each row
begin 
	update posts
    set like_count = like_count + 1
    WHERE post_id = NEW.post_id;
end //
delimiter ;


DELIMITER //
CREATE TRIGGER tg_after_like_delete
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
	SET like_count = like_count - 1
	WHERE post_id = OLD.post_id AND like_count > 0;
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER tg_after_comment_insert
AFTER INSERT ON comments
FOR EACH ROW
BEGIN
    UPDATE posts
    SET comment_count = comment_count + 1
    WHERE post_id = NEW.post_id;
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER tg_after_comment_delete
AFTER DELETE ON comments
FOR EACH ROW
BEGIN
    UPDATE posts
	SET comment_count = comment_count - 1
	WHERE post_id = OLD.post_id AND comment_count > 0;
END //
DELIMITER ;

-- 4
DELIMITER //
CREATE PROCEDURE sp_user_activity_report()
BEGIN
    SELECT 
        u.user_id,
        u.username,
        COUNT(DISTINCT p.post_id) AS total_posts,
        COUNT(DISTINCT l.like_id) AS total_likes,
        COUNT(DISTINCT c.comment_id) AS total_comments
    FROM users u
    LEFT JOIN posts p 
        ON u.user_id = p.user_id
    LEFT JOIN likes l 
        ON u.user_id = l.user_id
    LEFT JOIN comments c 
        ON u.user_id = c.user_id
    GROUP BY u.user_id, u.username;
END //
DELIMITER ;

-- 5
DELIMITER //
CREATE PROCEDURE sp_delete_user (
    IN p_user_id INT
)
BEGIN
    IF EXISTS (
        SELECT 1
        FROM users
        WHERE user_id = p_user_id
    ) THEN
        START TRANSACTION;
        DELETE FROM likes
        WHERE user_id = p_user_id;
        DELETE FROM comments
        WHERE user_id = p_user_id;
        DELETE FROM friends
        WHERE user_id = p_user_id
           OR friend_id = p_user_id;
        DELETE FROM posts
        WHERE user_id = p_user_id;
        DELETE FROM users
        WHERE user_id = p_user_id;
        COMMIT;
        SELECT 'Xóa thành công' AS message;
    ELSE
        SELECT 'User không tồn tại' AS message;
    END IF;
END //

DELIMITER ;

-- 6
DELIMITER //

CREATE TRIGGER tg_before_friend_insert
BEFORE INSERT ON friends
FOR EACH ROW
BEGIN

    IF NEW.user_id = NEW.friend_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể tự kết bạn với chính mình';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM friends
        WHERE user_id = NEW.user_id
          AND friend_id = NEW.friend_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lời mời kết bạn đã tồn tại';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM friends
        WHERE user_id = NEW.friend_id
          AND friend_id = NEW.user_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Đã tồn tại lời mời kết bạn ngược chiều';
    END IF;
END //
DELIMITER ;