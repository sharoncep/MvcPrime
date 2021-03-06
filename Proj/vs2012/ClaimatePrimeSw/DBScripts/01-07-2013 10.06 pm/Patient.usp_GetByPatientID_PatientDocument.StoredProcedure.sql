USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetByPatientID_PatientDocument]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetByPatientID_PatientDocument]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetByPatientID_PatientDocument] 
	@PatientID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Patient].[PatientDocument].*
		, [MasterData].[DocumentCategory].[DocumentCategoryName] + ' [' + [MasterData].[DocumentCategory].[DocumentCategoryCode] + ']' AS [NAME_CODE]
	FROM
		[Patient].[PatientDocument]
	INNER JOIN 
		[MasterData].[DocumentCategory]
	ON
		[MasterData].[DocumentCategory].[DocumentCategoryID] = [Patient].[PatientDocument].[DocumentCategoryID]
	WHERE	
		@PatientID = [Patient].[PatientDocument].[PatientID]
	AND
		[MasterData].[DocumentCategory].[IsActive] = CASE WHEN @IsActive IS NULL THEN [MasterData].[DocumentCategory].[IsActive] ELSE @IsActive END
	AND
		[Patient].[PatientDocument].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientDocument].[IsActive] ELSE @IsActive END
	ORDER BY
		[NAME_CODE]
	ASC,
		[Patient].[PatientDocument].[ServiceOrFromDate]
	ASC,
		[Patient].[PatientDocument].[ToDate]
	ASC;

	-- EXEC [Patient].[usp_GetByPatientID_PatientDocument] 1, NULL
	-- EXEC [Patient].[usp_GetByPatientID_PatientDocument] 1, 1
	-- EXEC [Patient].[usp_GetByPatientID_PatientDocument] 1, 0
END
GO
