USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetIDAutoComplete_FacilityDone]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetIDAutoComplete_FacilityDone]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Billing].[usp_GetIDAutoComplete_FacilityDone] 
	@FacilityDoneCode	nvarchar(5)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [FACILITY_DONE_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Billing].[FacilityDone].[FacilityDoneID]
	FROM
		[Billing].[FacilityDone]
	WHERE
		@FacilityDoneCode = [Billing].[FacilityDone].[FacilityDoneCode]
	AND
		[Billing].[FacilityDone].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Billing].[usp_GetIDAutoComplete_FacilityDone] 'C02'
	-- EXEC [Billing].[usp_GetByPkId_FacilityDone] 1, 1
	-- EXEC [Billing].[usp_GetByPkId_FacilityDone] 1, 0
END
GO
