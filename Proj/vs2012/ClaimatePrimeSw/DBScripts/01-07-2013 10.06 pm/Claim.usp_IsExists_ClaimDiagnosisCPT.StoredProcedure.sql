USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_IsExists_ClaimDiagnosisCPT]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_IsExists_ClaimDiagnosisCPT]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Claim].[usp_IsExists_ClaimDiagnosisCPT]
	@ClaimDiagnosisID BIGINT
	, @CPTID INT
	, @FacilityTypeID TINYINT
	, @Unit INT
	, @ChargePerUnit DECIMAL
	, @CPTDOS DATE
	, @Comment NVARCHAR(4000) = NULL
	, @ClaimDiagnosisCPTID	BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @ClaimDiagnosisCPTID = [Claim].[ufn_IsExists_ClaimDiagnosisCPT] (@ClaimDiagnosisID, @CPTID, @FacilityTypeID, @Unit, @ChargePerUnit, @CPTDOS, @Comment, 0);
END
GO
