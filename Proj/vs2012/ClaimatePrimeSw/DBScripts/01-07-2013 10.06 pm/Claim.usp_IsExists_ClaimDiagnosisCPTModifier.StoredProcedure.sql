USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_IsExists_ClaimDiagnosisCPTModifier]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_IsExists_ClaimDiagnosisCPTModifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Claim].[usp_IsExists_ClaimDiagnosisCPTModifier]
	@ClaimDiagnosisCPTID BIGINT
	, @ModifierID INT
	, @ModifierLevel TINYINT
	, @Comment NVARCHAR(4000) = NULL
	, @ClaimDiagnosisCPTModifierID	BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @ClaimDiagnosisCPTModifierID = [Claim].[ufn_IsExists_ClaimDiagnosisCPTModifier] (@ClaimDiagnosisCPTID, @ModifierID, @ModifierLevel, @Comment, 0);
END
GO
