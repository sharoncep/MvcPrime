DECLARE @CLINIC_CODE VARCHAR(7) = 'DR.WEL';
DECLARE @DOSFROM DATE = '20130101';
DECLARE @DOSDTO DATE = '20130905';

SELECT
	 [Patient].[Patient].[LastName] 
	,[Patient].[Patient].[FirstName] 
	,[Patient].[Patient].[ChartNumber]
	,[Patient].[Patient].[DOB]
	,[Billing].[Clinic].[ClinicName]
	,[Billing].[Clinic].[ClinicCode]
	,[Patient].[PatientVisit].[PatientVisitID] AS CaseNo
	,[Patient].[PatientVisit].[DOS]
	,[Diagnosis].[CPT].[CPTCode]
	,CAST([Claim].[ClaimDiagnosisCPT].[CreatedOn] AS DATE) as CPTReportedDate
INTO #TMP_TBL
FROM			
	[Patient].[Patient]
INNER JOIN	
	[Billing].[Clinic]		
ON
	[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
INNER JOIN
	[Patient].[PatientVisit]
ON
	[Patient].[PatientVisit].[PatientID] = 	[Patient].[Patient].[PatientID]
INNER JOIN
	[Claim].[ClaimDiagnosis]
ON
	[Claim].[ClaimDiagnosis].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
INNER JOIN
	[Claim].[ClaimDiagnosisCPT]
ON
	[Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID] = [Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
INNER JOIN
	[Diagnosis].[CPT]
ON
	[Diagnosis].[CPT].[CPTID] = [Claim].[ClaimDiagnosisCPT].[CPTID]
WHERE
     [Billing].[Clinic].[ClinicCode] = @CLINIC_CODE
AND
	[Patient].[PatientVisit].[DOS] BETWEEN @DOSFROM AND @DOSDTO
ORDER BY
	CaseNo
ASC;

SELECT * FROM #TMP_TBL;

DROP TABLE #TMP_TBL;		