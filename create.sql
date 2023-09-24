CREATE SCHEMA `projectdb` ;

CREATE TABLE `user` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `f_name` VARCHAR(45) NOT NULL,
  `m_name` VARCHAR(45) NULL DEFAULT NULL,
  `l_name` VARCHAR(45) NOT NULL,
  `type` ENUM('SUPERADMIN', 'ADMIN', 'CUSTOMER') NOT NULL,
  `dob` DATE NOT NULL,
  `country_code` INT UNSIGNED NOT NULL,
  `mobile_number` BIGINT UNSIGNED NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `mobile_number_UNIQUE` (`mobile_number` ASC) VISIBLE,
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE);



CREATE TABLE `vendor` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE);


CREATE TABLE `categories` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE);

CREATE TABLE `user_address` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `address_line_1` VARCHAR(100) NOT NULL,
  `address_line_2` VARCHAR(100) NULL,
  `city` VARCHAR(45) NOT NULL,
  `state` VARCHAR(45) NOT NULL,
  `country` VARCHAR(45) NOT NULL,
  `zip` VARCHAR(45) NOT NULL,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `user_id_foreign_key_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `user_id_foreign_key`
    FOREIGN KEY (`user_id`)
    REFERENCES `projectdb`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE `product_details` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` TEXT NOT NULL,
  `description` TEXT NULL,
  `product_image_url` TEXT NULL,
  `cost_price` DOUBLE  NOT NULL,
  `selling_price` DOUBLE  NOT NULL,
  `quantity` INT UNSIGNED NOT NULL,
  `dimension` TEXT NULL,
  `specification` TEXT NULL,
  `brand_name` TEXT,
  `color` VARCHAR(45) NULL,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE);

CREATE TABLE `orders` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `vendor_id` INT UNSIGNED NOT NULL,
  `payment_recieved` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `status` VARCHAR(45) NOT NULL,
  `status_description` TEXT NULL,
  `tracking_id` TEXT NULL,
  `order_date` DATETIME NOT NULL,
  `delivery_date` DATETIME NOT NULL,
  `delivered_on` DATETIME NULL,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `user_id_foreign_key_idx` (`user_id` ASC) VISIBLE,
  INDEX `vendor_id_foreign_key_idx` (`vendor_id` ASC) VISIBLE,
  CONSTRAINT `orders_user_id_foreign_key`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `orders_vendor_id_foreign_key`
    FOREIGN KEY (`vendor_id`)
    REFERENCES `vendor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE `vendor_order_status` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` INT UNSIGNED NOT NULL,
  `payment` INT NOT NULL,
  `send_to_vendor` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `recieved_from_vendor` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `order_id_UNIQUE` (`order_id` ASC) VISIBLE,
  CONSTRAINT `vendor_order_id_foreign_key`
    FOREIGN KEY (`order_id`)
    REFERENCES `projectdb`.`orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `payment_details` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `payment_type` ENUM("DEBIT", "CREDIT") NOT NULL,
  `card_number` BIGINT NOT NULL,
  `exp_date` VARCHAR(45) NOT NULL,
  `cvv` INT NOT NULL,
  `name_on_card` VARCHAR(45) NOT NULL,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE);


CREATE TABLE `discount` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(45) NOT NULL,
  `amount` INT NULL,
  `percentage` INT NULL,
  `max_amount` INT NULL,
  `start_date` DATETIME NOT NULL,
  `end_date` DATETIME NOT NULL,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `code_UNIQUE` (`code` ASC) VISIBLE);


CREATE TABLE `user_payment_details` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `payment_details_id` INT UNSIGNED NOT NULL,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `aefwef_idx` (`user_id` ASC) VISIBLE,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `payment_details_id_frgn_key_idx` (`payment_details_id` ASC) VISIBLE,
  CONSTRAINT `payment_user_id_frgn_key`
    FOREIGN KEY (`user_id`)
    REFERENCES `projectdb`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `payment_details_id_frgn_key`
    FOREIGN KEY (`payment_details_id`)
    REFERENCES `projectdb`.`payment_details` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE `vendor_admin` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `vendor_id` INT UNSIGNED NOT NULL,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `vendor_user_id_frgn_key_idx` (`user_id` ASC) VISIBLE,
  INDEX `vendor_admin_id_frgn_key_idx` (`vendor_id` ASC) VISIBLE,
  CONSTRAINT `vendor_user_id_frgn_key`
    FOREIGN KEY (`user_id`)
    REFERENCES `projectdb`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `vendor_admin_id_frgn_key`
    FOREIGN KEY (`vendor_id`)
    REFERENCES `projectdb`.`vendor` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE `user_cart` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `product_details_id` INT UNSIGNED NOT NULL,
  `quantity` INT NOT NULL,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `user_cart_user_id_frgn_key_idx` (`user_id` ASC) VISIBLE,
  INDEX `user_cart_product_id_frgn_key_idx` (`product_details_id` ASC) VISIBLE,
  UNIQUE INDEX `composite_key_user_product` (`user_id` ASC, `product_details_id` ASC) VISIBLE,
  CONSTRAINT `user_cart_user_id_frgn_key`
    FOREIGN KEY (`user_id`)
    REFERENCES `projectdb`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `user_cart_product_id_frgn_key`
    FOREIGN KEY (`product_details_id`)
    REFERENCES `projectdb`.`product_details` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE `reviews` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `product_details_id` INT UNSIGNED NOT NULL,
  `stars` INT NOT NULL,
  `description` TEXT NULL,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `reviews_user_id_frgn_key_idx` (`user_id` ASC) VISIBLE,
  INDEX `reviews_product_id_frgn_key_idx` (`product_details_id` ASC) VISIBLE,
  CONSTRAINT `reviews_user_id_frgn_key`
    FOREIGN KEY (`user_id`)
    REFERENCES `projectdb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `reviews_product_id_frgn_key`
    FOREIGN KEY (`product_details_id`)
    REFERENCES `projectdb`.`product_details` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE `product_ordered` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` INT UNSIGNED NOT NULL,
  `product_details_id` INT UNSIGNED NOT NULL,
  `quantity` INT NOT NULL,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `prd_ord_order_id_frgn_key_idx` (`order_id` ASC) VISIBLE,
  INDEX `prd_ord_product_id_frgn_key_idx` (`product_details_id` ASC) VISIBLE,
  CONSTRAINT `prd_ord_order_id_frgn_key`
    FOREIGN KEY (`order_id`)
    REFERENCES `projectdb`.`orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `prd_ord_product_id_frgn_key`
    FOREIGN KEY (`product_details_id`)
    REFERENCES `projectdb`.`product_details` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `product_vendor` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `vendor_id` INT UNSIGNED NOT NULL,
  `product_details_id` INT UNSIGNED NOT NULL,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `prd_vendor_id_frgn_key_idx` (`vendor_id` ASC) VISIBLE,
  INDEX `prd_vendor_product_id_frgn_key_idx` (`product_details_id` ASC) VISIBLE,
  CONSTRAINT `prd_vendor_id_frgn_key`
    FOREIGN KEY (`vendor_id`)
    REFERENCES `projectdb`.`vendor` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `prd_vendor_product_id_frgn_key`
    FOREIGN KEY (`product_details_id`)
    REFERENCES `projectdb`.`product_details` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);


CREATE TABLE `product_categories` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id` INT UNSIGNED NOT NULL,
  `product_details_id` INT UNSIGNED NOT NULL,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `product_category_prd_id_frgn_key_idx` (`product_details_id` ASC) VISIBLE,
  INDEX `product_category_id_frgn_key_idx` (`category_id` ASC) VISIBLE,
  CONSTRAINT `product_category_prd_id_frgn_key`
    FOREIGN KEY (`product_details_id`)
    REFERENCES `projectdb`.`product_details` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `product_category_id_frgn_key`
    FOREIGN KEY (`category_id`)
    REFERENCES `projectdb`.`categories` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE `discount_on_products` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `discount_id` INT UNSIGNED NOT NULL,
  `product_details_id` INT UNSIGNED NOT NULL,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `dist_product_id_frgn_key_idx` (`product_details_id` ASC) VISIBLE,
  INDEX `product_discount_id_frgn_key_idx` (`discount_id` ASC) VISIBLE,
  CONSTRAINT `dist_product_id_frgn_key`
    FOREIGN KEY (`product_details_id`)
    REFERENCES `projectdb`.`product_details` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `product_discount_id_frgn_key`
    FOREIGN KEY (`discount_id`)
    REFERENCES `projectdb`.`discount` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE `discount_categories` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `discount_id` INT UNSIGNED NOT NULL,
  `category_id` INT UNSIGNED NOT NULL,
  `created_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `category_discount_id_frgn_key_idx` (`discount_id` ASC) VISIBLE,
  INDEX `discount_category_id_frgn_key_idx` (`category_id` ASC) VISIBLE,
  CONSTRAINT `category_discount_id_frgn_key`
    FOREIGN KEY (`discount_id`)
    REFERENCES `projectdb`.`discount` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `discount_category_id_frgn_key`
    FOREIGN KEY (`category_id`)
    REFERENCES `projectdb`.`categories` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
