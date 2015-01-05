UPDATE [Patient].[PatientVisit] 
SET [Patient].[PatientVisit].[Comment] = 'Sys Gen : ' + [Patient].[PatientVisit].[Comment]
WHERE [Patient].[PatientVisit].[Comment] LIKE 'Status changed by automated job services on%';

UPDATE [Claim].[ClaimProcess]
SET [Claim].[ClaimProcess].[Comment] = 'Sys Gen : ' + [Claim].[ClaimProcess].[Comment]
WHERE [Claim].[ClaimProcess].[Comment] LIKE 'Status changed by automated job services on%';
