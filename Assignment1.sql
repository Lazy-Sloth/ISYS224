-- MySQL Script generated by MySQL Workbench
-- Thu Sep 12 19:16:52 2019
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema 45240221
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema 45240221
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `45240221` DEFAULT CHARACTER SET utf8 ;
USE `45240221` ;

-- -----------------------------------------------------
-- Table `45240221`.`ClientContactPerson`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `45240221`.`ClientContactPerson` (
  `clientID` INT NOT NULL,
  `clientContactPerson` VARCHAR(45) NULL,
  `clientPhoneNo` INT NULL,
  PRIMARY KEY (`clientID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `45240221`.`ClientDetail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `45240221`.`ClientDetail` (
  `clientID` INT NOT NULL,
  `clientCompany` VARCHAR(45) NULL,
  `clientAddress` VARCHAR(45) NULL,
  `ClientContactPerson_clientID` INT NOT NULL,
  PRIMARY KEY (`clientID`, `ClientContactPerson_clientID`),
  INDEX `fk_Client_ClientContactPerson1_idx` (`ClientContactPerson_clientID` ASC) ,
  CONSTRAINT `fk_Client_ClientContactPerson1`
    FOREIGN KEY (`ClientContactPerson_clientID`)
    REFERENCES `45240221`.`ClientContactPerson` (`clientID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `45240221`.`Supervisor/Manager`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `45240221`.`Supervisor` (
  `staffID` INT NOT NULL,
  `Campaign_campaignID` INT NOT NULL,
  PRIMARY KEY (`staffID`, `Campaign_campaignID`),
  INDEX `fk_Supervisor_Campaign1_idx` (`Campaign_campaignID` ASC) ,
  CONSTRAINT `fk_Supervisor_Campaign1`
    FOREIGN KEY (`Campaign_campaignID`)
    REFERENCES `45240221`.`Campaign` (`campaignID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `45240221`.`Staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `45240221`.`Staff` (
  `staffID` INT NOT NULL,
  `position` VARCHAR(45) NULL,
  `staffMobileNo` INT NULL,
  `Supervisor_StaffID` INT NOT NULL,
  `ClientContactPerson_clientID` INT NOT NULL,
  PRIMARY KEY (`staffID`, `Supervisor_staffID`, `ClientContactPerson_clientID`),
  INDEX `fk_Staff_Supervisor1_idx` (`Supervisor_staffID` ASC) ,
  INDEX `fk_Staff_ClientContactPerson1_idx` (`ClientContactPerson_clientID` ASC) ,
  CONSTRAINT `fk_Staff_Supervisor1`
    FOREIGN KEY (`Supervisor_staffID`)
    REFERENCES `45240221`.`Supervisor` (`staffID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Staff_ClientContactPerson1`
    FOREIGN KEY (`ClientContactPerson_clientID`)
    REFERENCES `45240221`.`ClientContactPerson` (`clientID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `45240221`.`Campaign`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `45240221`.`Campaign` (
  `campaignID` INT NOT NULL,
  `Theme` VARCHAR(45) NULL,
  `costEstimate` VARCHAR(45) NULL,
  `finishDate` DATE NULL,
  `Staff_staffID` INT NOT NULL,
  `Staff_Supervisor_staffID` INT NOT NULL,
  PRIMARY KEY (`campaignID`, `Staff_staffID`, `Staff_Supervisor_staffID`),
  INDEX `fk_Campaign_Staff1_idx` (`Staff_staffID` ASC, `Staff_Supervisor_staffID` ASC) ,
  CONSTRAINT `fk_Campaign_Staff1`
    FOREIGN KEY (`Staff_staffID` , `Staff_Supervisor_staffID`)
    REFERENCES `45240221`.`Staff` (`staffID` , `Supervisor_staffID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `45240221`.`Advert`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `45240221`.`Advert` (
  `advertID` INT NOT NULL,
  `advertType` VARCHAR(45) NULL,
  `Campaign_campaignID` INT NOT NULL,
  PRIMARY KEY (`advertID`, `Campaign_campaignID`),
  INDEX `fk_Advert_Campaign1_idx` (`Campaign_campaignID` ASC) ,
  CONSTRAINT `fk_Advert_Campaign1`
    FOREIGN KEY (`Campaign_campaignID`)
    REFERENCES `45240221`.`Campaign` (`campaignID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `45240221`.`Studio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `45240221`.`Studio` (
  `studioID` INT NOT NULL,
  `hourlyRate` DECIMAL(2) NULL,
  PRIMARY KEY (`studioID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `45240221`.`Invoice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `45240221`.`Invoice` (
  `invoiceID` INT NOT NULL,
  `completionDate` DATE NULL,
  `actualCost` VARCHAR(45) NULL,
  `invoiceDate` DATE NULL,
  `paymentStatus` VARCHAR(45) NULL,
  `datePaid` DATE NULL,
  `Campaign_campaignID` INT NOT NULL,
  PRIMARY KEY (`invoiceID`, `Campaign_campaignID`),
  INDEX `fk_Invoice_Campaign1_idx` (`Campaign_campaignID` ASC) ,
  CONSTRAINT `fk_Invoice_Campaign1`
    FOREIGN KEY (`Campaign_campaignID`)
    REFERENCES `45240221`.`Campaign` (`campaignID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `45240221`.`Salary`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `45240221`.`Salary` (
  `salaryGrade` INT NOT NULL,
  `payRate` VARCHAR(45) NULL,
  PRIMARY KEY (`salaryGrade`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `45240221`.`holds`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `45240221`.`holds` (
  `Salary_salaryGrade` INT NOT NULL,
  `Staff_staffID` INT NOT NULL,
  PRIMARY KEY (`Salary_salaryGrade`, `Staff_staffID`),
  INDEX `fk_Salary_has_Staff_Staff1_idx` (`Staff_staffID` ASC) ,
  INDEX `fk_Salary_has_Staff_Salary1_idx` (`Salary_salaryGrade` ASC) ,
  CONSTRAINT `fk_Salary_has_Staff_Salary1`
    FOREIGN KEY (`Salary_salaryGrade`)
    REFERENCES `45240221`.`Salary` (`salaryGrade`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Salary_has_Staff_Staff1`
    FOREIGN KEY (`Staff_staffID`)
    REFERENCES `45240221`.`Staff` (`staffID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `45240221`.`Booking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `45240221`.`Booking` (
  `Advert_advertID` INT NOT NULL,
  `Advert_Campaign_campaignID` INT NOT NULL,
  `Studio_studioID` INT NOT NULL,
  `date` date NULL,
  `duration` INT NULL,
  PRIMARY KEY (`Advert_advertID`, `Advert_Campaign_campaignID`, `Studio_studioID`),
  INDEX `fk_Advert_has_Studio_Studio1_idx` (`Studio_studioID` ASC) ,
  INDEX `fk_Advert_has_Studio_Advert1_idx` (`Advert_advertID` ASC, `Advert_Campaign_campaignID` ASC) ,
  CONSTRAINT `fk_Advert_has_Studio_Advert1`
    FOREIGN KEY (`Advert_advertID` , `Advert_Campaign_campaignID`)
    REFERENCES `45240221`.`Advert` (`advertID` , `Campaign_campaignID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Advert_has_Studio_Studio1`
    FOREIGN KEY (`Studio_studioID`)
    REFERENCES `45240221`.`Studio` (`studioID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `45240221`.`empType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `45240221`.`empType` (
  `position` VARCHAR(45) NULL,
  `empType` VARCHAR(45) NULL,
  `Staff_staffID` INT NOT NULL,
  `Staff_Supervisor_staffID` INT NOT NULL,
  PRIMARY KEY (`Staff_staffID`, `Staff_Supervisor_staffID`),
  CONSTRAINT `fk_empType_Staff1`
    FOREIGN KEY (`Staff_staffID` , `Staff_Supervisor_staffID`)
    REFERENCES `45240221`.`Staff` (`staffID` , `Supervisor_staffID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `45240221`.`StaffDetail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `45240221`.`StaffDetail` (
  `staffID` INT NOT NULL,
  `staffName` VARCHAR(45) NULL,
  `Staff_staffID` INT NOT NULL,
  `Staff_Supervisor_staffID` INT NOT NULL,
  `Staff_ClientContactPerson_clientID` INT NOT NULL,
  PRIMARY KEY (`staffID`, `Staff_staffID`, `Staff_Supervisor_staffID`, `Staff_ClientContactPerson_clientID`),
  INDEX `fk_table1_Staff1_idx` (`Staff_staffID` ASC, `Staff_Supervisor_staffID` ASC, `Staff_ClientContactPerson_clientID` ASC) ,
  CONSTRAINT `fk_table1_Staff1`
    FOREIGN KEY (`Staff_staffID` , `Staff_Supervisor_staffID` , `Staff_ClientContactPerson_clientID`)
    REFERENCES `45240221`.`Staff` (`staffID` , `Supervisor_staffID` , `ClientContactPerson_clientID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

insert into Advert values ('01','websites','02');
insert into Advert values ('02','newspaper','03');
insert into Advert values ('03','magazine','01');
insert into Advert values ('02','newspaper','04');
insert into Advert values ('03','magazine','05');

insert into Booking values ('01','02','01','2019-11-10','5');
insert into Booking values ('02','03','02','2019-01-12','3');
insert into Booking values ('03','01','03','2019-09-18','4');
insert into Booking values ('02','03','04','2018-12-02','2');
insert into Booking values ('02','03','05','2018-12-20','1');

insert into Campaign values ('01','Halloween','1','2019-10-12','01','04');
insert into Campaign values ('02','New Year','2','2019-12-10','03','05');
insert into Campaign values ('03','Valentine','1','2019-01-21','01','05');
insert into Campaign values ('01','Halloween','1','2019-10-12','02','04');
insert into Campaign values ('04','Easter','1','2019-03-14','03','05');
insert into Campaign values ('05','Christmas','3','2019-12-01','02','04');

insert into ClientContactPerson values ('01', 'Robert Menzes', '1234567890');
insert into ClientContactPerson values ('02', 'Albert Nobles', '1123581321');
insert into ClientContactPerson values ('03', 'Albert Einstein', '114159265');
insert into ClientContactPerson values ('04', 'Leonhard Euler', '1271828182');
insert into ClientContactPerson values ('05', 'George Washington', '1987654321');

insert into ClientDetail values ('01','Zeus', '52 Olympus Way, Greece', '01');
insert into ClientDetail values ('02','Amaterasu', '42 Shinto Street, Tokyo', '02');
insert into ClientDetail values ('03','Hestia', '46 Hearth Avenue, Greece', '03');
insert into ClientDetail values ('04','Anubis', '1 Feather Lane, Egypt', '04');
insert into ClientDetail values ('05','Joseph', '4 Judea Drive, Rome', '05');

insert into Invoice values ('01', '2019-10-09', '3', '2019-10-10','Paid','2019-10-11','01');
insert into Invoice values ('02', '2019-12-12', '2', '2019-12-13',' Paid','2019-12-20','02');
insert into Invoice values ('03', '2019-01-15', '3', '2019-01-17','Paid','2019-01-24','03');
insert into Invoice values ('04', '2019-03-16', '1', '2019-03-18','Paid','2019-03-19','04');
insert into Invoice values ('05', '2019-12-03', '3', '2019-12-04','Paid','2019-12-08','05');

insert into Salary values ('01', '1');
insert into Salary values ('02','2');
insert into Salary values ('03','3');
insert into Salary values ('04','4');
insert into Salary values ('05','5');

insert into Staff values ('1','Technical Personnel', '1111111111','04','01');
insert into Staff values ('2', 'Actor','1111111112','04','02');
insert into Staff values ('3', 'Graphic Designer', '1111111113','05', '03');
insert into Staff values ('4', 'Director', '1111111114','4','04');
insert into Staff values ('5', 'Account Manager', '1111111115','5','05');

insert into StaffDetail values ('1','Bob', '1','04','01');
insert into StaffDetail values ('2','Jess', '2','04','02');
insert into StaffDetail values ('3','Tom', '3','05','03');
insert into StaffDetail values ('4','Eve', '4','04','04');
insert into StaffDetail values ('5','Josh', '5','05','05');

insert into Studio values ('1','1');
insert into Studio values ('2','1');
insert into Studio values ('3','1');
insert into Studio values ('4','1');
insert into Studio values ('5','1');

insert into Supervisor values ('04','01');
insert into Supervisor values ('04','05');
insert into Supervisor values ('05','02');
insert into Supervisor values ('05','04');
insert into Supervisor values ('05','03');

insert into empType values ('Technical Personnel','Full-time','01','04');
insert into empType values ('Actor','Casual','02','04');
insert into empType values ('Graphic Designer','Casual','03','05');
insert into empType values ('Direct','Full-time','04','04');
insert into empType values ('Account Manager','Full-time','05','05');

insert into holds values ('01','02');
insert into holds values ('01','03');
insert into holds values ('02','01');
insert into holds values ('03','04');
insert into holds values ('03','05');

/* Task 5 */
/* Q1 */
select campaignID, Theme, actualCost, avg(costEstimate) `AvgCostEstimate` 
	from Campaign, Invoice 
		where Campaign.campaignID=Invoice.Campaign_campaignID 
			group by campaignID, Theme, actualCost
				having avg(costEstimate) > actualCost;
                
/* Q2 */
select campaignID, count(advertID) `No of Ads` ,completionDate, finishDate
	from Campaign, Invoice,Advert 
		where Campaign.campaignID=Invoice.Campaign_campaignID=Advert.Campaign_campaignID
			group by campaignID, completionDate,finishDate
				having completionDate < finishDate;   

/* Q3 */
select staffName, empType, Staff.staffID, Campaign.Staff_Supervisor_staffID `Campaign Manager`, 
		Staff.Supervisor_StaffID `Manager`, Campaign.Staff_staffID
	from StaffDetail, empType, Campaign, Staff
		where Staff.position= empType.position and Staff.staffID=StaffDetail.staffID=Campaign.Staff_staffID
			group by staffName, empType, Staff.staffID, Campaign.Staff_Supervisor_staffID, Staff.Supervisor_StaffID, Campaign.Staff_staffID
				having empType = 'Full-Time' and Staff.staffID = Campaign.Staff_staffID and Staff.Supervisor_staffID != Campaign.Staff_Supervisor_staffID;

/* Q4 */
select campaignID, count(campaignID), holds.Salary_salaryGrade
	from Campaign, Staff, holds 
		where Campaign.Staff_staffID=Staff.StaffID=holds.Staff_staffID 
			group by campaignID, holds.Salary_salaryGrade
				having holds.Salary_salaryGrade > 2 and count(campaignID) > 2;
/* Q5 */
select Staff.staffID, empType, Staff.position,Campaign.Staff_Supervisor_staffID `SupervisorID`
	from Campaign natural join Staff natural join StaffDetail natural join empType
		where Campaign.Staff_staffID=Staff.StaffID=StaffDetail.staffID and Staff.position=empType.position
			group by StaffID, empType,Staff.position,Campaign.Staff_Supervisor_staffID
				having empType='Full-Time' and Campaign.Staff_Supervisor_staffID!=Staff.StaffID;