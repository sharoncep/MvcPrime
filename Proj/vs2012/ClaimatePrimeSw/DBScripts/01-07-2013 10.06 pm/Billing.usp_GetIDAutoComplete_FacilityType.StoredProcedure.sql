USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetIDAutoComplete_FacilityType]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetIDAutoComplete_FacilityType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Billing].[usp_GetIDAutoComplete_FacilityType] 
	@FacilityTypeCode	NVARCHAR(2)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] TINYINT NOT NULL IDENTITY (1, 1)
		, [FacilityTypeID] TINYINT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Billing].[FacilityType].[FacilityTypeID]
	FROM
		[Billing].[FacilityType]
	WHERE
		@FacilityTypeCode = [Billing].[FacilityType].[FacilityTypeCode]
	AND
		[Billing].[FacilityType].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Billing].[usp_GetIDAutoComplete_FacilityType] '00'
	
END
GO
