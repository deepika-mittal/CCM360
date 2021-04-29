
DROP PROCEDURE SP_UPDATE_POSTALADRS_OVWG
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
-- Author:		Glenn Heying
-- Modifed date: 2016 11 21
-- Description:	Update Postaladrs table for overweights

USE [StrsSolutionDB]
GO

/****** Object:  StoredProcedure [dbo].[SP_UPDATE_POSTALADRS_OVWG]    Script Date: 3/21/2017 10:44:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Glenn Heying
-- Modifed date: 2017 03 21
-- Description:	Update Postaladrs table for overweights
-- Changed to send envelopes with 4 sheets or more to overweight file

CREATE PROCEDURE [dbo].[SP_UPDATE_POSTALADRS_OVWG]
	@p_STRSBATCHDATE VARCHAR(10)
AS
BEGIN
	Declare    
	@p_STRSENVELOPEID varchar(50),
	@pCounter int	
	--select distinct STRSENVELOPEID from dbo.TAB_STRSPOSTALADRS where strsbatchdate = @p_STRSBATCHDATE and SORTCODE in('INV_RSREG','INV_SHOFF')
	Declare EnvelopeId_Cursor cursor For

	select a.STRSENVELOPEID from 
	(select sum(sheetcount) as 'totalsheets',STRSENVELOPEID from dbo.TAB_STRSPOSTALADRS  where strsbatchdate = @p_STRSBATCHDATE and SORTCODE in('INV_RSREG','INV_SHOFF')
	 group by  STRSENVELOPEID) a 
	where a.totalsheets > 3		
	set @pCounter = 0
	OPEN EnvelopeId_Cursor 
	FETCH NEXT FROM EnvelopeId_Cursor INTO @p_STRSENVELOPEID
	While @@Fetch_Status = 0 Begin

		if(@pCounter > 1000)
		begin
			print ('@pCounter: ')
			print ( CONVERT(varchar(10), @pCounter))
		end
		print ('******************* OVERWEIGHT   ' +  @p_STRSENVELOPEID)
		update dbo.TAB_STRSPOSTALADRS set sortcode = SUBSTRING(sortcode, 1, 6)+'OVWG' where STRSENVELOPEID = @p_STRSENVELOPEID
	FETCH NEXT FROM EnvelopeId_Cursor INTO @p_STRSENVELOPEID

	End 
	Close EnvelopeId_Cursor
	Deallocate EnvelopeId_Cursor
END

GO



GRANT EXECUTE ON SP_UPDATE_POSTALADRS_OVWG TO StrsSolutionDB
GO