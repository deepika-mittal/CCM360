
DROP PROCEDURE SP_INSERT_COCM_DETAILS
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Don Orazulume
-- Modifed date: 2016 04 11
-- Description:	Insert COCM Details
-- =============================================
CREATE PROCEDURE SP_INSERT_COCM_DETAILS
	-- Add the parameters for the stored procedure here
	@p_STRSDOCID VARCHAR(30),  
	@p_DOCUMENTTYPE VARCHAR(20),
	@p_DOCUMENTCATEGORY VARCHAR(30),
	@p_ACCOUNTNUMBER VARCHAR(15),
	@p_CUSTOMERNAME VARCHAR(50), 
	@p_CUSTOMEREMAIL VARCHAR(200),
	@p_PREMADDRESS VARCHAR(500), 
	@p_COCMDATE VARCHAR(10),
	@p_GUID VARCHAR(40),
	@p_COKEY VARCHAR(40),
	@p_CHANNEL VARCHAR(25), 
	@p_ARCHIVECOMPLETE CHAR(1), 
	@p_STRSSPOOLID VARCHAR(20),  
	@p_STRSJOBID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
		
		BEGIN
			INSERT INTO TAB_STRSCOCM (
				STRSDOCID,  
				CREATEDATETIME,
				DOCUMENTTYPE,
				DOCUMENTCATEGORY,
				ACCOUNTNUMBER,
				CUSTOMERNAME, 
				CUSTOMEREMAIL,
				PREMADDRESS, 
				COCMDATE,
				GUID,
				COKEY,
				CHANNEL, 
				ARCHIVECOMPLETE, 
				STRSSPOOLID,  
				STRSBATCHID, 
				STRSJOBID
				)       
			VALUES (
				@p_STRSDOCID, 
				SYSDATETIME(), 
				@p_DOCUMENTTYPE,
				@p_DOCUMENTCATEGORY,
				@p_ACCOUNTNUMBER,
				@p_CUSTOMERNAME, 
				@p_CUSTOMEREMAIL,
				@p_PREMADDRESS, 
				@p_COCMDATE, 
				@p_GUID,
				@p_COKEY,
				@p_CHANNEL,
				@p_ARCHIVECOMPLETE,	
				@p_STRSSPOOLID,
				'not initialized',	
				@p_STRSJOBID
				) 
		END 		
END
GO

GRANT EXECUTE ON SP_INSERT_COCM_DETAILS TO StrsSolutionDB
GO