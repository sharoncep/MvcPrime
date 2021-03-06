USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_IsExists_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_IsExists_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Patient].[usp_IsExists_PatientVisit]
	@PatientID BIGINT
	, @PatientHospitalizationID BIGINT = NULL
	, @DOS DATE
	, @IllnessIndicatorID TINYINT
	, @IllnessIndicatorDate DATE
	, @FacilityTypeID TINYINT
	, @FacilityDoneID INT = NULL
	, @PrimaryClaimDiagnosisID BIGINT = NULL
	, @DoctorNoteRelPath NVARCHAR(350) = NULL
	, @SuperBillRelPath NVARCHAR(350) = NULL
	, @PatientVisitDesc NVARCHAR(150) = NULL
	, @ClaimStatusID TINYINT
	, @AssignedTo INT = NULL
	, @TargetBAUserID INT = NULL
	, @TargetQAUserID INT = NULL
	, @TargetEAUserID INT = NULL
	, @PatientVisitComplexity TINYINT
	, @Comment NVARCHAR(4000)
	, @PatientVisitID	BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @PatientVisitID = [Patient].[ufn_IsExists_PatientVisit] (@PatientID, @PatientHospitalizationID, @DOS, @IllnessIndicatorID, @IllnessIndicatorDate, @FacilityTypeID, @FacilityDoneID, @PrimaryClaimDiagnosisID, @DoctorNoteRelPath, @SuperBillRelPath, @PatientVisitDesc, @ClaimStatusID, @AssignedTo, @TargetBAUserID, @TargetQAUserID, @TargetEAUserID, @PatientVisitComplexity, @Comment, 0);
END
GO
