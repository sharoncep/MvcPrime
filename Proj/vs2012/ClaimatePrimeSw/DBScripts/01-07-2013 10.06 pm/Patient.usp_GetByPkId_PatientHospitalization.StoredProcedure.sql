USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetByPkId_PatientHospitalization]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetByPkId_PatientHospitalization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Patient].[usp_GetByPkId_PatientHospitalization] 
	@PatientHospitalizationID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Patient].[PatientHospitalization].*
	FROM
		[Patient].[PatientHospitalization]
	WHERE
		[Patient].[PatientHospitalization].[PatientHospitalizationID] = @PatientHospitalizationID
	AND
		[Patient].[PatientHospitalization].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientHospitalization].[IsActive] ELSE @IsActive END;

	-- EXEC [Patient].[usp_GetByPkId_PatientHospitalization] 1, NULL
	-- EXEC [Patient].[usp_GetByPkId_PatientHospitalization] 1, 1
	-- EXEC [Patient].[usp_GetByPkId_PatientHospitalization] 1, 0
END
GO
