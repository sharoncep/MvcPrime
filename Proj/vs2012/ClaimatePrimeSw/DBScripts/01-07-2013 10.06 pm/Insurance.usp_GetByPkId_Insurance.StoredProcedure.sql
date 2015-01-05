USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_GetByPkId_Insurance]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_GetByPkId_Insurance]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Insurance].[usp_GetByPkId_Insurance] 
	@InsuranceID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Insurance].[Insurance].*
	FROM
		[Insurance].[Insurance]
	WHERE
		[Insurance].[Insurance].[InsuranceID] = @InsuranceID
	AND
		[Insurance].[Insurance].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Insurance].[Insurance].[IsActive] ELSE @IsActive END;

	-- EXEC [Insurance].[usp_GetByPkId_Insurance] 1, NULL
	-- EXEC [Insurance].[usp_GetByPkId_Insurance] 1, 1
	-- EXEC [Insurance].[usp_GetByPkId_Insurance] 1, 0
END
GO
