USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetByPkId_Clinic]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetByPkId_Clinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Billing].[usp_GetByPkId_Clinic] 
	@ClinicID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Billing].[Clinic].*
	FROM
		[Billing].[Clinic]
	WHERE
		[Billing].[Clinic].[ClinicID] = @ClinicID
	AND
		[Billing].[Clinic].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[Clinic].[IsActive] ELSE @IsActive END;

	-- EXEC [Billing].[usp_GetByPkId_Clinic] 1, NULL
	-- EXEC [Billing].[usp_GetByPkId_Clinic] 1, 1
	-- EXEC [Billing].[usp_GetByPkId_Clinic] 1, 0
END
GO
