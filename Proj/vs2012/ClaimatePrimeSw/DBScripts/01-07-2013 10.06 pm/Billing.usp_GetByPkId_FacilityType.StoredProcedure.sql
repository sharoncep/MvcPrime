USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetByPkId_FacilityType]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetByPkId_FacilityType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Billing].[usp_GetByPkId_FacilityType] 
	@FacilityTypeID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Billing].[FacilityType].*
	FROM
		[Billing].[FacilityType]
	WHERE
		[Billing].[FacilityType].[FacilityTypeID] = @FacilityTypeID
	AND
		[Billing].[FacilityType].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[FacilityType].[IsActive] ELSE @IsActive END;

	-- EXEC [Billing].[usp_GetByPkId_FacilityType] 1, NULL
	-- EXEC [Billing].[usp_GetByPkId_FacilityType] 1, 1
	-- EXEC [Billing].[usp_GetByPkId_FacilityType] 1, 0
END
GO
