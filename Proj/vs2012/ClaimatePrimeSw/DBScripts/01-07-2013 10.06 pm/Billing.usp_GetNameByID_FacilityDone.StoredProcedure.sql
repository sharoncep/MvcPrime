USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetNameByID_FacilityDone]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetNameByID_FacilityDone]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Billing].[usp_GetNameByID_FacilityDone] 
	@FacilityDoneID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;	

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [NAME_CODE] NVARCHAR(500) NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		([Billing].[FacilityDone].[FacilityDoneName] + ' [' +[Billing].[FacilityDone].[FacilityDoneCode] + ']') AS [NAME_CODE]
	FROM
		[Billing].[FacilityDone]
	WHERE
		@FacilityDoneID = [Billing].[FacilityDone].[FacilityDoneID]
	AND
		[Billing].[FacilityDone].[IsActive]=1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Billing].[usp_GetNameByID_FacilityDone] 1, NULL
	
END
GO
