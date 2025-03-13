-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema reservas
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema reservas
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `checkandfood` DEFAULT CHARACTER SET utf8mb4 ;
USE `checkandfood` ;

-- -----------------------------------------------------
-- Table `reservas`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `checkandfood`.`customer` (
  `customer_id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `phone_number` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE INDEX `username_UNIQUE` (`email` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `reservas`.`restaurant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `checkandfood`.`restaurant` (
  `restaurant_id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `capacity` INT(4) NOT NULL,
  `phone_number` VARCHAR(14) NOT NULL,
  PRIMARY KEY (`restaurant_id`),
  UNIQUE INDEX `username_UNIQUE` (`email` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `reservas`.`reserve`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `checkandfood`.`reserve` (
  `reserve_id` INT(11) NOT NULL AUTO_INCREMENT,
  `date` DATETIME NOT NULL,
  `dinner` INT(4) NOT NULL DEFAULT 1,
  `restaurant_id` INT(11) NOT NULL,
  `customer_id` INT(11) NOT NULL,
  `estatus` VARCHAR(20) NOT NULL DEFAULT 'activa',
  PRIMARY KEY (`reserve_id`),
  INDEX `fk_reserve_restaurant_idx` (`restaurant_id` ASC) ,
  INDEX `fk_reserve_customer1_idx` (`customer_id` ASC) ,
  CONSTRAINT `fk_reserve_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `reservas`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reserve_restaurant`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `reservas`.`restaurant` (`restaurant_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;