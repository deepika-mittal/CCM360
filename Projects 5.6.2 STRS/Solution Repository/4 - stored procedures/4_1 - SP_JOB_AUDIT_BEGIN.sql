
DROP PROCEDURE SP_JOB_AUDIT_BEGIN
go

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
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE SP_JOB_AUDIT_BEGIN
	-- Add the parameters for the stored procedure here
	@p_STRSJOBID INT,
	@p_STRSPROJECTNAME VARCHAR(40),
	@p_STRSINPUTFILE VARCHAR(80), 
	@p_STRSINPUTCHANNEL VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

    -- Insert statements for procedure here
	INSERT INTO TAB_STRSJOBAUDIT (
				STRSJOBID,
				STRSPROJECTNAME,
				STRSINPUTFILE,
				STRSSAVEFILE,
				STRSJOBBEGIN,  -- dynamic
				STRSINPUTCHANNEL,
				STRSJOBSTATUS,
				STRSNODENAME,  -- dynamic
				STRSNODEIP
				)       
			VALUES (
				@p_STRSJOBID,
				@p_STRSPROJECTNAME,
				@p_STRSINPUTFILE,
				'not initialized',
				SYSDATETIME(),   -- dynamic
				@p_STRSINPUTCHANNEL,
				'in progress',
				HOST_NAME(),  -- dynamic
				cast(CONNECTIONPROPERTY('client_net_address') as VARCHAR)
				)  
END
GO

GRANT EXECUTE ON SP_JOB_AUDIT_BEGIN TO StrsSolutionDB
GO