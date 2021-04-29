
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

CREATE PROCEDURE [dbo].[SP_UPDATE_POSTALADRS_OVWG]
	@p_STRSBATCHDATE VARCHAR(10)
AS
BEGIN
	Declare    
	@p_STRSENVELOPEID varchar(50),
	@pInsertWeight decimal(5,2),
	@pTotalWeight decimal(5,2),
	@pTotalSheetCount decimal(3,0),
	@pCounter int	
	--select distinct STRSENVELOPEID from dbo.TAB_STRSPOSTALADRS where strsbatchdate = @p_STRSBATCHDATE and SORTCODE in('INV_RSREG','INV_SHOFF')
	Declare EnvelopeId_Cursor cursor For

	select a.STRSENVELOPEID from 
	(select sum(sheetcount) as 'totalsheets',STRSENVELOPEID from dbo.TAB_STRSPOSTALADRS  where strsbatchdate = @p_STRSBATCHDATE and SORTCODE in('INV_RSREG','INV_SHOFF')
	 group by  STRSENVELOPEID) a 
	where a.totalsheets > 7		
	set @pCounter = 0
	OPEN EnvelopeId_Cursor 
	FETCH NEXT FROM EnvelopeId_Cursor INTO @p_STRSENVELOPEID
	While @@Fetch_Status = 0 Begin

	  
	set @pInsertWeight = (select sum(d.insertweight)  from (
	select distinct binnumber,insertweight from tab_strsinserts a,TAB_STRSPOSTALADRS b 
	where a.strsdocid = b.STRSDOCID and b.STRSENVELOPEID = @p_STRSENVELOPEID group by binnumber,insertweight) d)
	 
	set  @pTotalSheetCount= (select sum(sheetcount) from dbo.TAB_STRSPOSTALADRS where  STRSENVELOPEID = @p_STRSENVELOPEID)
	set @pCounter = (@pCounter +1)

	set @pTotalWeight = (@pInsertWeight + (@pTotalSheetCount * .2))

	--print ('envelopid: ' +  @p_STRSENVELOPEID)

	if(@pCounter > 1000)
	begin
	print ( CONVERT(varchar(10), @pCounter))
	print ('totalweight: ')
	print ( CONVERT(varchar(10), @pTotalWeight))

	end
	if(@pTotalWeight > 2)
	print ('******************* OVERWEIGHT   ' +  @p_STRSENVELOPEID)
	if(@pTotalWeight > 2)
			update dbo.TAB_STRSPOSTALADRS set sortcode = SUBSTRING(sortcode, 1, 6)+'OVWG' where STRSENVELOPEID = @p_STRSENVELOPEID
	FETCH NEXT FROM EnvelopeId_Cursor INTO @p_STRSENVELOPEID

	End 
	Close EnvelopeId_Cursor
	Deallocate EnvelopeId_Cursor
END
GO

GRANT EXECUTE ON SP_UPDATE_POSTALADRS_OVWG TO StrsSolutionDB
GO