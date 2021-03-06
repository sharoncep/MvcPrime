USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetByPkId_Specialty]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetByPkId_Specialty]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Billing].[usp_GetByPkId_Specialty] 
	@SpecialtyID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Billing].[Specialty].*
	FROM
		[Billing].[Specialty]
	WHERE
		[Billing].[Specialty].[SpecialtyID] = @SpecialtyID
	AND
		[Billing].[Specialty].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[Specialty].[IsActive] ELSE @IsActive END;

	-- EXEC [Billing].[usp_GetByPkId_Specialty] 1, NULL
	-- EXEC [Billing].[usp_GetByPkId_Specialty] 1, 1
	-- EXEC [Billing].[usp_GetByPkId_Specialty] 1, 0
END
GO
