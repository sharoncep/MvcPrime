USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_GetByPkId_DiagnosisGroup]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_GetByPkId_DiagnosisGroup]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Diagnosis].[usp_GetByPkId_DiagnosisGroup] 
	@DiagnosisGroupID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Diagnosis].[DiagnosisGroup].*
	FROM
		[Diagnosis].[DiagnosisGroup]
	WHERE
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = @DiagnosisGroupID
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Diagnosis].[DiagnosisGroup].[IsActive] ELSE @IsActive END;

	-- EXEC [Diagnosis].[usp_GetByPkId_DiagnosisGroup] 1, NULL
	-- EXEC [Diagnosis].[usp_GetByPkId_DiagnosisGroup] 1, 1
	-- EXEC [Diagnosis].[usp_GetByPkId_DiagnosisGroup] 1, 0
END
GO
