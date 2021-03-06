USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_GetByPkId_Diagnosis]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_GetByPkId_Diagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Diagnosis].[usp_GetByPkId_Diagnosis] 
	@DiagnosisID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Diagnosis].[Diagnosis].*
	FROM
		[Diagnosis].[Diagnosis]
	WHERE
		[Diagnosis].[Diagnosis].[DiagnosisID] = @DiagnosisID
	AND
		[Diagnosis].[Diagnosis].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Diagnosis].[Diagnosis].[IsActive] ELSE @IsActive END;

	-- EXEC [Diagnosis].[usp_GetByPkId_Diagnosis] 1, NULL
	-- EXEC [Diagnosis].[usp_GetByPkId_Diagnosis] 1, 1
	-- EXEC [Diagnosis].[usp_GetByPkId_Diagnosis] 1, 0
END
GO
