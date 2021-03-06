USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetMaxID_ClaimProcess]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_GetMaxID_ClaimProcess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Claim].[usp_GetMaxID_ClaimProcess] 
	@PatientVisitID	BIGINT
	, @ClaimStatusID TINYINT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		ISNULL(MAX([Claim].[ClaimProcess].[ClaimProcessID]), 0) AS [MAX_ID]
	FROM
		[Claim].[ClaimProcess]
	WHERE
		@PatientVisitID = [Claim].[ClaimProcess].[PatientVisitID]
	AND
		[Claim].[ClaimProcess].[ClaimStatusID] = @ClaimStatusID
	AND
		[Claim].[ClaimProcess].[IsActive] = 1

	-- [Claim].[usp_GetMaxID_ClaimProcess]  4337 , 22
END
GO
