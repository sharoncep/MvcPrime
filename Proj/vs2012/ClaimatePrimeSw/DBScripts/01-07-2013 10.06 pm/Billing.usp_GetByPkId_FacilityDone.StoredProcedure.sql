USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetByPkId_FacilityDone]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetByPkId_FacilityDone]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Billing].[usp_GetByPkId_FacilityDone] 
	@FacilityDoneID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Billing].[FacilityDone].*
	FROM
		[Billing].[FacilityDone]
	WHERE
		[Billing].[FacilityDone].[FacilityDoneID] = @FacilityDoneID
	AND
		[Billing].[FacilityDone].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[FacilityDone].[IsActive] ELSE @IsActive END;

	-- EXEC [Billing].[usp_GetByPkId_FacilityDone] 1, NULL
	-- EXEC [Billing].[usp_GetByPkId_FacilityDone] 1, 1
	-- EXEC [Billing].[usp_GetByPkId_FacilityDone] 1, 0
END
GO
