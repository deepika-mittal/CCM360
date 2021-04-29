
drop TABLE EBILL_CONTROL;
drop TABLE EBILL_PREEBILL;
drop TABLE EBILL_TRIGGER;
drop TABLE EBILL_TRACKING;

CREATE TABLE EBILL_CONTROL(
FILE_NAME varchar(255) NOT NULL,
PREEBILL_NUMBER varchar(255),
DOCUMENTS_NUMBER varchar(255),
TRIGGER_NUMBER varchar(255),
UPDATE_datetime datetime NOT NULL DEFAULT GETDATE(),
PROCESSED varchar(255))
;

CREATE TABLE EBILL_PREEBILL(
FILE_NAME varchar(255) NOT NULL,
CONTROL_NAME varchar(255),
DOCUMENTS_NUMBER varchar(255),
UPDATE_datetime datetime NOT NULL DEFAULT GETDATE(),
PROCESSED varchar(255))
;

CREATE TABLE EBILL_TRIGGER(
FILE_NAME varchar(255) NOT NULL,
CONTROL_NAME varchar(255),
DOCUMENTS_NUMBER varchar(255),
UPDATE_datetime datetime NOT NULL DEFAULT GETDATE(),
PROCESSED varchar(255))
;

CREATE TABLE EBILL_TRACKING(
ACC_NUMBER varchar(255) NOT NULL,
BILLS_IDN varchar(255),
PROCESS_DATE date,
TYPE varchar(255),
EMAIL varchar(255),
FILE_NAME varchar(255),
STORED varchar(255),
EMAIL_SENT varchar(255),
PDF_GENERATED varchar(255),
UPDATE_datetime datetime NOT NULL DEFAULT GETDATE() )
;

DECLARE @UserName NVARCHAR(255)

SET @UserName = 'DTE_SR_USER'

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE type_desc = 'SQL_LOGIN' AND name=@UserName)
BEGIN
	exec sp_addlogin @UserName,'Mcgwire3'
END

IF NOT @UserName='sa'
BEGIN
  IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE type_desc = 'SQL_USER' AND name =@UserName)
  BEGIN
	exec sp_grantdbaccess @UserName,@UserName
	exec sp_addrolemember 'db_datareader',@UserName
	exec sp_addrolemember 'db_datawriter',@UserName
	exec sp_addrolemember 'db_ddladmin',@UserName
  END
END
GO

