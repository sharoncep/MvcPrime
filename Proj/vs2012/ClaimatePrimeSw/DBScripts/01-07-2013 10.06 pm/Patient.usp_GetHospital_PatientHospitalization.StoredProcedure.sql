USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetHospital_PatientHospitalization]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetHospital_PatientHospitalization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetHospital_PatientHospitalization]
	@PatientID	BIGINT
	, @DOS DATETIME
	, @IsActive	BIT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT
	[Patient].[PatientHospitalization].[PatientHospitalizationID], [Billing].[FacilityDone].[FacilityDoneName] + ' ['+[Billing].[FacilityDone].[FacilityDoneCode]+']' AS [NAME_CODE]
FROM
	[Patient].[PatientHospitalization]
INNER JOIN
	[Patient].[PatientVisit]
ON
	[Patient].[PatientHospitalization].[PatientID] = [Patient].[PatientVisit].[PatientID]
INNER JOIN
	[Billing].[FacilityDone]
ON	
	[Billing].[FacilityDone].[FacilityDoneID] = [Patient].[PatientHospitalization].[FacilityDoneHospitalID]
WHERE

	[Patient].[PatientVisit].[PatientID] = @PatientID
AND
	[Patient].[PatientVisit].[DOS] = @DOS
AND
(
	(
		DATEDIFF(DAY, [Patient].[PatientHospitalization].[AdmittedOn], [Patient].[PatientVisit].[DOS]) > -1
		AND
		[Patient].[PatientHospitalization].[DischargedOn] IS NULL
	)
	OR
	(
		[Patient].[PatientVisit].[DOS] 
		BETWEEN 
		[Patient].[PatientHospitalization].[AdmittedOn] AND  [Patient].[PatientHospitalization].[DischargedOn]
	)
)


--[Patient].[usp_GetHospital_PatientHospitalization] @PatientID = 2, @DOS = '2013-03-20'

END
GO
