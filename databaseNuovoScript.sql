-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema mydb1
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb1
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb1` DEFAULT CHARACTER SET utf8 COLLATE utf8_czech_ci ;
USE `mydb1` ;

-- -----------------------------------------------------
-- Table `mydb1`.`city`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`city` (
  `NameC` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL,
  `State` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL,
  PRIMARY KEY (`NameC`, `State`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_czech_ci;


-- -----------------------------------------------------
-- Table `mydb1`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`user` (
  `idUser` INT NOT NULL AUTO_INCREMENT,
  `Username` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_czech_ci' NOT NULL,
  `password` VARCHAR(65) CHARACTER SET 'utf8' COLLATE 'utf8_czech_ci' NOT NULL,
  `NameUser` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_czech_ci' NOT NULL,
  `Surname` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_czech_ci' NOT NULL,
  `BirthDate` DATE NULL DEFAULT NULL,
  `DescriptionProfile` VARCHAR(150) CHARACTER SET 'utf8' COLLATE 'utf8_czech_ci' NOT NULL DEFAULT 'Description',
  `Email` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_czech_ci' NOT NULL,
  `FollowerNumber` INT NOT NULL DEFAULT '0',
  `FollowingNumber` INT NOT NULL DEFAULT '0',
  `TripNumber` INT NOT NULL DEFAULT '0',
  `ProfileImage` LONGBLOB NULL DEFAULT NULL,
  `Verification` TINYINT NOT NULL DEFAULT '0',
  `Gender` VARCHAR(1) CHARACTER SET 'utf8' COLLATE 'utf8_czech_ci' NOT NULL DEFAULT 'o',
  `Nazionalita` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_czech_ci' NULL DEFAULT NULL,
  PRIMARY KEY (`idUser`),
  UNIQUE INDEX `idUser_UNIQUE` (`idUser` ASC) VISIBLE,
  UNIQUE INDEX `Username_UNIQUE` (`Username` ASC) VISIBLE,
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 16
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_czech_ci;


-- -----------------------------------------------------
-- Table `mydb1`.`facebooklogin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`facebooklogin` (
  `idFacebookLogin` VARCHAR(16) CHARACTER SET 'utf8' COLLATE 'utf8_czech_ci' NOT NULL,
  `IdUser` INT NOT NULL,
  PRIMARY KEY (`idFacebookLogin`),
  INDEX `IdUser_idx` (`IdUser` ASC) VISIBLE,
  CONSTRAINT `IdUser`
    FOREIGN KEY (`IdUser`)
    REFERENCES `mydb1`.`user` (`idUser`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_czech_ci;


-- -----------------------------------------------------
-- Table `mydb1`.`trip`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`trip` (
  `idTrip` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(20) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `costo` DOUBLE NOT NULL DEFAULT '0',
  `tipo` VARCHAR(70) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `Nlike` INT NULL DEFAULT '0',
  `StartDate` DATE NOT NULL,
  `EndDate` DATE NOT NULL,
  `StepNumber` INT NOT NULL DEFAULT '0',
  `PhotoBackground` LONGBLOB NULL DEFAULT NULL,
  `DescriptionTravel` VARCHAR(100) CHARACTER SET 'utf8' NOT NULL DEFAULT 'Description Trip',
  `CreatorTrip` INT NOT NULL,
  `Condiviso` TINYINT NOT NULL DEFAULT '0',
  `dataCreazione` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`idTrip`, `CreatorTrip`),
  UNIQUE INDEX `idViaggi_UNIQUE` (`idTrip` ASC) VISIBLE,
  INDEX `fk_Trip_user_idx` (`CreatorTrip` ASC) VISIBLE,
  CONSTRAINT `fk_Trip_user`
    FOREIGN KEY (`CreatorTrip`)
    REFERENCES `mydb1`.`user` (`idUser`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 81
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_czech_ci;


-- -----------------------------------------------------
-- Table `mydb1`.`favorite`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`favorite` (
  `CodiceUser` INT NOT NULL,
  `CodiceTravel` INT NOT NULL,
  `CodiceCreatore` INT NOT NULL,
  PRIMARY KEY (`CodiceUser`, `CodiceTravel`, `CodiceCreatore`),
  INDEX `fk_user_has_Trip_Trip1_idx` (`CodiceTravel` ASC, `CodiceCreatore` ASC) VISIBLE,
  INDEX `fk_user_has_Trip_user1_idx` (`CodiceUser` ASC) VISIBLE,
  CONSTRAINT `fk_user_has_Trip_Trip1`
    FOREIGN KEY (`CodiceTravel` , `CodiceCreatore`)
    REFERENCES `mydb1`.`trip` (`idTrip` , `CreatorTrip`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_Trip_user1`
    FOREIGN KEY (`CodiceUser`)
    REFERENCES `mydb1`.`user` (`idUser`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_czech_ci;


-- -----------------------------------------------------
-- Table `mydb1`.`follow`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`follow` (
  `Follower` INT NOT NULL,
  `Following` INT NOT NULL,
  PRIMARY KEY (`Follower`, `Following`),
  INDEX `fk_user_has_user_user4_idx` (`Following` ASC) INVISIBLE,
  INDEX `fk_user_has_user_user3_idx` (`Follower` ASC) VISIBLE,
  CONSTRAINT `fk_user_has_user_user3`
    FOREIGN KEY (`Follower`)
    REFERENCES `mydb1`.`user` (`idUser`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_user_user4`
    FOREIGN KEY (`Following`)
    REFERENCES `mydb1`.`user` (`idUser`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_czech_ci;


-- -----------------------------------------------------
-- Table `mydb1`.`messaggio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`messaggio` (
  `idmessaggio` INT NOT NULL AUTO_INCREMENT,
  `Destinatario` INT NOT NULL,
  `Mittente` INT NOT NULL,
  `Testo` MEDIUMTEXT CHARACTER SET 'utf8' COLLATE 'utf8_czech_ci' NULL DEFAULT NULL,
  `data` TIMESTAMP(6) NOT NULL,
  `NomeViaggio` VARCHAR(30) CHARACTER SET 'utf8' COLLATE 'utf8_czech_ci' NULL DEFAULT NULL,
  `letto` INT NULL DEFAULT '0',
  PRIMARY KEY (`idmessaggio`, `Destinatario`, `Mittente`),
  UNIQUE INDEX `idmessaggio_UNIQUE` (`idmessaggio` ASC) VISIBLE,
  UNIQUE INDEX `data_UNIQUE` (`data` ASC) VISIBLE,
  INDEX `fk_messaggio_Follow1_idx` (`Mittente` ASC) VISIBLE,
  INDEX `fk_messaggio_Follow2_idx` (`Destinatario` ASC) VISIBLE,
  CONSTRAINT `fk_messaggio_Follow1`
    FOREIGN KEY (`Mittente`)
    REFERENCES `mydb1`.`user` (`idUser`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_messaggio_Follow2`
    FOREIGN KEY (`Destinatario`)
    REFERENCES `mydb1`.`user` (`idUser`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 60
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_czech_ci;


-- -----------------------------------------------------
-- Table `mydb1`.`step`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`step` (
  `Number` INT NOT NULL,
  `GroupDay` INT NOT NULL,
  `Place` VARCHAR(150) CHARACTER SET 'utf8' NOT NULL,
  `DescriptionStep` VARCHAR(300) CHARACTER SET 'utf8' NULL DEFAULT 'description step',
  `CodiceTrip` INT NOT NULL,
  `CodiceCreatore` INT NOT NULL,
  `NumberDay` INT NOT NULL,
  `PrecisionInformation` VARCHAR(500) CHARACTER SET 'utf8' COLLATE 'utf8_czech_ci' NULL DEFAULT 'informazioni piu precise',
  PRIMARY KEY (`Number`, `CodiceTrip`, `CodiceCreatore`),
  INDEX `fk_Step_Trip1_idx` (`CodiceTrip` ASC, `CodiceCreatore` ASC) VISIBLE,
  CONSTRAINT `fk_Step_Trip1`
    FOREIGN KEY (`CodiceTrip` , `CodiceCreatore`)
    REFERENCES `mydb1`.`trip` (`idTrip` , `CreatorTrip`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_czech_ci;


-- -----------------------------------------------------
-- Table `mydb1`.`photostep`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`photostep` (
  `idPhotoTable` INT NOT NULL AUTO_INCREMENT,
  `LinkPhoto` LONGBLOB NOT NULL,
  `Step_Number` INT NOT NULL,
  `CodiceViaggio` INT NOT NULL,
  `CodiceCreatoreViaggio` INT NOT NULL,
  PRIMARY KEY (`idPhotoTable`, `Step_Number`, `CodiceViaggio`, `CodiceCreatoreViaggio`),
  INDEX `fk_PhotoStep_Step1_idx` (`Step_Number` ASC, `CodiceViaggio` ASC, `CodiceCreatoreViaggio` ASC) VISIBLE,
  CONSTRAINT `fk_PhotoStep_Step1`
    FOREIGN KEY (`Step_Number` , `CodiceViaggio` , `CodiceCreatoreViaggio`)
    REFERENCES `mydb1`.`step` (`Number` , `CodiceTrip` , `CodiceCreatore`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 44
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_czech_ci;


-- -----------------------------------------------------
-- Table `mydb1`.`trip_has_city`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`trip_has_city` (
  `CodiceViaggi` INT NOT NULL,
  `CodiceCreatore` INT NOT NULL,
  `City_NameC` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL,
  `City_State` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL,
  PRIMARY KEY (`CodiceViaggi`, `CodiceCreatore`, `City_NameC`, `City_State`),
  INDEX `fk_Trip_has_City_City1_idx` (`City_NameC` ASC, `City_State` ASC) VISIBLE,
  INDEX `fk_Trip_has_City_Trip1_idx` (`CodiceViaggi` ASC, `CodiceCreatore` ASC) VISIBLE,
  CONSTRAINT `fk_Trip_has_City_City1`
    FOREIGN KEY (`City_NameC` , `City_State`)
    REFERENCES `mydb1`.`city` (`NameC` , `State`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Trip_has_City_Trip1`
    FOREIGN KEY (`CodiceViaggi` , `CodiceCreatore`)
    REFERENCES `mydb1`.`trip` (`idTrip` , `CreatorTrip`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_czech_ci;


-- -----------------------------------------------------
-- Table `mydb1`.`viaggicondivisi`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`viaggicondivisi` (
  `ChiCondivide` INT NOT NULL,
  `AchiVieneCondiviso` INT NOT NULL,
  `ViaggioCondiviso` INT NOT NULL,
  `CreatoreViaggioCondiviso` INT NOT NULL,
  PRIMARY KEY (`ChiCondivide`, `AchiVieneCondiviso`, `ViaggioCondiviso`, `CreatoreViaggioCondiviso`),
  INDEX `fk_ViaggiCondivisi_user2_idx` (`AchiVieneCondiviso` ASC) VISIBLE,
  INDEX `fk_ViaggiCondivisi_trip1_idx` (`ViaggioCondiviso` ASC, `CreatoreViaggioCondiviso` ASC) VISIBLE,
  CONSTRAINT `fk_ViaggiCondivisi_trip1`
    FOREIGN KEY (`ViaggioCondiviso` , `CreatoreViaggioCondiviso`)
    REFERENCES `mydb1`.`trip` (`idTrip` , `CreatorTrip`),
  CONSTRAINT `fk_ViaggiCondivisi_user1`
    FOREIGN KEY (`ChiCondivide`)
    REFERENCES `mydb1`.`user` (`idUser`),
  CONSTRAINT `fk_ViaggiCondivisi_user2`
    FOREIGN KEY (`AchiVieneCondiviso`)
    REFERENCES `mydb1`.`user` (`idUser`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_czech_ci;


-- -----------------------------------------------------
-- Table `mydb1`.`viaggisalvati`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb1`.`viaggisalvati` (
  `CodiceUser` INT NOT NULL,
  `CodiceTravel` INT NOT NULL,
  `CodiceCreator` INT NOT NULL,
  PRIMARY KEY (`CodiceUser`, `CodiceTravel`, `CodiceCreator`),
  INDEX `fk_user_has_Trip_Trip2_idx` (`CodiceTravel` ASC, `CodiceCreator` ASC) VISIBLE,
  INDEX `fk_user_has_Trip_user2_idx` (`CodiceUser` ASC) VISIBLE,
  CONSTRAINT `fk_user_has_Trip_Trip2`
    FOREIGN KEY (`CodiceTravel` , `CodiceCreator`)
    REFERENCES `mydb1`.`trip` (`idTrip` , `CreatorTrip`),
  CONSTRAINT `fk_user_has_Trip_user2`
    FOREIGN KEY (`CodiceUser`)
    REFERENCES `mydb1`.`user` (`idUser`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_czech_ci;

USE `mydb1`;

DELIMITER $$
USE `mydb1`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `mydb1`.`trip_BEFORE_INSERT`
BEFORE INSERT ON `mydb1`.`trip`
FOR EACH ROW
BEGIN
	set new.dataCreazione=now();
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
