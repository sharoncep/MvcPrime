USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetAnsi837Hosp_ClaimProcess]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetAnsi837Hosp_ClaimProcess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetAnsi837Hosp_ClaimProcess]
	@PatientHospitalizationID BIGINT
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT
		[Patient].[PatientHospitalization].[AdmittedOn]
		, [Patient].[PatientHospitalization].[DischargedOn]
		
	FROM
		[Patient].[PatientHospitalization]
	WHERE
		[Patient].[PatientHospitalization].[PatientHospitalizationID] = @PatientHospitalizationID
	AND
		[Patient].[PatientHospitalization].[IsActive] = 1
		
	-- EXEC [Claim].[usp_GetAnsi837Hosp_ClaimProcess] 1
END
GO
