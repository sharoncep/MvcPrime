USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_IsExists_PatientHospitalization]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_IsExists_PatientHospitalization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Patient].[usp_IsExists_PatientHospitalization]
	@PatientID BIGINT
	, @FacilityDoneHospitalID INT
	, @AdmittedOn DATE
	, @DischargedOn DATE = NULL
	, @Comment NVARCHAR(4000) = NULL
	, @PatientHospitalizationID	BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @PatientHospitalizationID = [Patient].[ufn_IsExists_PatientHospitalization] (@PatientID, @FacilityDoneHospitalID, @AdmittedOn, @DischargedOn, @Comment, 0);
END
GO
