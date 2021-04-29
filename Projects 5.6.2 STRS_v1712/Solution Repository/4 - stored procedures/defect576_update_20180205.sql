drop function FUNC_GENERATE_ENVELOPE_ID;

CREATE FUNCTION TVF_GENERATE_ENVELOPE_ID
(	
	@sortCode varchar(10),
	@batchDate varchar(15),
	@concatAddress varchar(500)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT concat(@batchDate, '_', convert(varchar(32), hashbytes('MD5', concat(@concatAddress, @sortCode)), 2)) AS GeneratedEnvelopeId
)

ALTER PROCEDURE SP_BUNDLE_POSTALADRS
	@sortCode varchar(10),
	@batchDate varchar(15),
	@concatAddress varchar(500),
	@envelopeId varchar(50),
	@maxSheetsPerEnvelope int,
	@maxEnvelopeNumber int
AS
BEGIN
	--declare @envelopeId varchar(50) = dbo.FUNC_GENERATE_ENVELOPE_ID(@sortCode, @batchDate, @concatAddress)
	
	declare @EnvelopeGroups table(groupNumber int, docId varchar(50));


	declare PostalAddresses cursor local for select STRSDOCID, SHEETCOUNT from TAB_STRSPOSTALADRS
		where SORTCODE=@sortCode AND STRSBATCHDATE=@batchDate AND STRSCONCATADDRESS=@concatAddress
		order by SHEETCOUNT asc;


	declare @groupNumber int;
	declare @docId varchar(50);
	declare @sheetCount int;

	
	declare @sheetCounter int = 0;
	declare @envelopeCounter int = 1;

	open PostalAddresses;
	fetch next from PostalAddresses into @docId, @sheetCount;

	while @@FETCH_STATUS = 0
	begin
		if @sheetCounter > 0 and @sheetCounter + @sheetCount > @maxSheetsPerEnvelope
		begin
			set @envelopeCounter += 1;
			set @sheetCounter = 0;
		end

		if @envelopeCounter > @maxEnvelopeNumber
		begin
			--if maximum number of envelopes reached, all documents have to be bundled into single envelope
			update TAB_STRSPOSTALADRS set STRSENVELOPEID=@envelopeId where SORTCODE=@sortCode AND STRSBATCHDATE=@batchDate AND STRSCONCATADDRESS=@concatAddress;
			close PostalAddresses;
			return;
		end

		insert into @EnvelopeGroups values(@envelopeCounter, @docId);

		set @sheetCounter += @sheetCount;

		fetch next from PostalAddresses into @docId, @sheetCount;
	end

	close PostalAddresses;

	--bundle addresses into envelopes since maximum number of envelopes wasn't reached
	declare EnvelopeGroupsCursor cursor local for select groupNumber, docId from @EnvelopeGroups;
	open EnvelopeGroupsCursor;
	fetch next from EnvelopeGroupsCursor into @groupNumber, @docId;

	while @@FETCH_STATUS = 0
	begin
		update TAB_STRSPOSTALADRS set STRSENVELOPEID=concat(@envelopeId, '_', @groupNumber), STRSMULTICOUPONFLAG = 'X' where STRSDOCID=@docId;
		fetch next from EnvelopeGroupsCursor into @groupNumber, @docId;
	end
	close EnvelopeGroupsCursor;
END

ALTER PROCEDURE SP_UPDATE_POSTALADRS_ENVELOPES
 @p_STRSBATCHDATE VARCHAR(20)	
AS

BEGIN
	declare @MAX_ENVELOPE_SHEETS int = 3;
	declare @MAX_ENVELOPES int = 4;
	declare @MAX_SHEETS_PER_GROUP int = @MAX_ENVELOPES * @MAX_ENVELOPE_SHEETS;

	/*
	* Replace SORTCODE for banner
	*/
	update addr set addr.SORTCODE=sub.SORTCODE
	from TAB_STRSPOSTALADRS addr
	join (
		select a.SORTCODE, i.BANNERCOKEY from TAB_STRSPOSTALADRS a join TAB_STRSINV i on i.STRSDOCID=a.STRSDOCID where i.BANNERCOKEY is not null and i.BANNERCOKEY <> ''
	) sub on sub.BANNERCOKEY=addr.STRSDOCID
	where addr.STRSENVELOPEID = 'not initialized' and addr.STRSBATCHDATE = @p_STRSBATCHDATE;
	
	/*UPDATE addr SET addr.SORTCODE='INV_RSREG'
	FROM TAB_STRSPOSTALADRS addr
	JOIN (
		SELECT STRSDOCID docid, concat(@p_STRSBATCHDATE,'_',ROW_NUMBER() OVER (ORDER BY STRSDOCID), '_', STRSDOCID) envid FROM TAB_STRSINV WHERE BANNERCOKEY !=''
		UNION
		SELECT BANNERCOKEY, concat(@p_STRSBATCHDATE,'_',ROW_NUMBER() OVER (ORDER BY STRSDOCID), '_', STRSDOCID) FROM TAB_STRSINV WHERE BANNERCOKEY !=''
	) sub ON sub.docid=addr.STRSDOCID
	WHERE addr.STRSENVELOPEID = 'not initialized';*/
	
	
	/*
	* Covers case when group contains banner
	* Groups having banner go to single envelope
	*/

	--update addr set addr.STRSENVELOPEID=dbo.FUNC_GENERATE_ENVELOPE_ID(addr.SORTCODE, addr.STRSBATCHDATE, addr.STRSCONCATADDRESS)
	update addr set addr.SORTCODE='INV_RSREG', addr.STRSENVELOPEID=GeneratedEnvelopeId
	from TAB_STRSPOSTALADRS addr
	join (
		select SORTCODE, STRSBATCHDATE, STRSCONCATADDRESS from TAB_STRSPOSTALADRS sub_addr
		join (
			select STRSDOCID docid, 0 isBanner from TAB_STRSINV
			union
			select BANNERCOKEY, 1 from TAB_STRSINV where BANNERCOKEY is not null and BANNERCOKEY <> ''
		) sub_inv on sub_inv.docid=sub_addr.STRSDOCID
		group by SORTCODE, STRSBATCHDATE, STRSCONCATADDRESS
		having sum(sub_inv.isBanner)>0
	) sub on sub.SORTCODE=addr.SORTCODE and sub.STRSBATCHDATE=addr.STRSBATCHDATE and sub.STRSCONCATADDRESS=addr.STRSCONCATADDRESS
	cross apply dbo.TVF_GENERATE_ENVELOPE_ID('INV_RSREG', addr.STRSBATCHDATE, addr.STRSCONCATADDRESS)
	where addr.STRSENVELOPEID = 'not initialized' and addr.STRSBATCHDATE = @p_STRSBATCHDATE;


	/*
	* Covers following cases when entire group goes into single envelope:
	* - more sheets in total than maximum envelopes number, currently 12
	* - single document in group, i.e. nothing to split
	* - sheets in total less or equals to sheets per envelope
	*/
	


	--update updTbl set updTbl.STRSENVELOPEID=dbo.FUNC_GENERATE_ENVELOPE_ID(updTbl.SORTCODE, updTbl.STRSBATCHDATE, updTbl.STRSCONCATADDRESS)
	update updTbl set updTbl.STRSENVELOPEID=GeneratedEnvelopeId
	from TAB_STRSPOSTALADRS updTbl
	join (
		select SORTCODE, STRSBATCHDATE, STRSCONCATADDRESS, sum(SHEETCOUNT) sheetCount, count(STRSADRSID) addrId from TAB_STRSPOSTALADRS addr
		group by SORTCODE, STRSBATCHDATE, STRSCONCATADDRESS
		having sum(SHEETCOUNT) > @MAX_SHEETS_PER_GROUP or count(STRSADRSID) = 1 or sum(SHEETCOUNT) <= @MAX_ENVELOPE_SHEETS
	) subTbl on subTbl.SORTCODE=updTbl.SORTCODE and subTbl.STRSBATCHDATE=updTbl.STRSBATCHDATE and subTbl.STRSCONCATADDRESS=updTbl.STRSCONCATADDRESS
	cross apply dbo.TVF_GENERATE_ENVELOPE_ID(updTbl.SORTCODE, updTbl.STRSBATCHDATE, updTbl.STRSCONCATADDRESS)
	where updTbl.STRSENVELOPEID = 'not initialized' and updTbl.STRSBATCHDATE = @p_STRSBATCHDATE;



	/*
	* Covers all otherg cases
	* if envelope number less then maximum expected, document set will be bundled into envelopes
	*/


	declare @sortCode varchar(10);
	declare @batchDate varchar(15);
	declare @concatAddress varchar(500);
	declare @basicEnvId varchar(50);
	declare PostalAddresses cursor local for select SORTCODE, STRSBATCHDATE, STRSCONCATADDRESS, GeneratedEnvelopeId from TAB_STRSPOSTALADRS
		cross apply dbo.TVF_GENERATE_ENVELOPE_ID(SORTCODE, STRSBATCHDATE, STRSCONCATADDRESS)
		where STRSENVELOPEID = 'not initialized' and STRSBATCHDATE = @p_STRSBATCHDATE
		group by SORTCODE, STRSBATCHDATE, STRSCONCATADDRESS, GeneratedEnvelopeId;

	open PostalAddresses;
	fetch next from PostalAddresses into @sortCode, @batchDate, @concatAddress, @basicEnvId;

	while @@FETCH_STATUS = 0
	begin
		exec SP_BUNDLE_POSTALADRS @sortCode, @batchDate, @concatAddress, @basicEnvId, @MAX_ENVELOPE_SHEETS, @MAX_ENVELOPES;
		fetch next from PostalAddresses into @sortCode, @batchDate, @concatAddress, @basicEnvId;
	end
	close PostalAddresses;
	

	
END

