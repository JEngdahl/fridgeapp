-- Prairie Dogs, Fridge App
-- Monday, April 10th, 2017
-- Model: Fridge, Version: 1.0

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema fridge
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `fridge` DEFAULT CHARACTER SET utf8 ;
USE `fridge` ;

-- -----------------------------------------------------
-- Table `fridge`.`house`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fridge`.`house` (
  `house_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `admin_user_in_house` INT UNSIGNED NULL,
  `house_address` VARCHAR(255) NOT NULL,
  `house_unit_number` VARCHAR(30) NULL,
  `house_city` VARCHAR(100) NOT NULL,
  `house_state` VARCHAR(2) NOT NULL,
  `house_zip` VARCHAR(5) NOT NULL,
  `house_account` VARCHAR(255) NULL,
  `house_info` TEXT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`house_id`),
  INDEX `fk_house_user_idx` (`admin_user_in_house` ASC),
  CONSTRAINT `fk_house_user`
    FOREIGN KEY (`admin_user_in_house`)
    REFERENCES `fridge`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fridge`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fridge`.`user` (
  `user_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_first_name` VARCHAR(30) NOT NULL,
  `user_last_name` VARCHAR(30) NOT NULL,
  `user_email` VARCHAR(100) NOT NULL,
  `user_username` VARCHAR(16) NOT NULL,
  `user_password` VARCHAR(255) NOT NULL,
  `user_phone` VARCHAR(10) NOT NULL,
  `user_birthday` DATE NULL,
  `house_in_user` INT UNSIGNED NULL,
  `user_is_admin` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `user_info` TEXT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  INDEX `fk_user_house1_idx` (`house_in_user` ASC),
  CONSTRAINT `fk_user_house1`
    FOREIGN KEY (`house_in_user`)
    REFERENCES `fridge`.`house` (`house_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fridge`.`expense`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fridge`.`expense` (
  `expense_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `house_in_expense` INT UNSIGNED NOT NULL,
  `expense_name` VARCHAR(255) NOT NULL,
  `expense_balance` DECIMAL(10,2) UNSIGNED NOT NULL,
  `expense_billing_month` TINYINT UNSIGNED NOT NULL,
  `expense_due` DATE NULL,
  `expense_is_paid` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `expense_is_one_time` TINYINT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`expense_id`),
  INDEX `fk_expense_house1_idx` (`house_in_expense` ASC),
  CONSTRAINT `fk_expense_house1`
    FOREIGN KEY (`house_in_expense`)
    REFERENCES `fridge`.`house` (`house_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fridge`.`chore`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fridge`.`chore` (
  `chore_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `house_in_chore` INT UNSIGNED NOT NULL,
  `chore_name` VARCHAR(255) NOT NULL,
  `chore_due` DATE NULL,
  `chore_group` INT UNSIGNED NULL,
  `chore_parent` INT UNSIGNED NULL,
  `chore_is_done` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `assigned_to_user_in_chore` INT UNSIGNED NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`chore_id`),
  INDEX `fk_task_user1_idx` (`assigned_to_user_in_chore` ASC),
  INDEX `fk_task_house1_idx` (`house_in_chore` ASC),
  CONSTRAINT `fk_task_user1`
    FOREIGN KEY (`assigned_to_user_in_chore`)
    REFERENCES `fridge`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_task_house1`
    FOREIGN KEY (`house_in_chore`)
    REFERENCES `fridge`.`house` (`house_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fridge`.`task`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fridge`.`task` (
  `task_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `house_in_task` INT UNSIGNED NOT NULL,
  `task_name` VARCHAR(255) NULL,
  `claimed_by_user_in_task` INT UNSIGNED NULL,
  `task_is_done` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `expense_in_task` INT UNSIGNED NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`task_id`),
  INDEX `fk_chore_user1_idx` (`claimed_by_user_in_task` ASC),
  INDEX `fk_chore_house1_idx` (`house_in_task` ASC),
  INDEX `fk_task_expense1_idx` (`expense_in_task` ASC),
  CONSTRAINT `fk_chore_user1`
    FOREIGN KEY (`claimed_by_user_in_task`)
    REFERENCES `fridge`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_chore_house1`
    FOREIGN KEY (`house_in_task`)
    REFERENCES `fridge`.`house` (`house_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_task_expense1`
    FOREIGN KEY (`expense_in_task`)
    REFERENCES `fridge`.`expense` (`expense_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
