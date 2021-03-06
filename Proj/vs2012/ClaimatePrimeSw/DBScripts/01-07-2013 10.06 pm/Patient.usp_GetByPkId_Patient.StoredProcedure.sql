USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetByPkId_Patient]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetByPkId_Patient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Patient].[usp_GetByPkId_Patient] 
	@PatientID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Patient].[Patient].*
	FROM
		[Patient].[Patient]
	WHERE
		[Patient].[Patient].[PatientID] = @PatientID
	AND
		[Patient].[Patient].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[Patient].[IsActive] ELSE @IsActive END;

	-- EXEC [Patient].[usp_GetByPkId_Patient] 1, NULL
	-- EXEC [Patient].[usp_GetByPkId_Patient] 1, 1
	-- EXEC [Patient].[usp_GetByPkId_Patient] 1, 0
END
GO
