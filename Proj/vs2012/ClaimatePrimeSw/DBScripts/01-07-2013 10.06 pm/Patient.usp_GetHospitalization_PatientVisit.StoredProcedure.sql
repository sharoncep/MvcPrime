USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetHospitalization_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetHospitalization_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetHospitalization_PatientVisit]
	@PatientHospitalizationID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT
	[Patient].[PatientHospitalization].[PatientHospitalizationID]
	, [Billing].[FacilityDone].[FacilityDoneID]
	, [Billing].[FacilityDone].[FacilityDoneName] + ' ['+[Billing].[FacilityDone].[FacilityDoneCode]+']' AS [NAME_CODE]
FROM
	[Patient].[PatientHospitalization]
INNER JOIN
	[Billing].[FacilityDone]
ON	
	[Billing].[FacilityDone].[FacilityDoneID] = [Patient].[PatientHospitalization].[FacilityDoneHospitalID]
WHERE
	[Patient].[PatientHospitalization].[PatientHospitalizationID] = @PatientHospitalizationID


--[Patient].[usp_GetHospitalization_PatientVisit] @PatientHospitalizationID = 3

END
GO
