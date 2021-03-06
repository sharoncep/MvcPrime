USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetByPkId_PatientDocument]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetByPkId_PatientDocument]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Patient].[usp_GetByPkId_PatientDocument] 
	@PatientDocumentID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Patient].[PatientDocument].*
	FROM
		[Patient].[PatientDocument]
	WHERE
		[Patient].[PatientDocument].[PatientDocumentID] = @PatientDocumentID
	AND
		[Patient].[PatientDocument].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientDocument].[IsActive] ELSE @IsActive END;

	-- EXEC [Patient].[usp_GetByPkId_PatientDocument] 1, NULL
	-- EXEC [Patient].[usp_GetByPkId_PatientDocument] 1, 1
	-- EXEC [Patient].[usp_GetByPkId_PatientDocument] 1, 0
END
GO
