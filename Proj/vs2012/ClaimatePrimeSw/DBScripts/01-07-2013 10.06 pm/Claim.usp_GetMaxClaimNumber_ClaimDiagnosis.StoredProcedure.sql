USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetMaxClaimNumber_ClaimDiagnosis]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_GetMaxClaimNumber_ClaimDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetMaxClaimNumber_ClaimDiagnosis] 
	
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_TMP TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [MAX_CLAIM_NO] BIGINT NOT NULL
	);
	
	INSERT INTO 
		@TBL_TMP 
	SELECT
		MAX ([Claim].[ClaimDiagnosis].[ClaimNumber]) AS [MAX_CLAIM_NO]
	FROM
		[Claim].[ClaimDiagnosis];
	
	SELECT * FROM @TBL_TMP;
	-- EXEC [Claim].[usp_GetMaxClaimNumber_ClaimDiagnosis] 
	-- EXEC [Claim].[usp_GetMaxClaimNumber_ClaimDiagnosis] 
END
GO
