USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_IsExists_ClaimDiagnosis]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_IsExists_ClaimDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Claim].[usp_IsExists_ClaimDiagnosis]
	@PatientVisitID BIGINT
	, @DiagnosisID INT
	, @ClaimNumber BIGINT
	, @Comment NVARCHAR(4000) = NULL
	, @ClaimDiagnosisID	BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @ClaimDiagnosisID = [Claim].[ufn_IsExists_ClaimDiagnosis] (@PatientVisitID, @DiagnosisID, @ClaimNumber, @Comment, 0);
END
GO
