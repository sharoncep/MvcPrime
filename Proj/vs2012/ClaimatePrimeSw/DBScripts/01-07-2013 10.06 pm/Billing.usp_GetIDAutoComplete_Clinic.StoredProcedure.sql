USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetIDAutoComplete_Clinic]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetIDAutoComplete_Clinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Billing].[usp_GetIDAutoComplete_Clinic] 
	@ClinicCode	nvarchar(5)
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [CLINIC_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Billing].[Clinic].[ClinicID]
	FROM
		[Billing].[Clinic]
	WHERE
		@ClinicCode = [Billing].[Clinic].[ClinicCode]
	AND
		[Billing].[Clinic].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[Clinic].[IsActive] ELSE @IsActive END;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Billing].[usp_GetIDAutoComplete_Clinic] 1, NULL
	-- EXEC [Billing].[usp_GetIDAutoComplete_Clinic] 1, 1
	-- EXEC [Billing].[usp_GetIDAutoComplete_Clinic] 1, 0
END
GO
