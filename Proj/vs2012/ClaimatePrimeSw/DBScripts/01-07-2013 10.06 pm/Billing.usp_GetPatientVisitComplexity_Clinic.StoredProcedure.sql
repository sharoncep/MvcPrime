USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetPatientVisitComplexity_Clinic]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetPatientVisitComplexity_Clinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Billing].[usp_GetPatientVisitComplexity_Clinic] 
	@ClinicID	INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Billing].[Clinic].[ClinicID], [Billing].[Clinic].[PatientVisitComplexity]
	FROM
		[Billing].[Clinic]
	WHERE
		@ClinicID = [Billing].[Clinic].[ClinicID]
	AND
		[Billing].[Clinic].[IsActive] = 1;

	-- EXEC [Billing].[usp_GetPatientVisitComplexity_Clinic] 1
	-- EXEC [Billing].[usp_GetPatientVisitComplexity_Clinic] 1, 1
	-- EXEC [Billing].[usp_GetPatientVisitComplexity_Clinic] 1, 0
END
GO
