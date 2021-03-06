USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetFacilityDoneNameByID_Clinic]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetFacilityDoneNameByID_Clinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Billing].[usp_GetFacilityDoneNameByID_Clinic] 
	@ClinicID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [NAME_CODE] NVARCHAR(200) NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		([Billing].[Clinic].[ClinicName] + ' [' +[Billing].[Clinic].[ClinicCode] + ']') AS [NAME_CODE]
	FROM
		[Billing].[Clinic]
	WHERE
		@ClinicID = [Billing].[Clinic].[ClinicID]
	AND
		[Billing].[Clinic].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[Clinic].[IsActive] ELSE @IsActive END;

	SELECT * FROM @TBL_RES;
	
	-- EXEC [Billing].[usp_GetFacilityDoneNameByID_Clinic] 1, NULL
	
END
GO
