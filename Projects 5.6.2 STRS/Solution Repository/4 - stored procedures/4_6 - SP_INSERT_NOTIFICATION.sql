
DROP PROCEDURE SP_INSERT_NOTIFICATION
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
-- Author:		don orazulume
-- Create date: 2016 02 18
-- Description:	insert notifications
-- =============================================
CREATE PROCEDURE SP_INSERT_NOTIFICATION
	-- Add the parameters for the stored procedure here
	@p_STRNOTIFICATIONID VARCHAR(20),
	@p_NOTIFICATIONTYPE VARCHAR(20),
	@p_NOTIFICATIONCLASS VARCHAR(10),
	@p_STRSJOBID INT,
	@p_BATCHDATE VARCHAR(8),
	@p_PROJECTNAME VARCHAR(40),
	@p_FUNCTIONCLASS VARCHAR(5),
	@p_FUNCTIONCNAME VARCHAR(50),
	@p_NOTIFICATION VARCHAR(500)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

    -- Insert statements for procedure here
	INSERT INTO TAB_STRSNOTIFICATIONS (
				STRNOTIFICATIONID,
				CREATEDATETIME,		-- dynamic
				NOTIFICATIONTYPE,
				NOTIFICATIONCLASS, 
				STRSJOBID,
				BATCHDATE,
				PROJECTNAME,
				FUNCTIONCLASS,
				FUNCTIONCNAME,
				NOTIFICATION
				)       
			VALUES (
				@p_STRNOTIFICATIONID,
				SYSDATETIME(),   	-- dynamic
				@p_NOTIFICATIONTYPE,
				@p_NOTIFICATIONCLASS,   
				@p_STRSJOBID,
				@p_BATCHDATE,
				@p_PROJECTNAME,
				@p_FUNCTIONCLASS,
				@p_FUNCTIONCNAME,
				@p_NOTIFICATION
				)  
END
GO

GRANT EXECUTE ON SP_INSERT_NOTIFICATION TO StrsSolutionDB
GO