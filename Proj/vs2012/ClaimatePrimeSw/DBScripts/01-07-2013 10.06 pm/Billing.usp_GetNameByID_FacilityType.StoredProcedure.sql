USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetNameByID_FacilityType]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetNameByID_FacilityType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Billing].[usp_GetNameByID_FacilityType] 
	@FacilityTypeID	BIGINT
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
		([Billing].[FacilityType].[FacilityTypeName] + ' [' +[Billing].[FacilityType].[FacilityTypeCode] + ']') AS [NAME_CODE]
	FROM
		[Billing].[FacilityType]
	WHERE
		@FacilityTypeID = [Billing].[FacilityType].[FacilityTypeID]
	AND
		[Billing].[FacilityType].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[FacilityType].[IsActive] ELSE @IsActive END;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Billing].[usp_GetNameByID_FacilityType]  1, NULL
	
END
GO
