USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_GetByPkId_InsuranceType]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_GetByPkId_InsuranceType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Insurance].[usp_GetByPkId_InsuranceType] 
	@InsuranceTypeID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Insurance].[InsuranceType].*
	FROM
		[Insurance].[InsuranceType]
	WHERE
		[Insurance].[InsuranceType].[InsuranceTypeID] = @InsuranceTypeID
	AND
		[Insurance].[InsuranceType].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Insurance].[InsuranceType].[IsActive] ELSE @IsActive END;

	-- EXEC [Insurance].[usp_GetByPkId_InsuranceType] 1, NULL
	-- EXEC [Insurance].[usp_GetByPkId_InsuranceType] 1, 1
	-- EXEC [Insurance].[usp_GetByPkId_InsuranceType] 1, 0
END
GO
