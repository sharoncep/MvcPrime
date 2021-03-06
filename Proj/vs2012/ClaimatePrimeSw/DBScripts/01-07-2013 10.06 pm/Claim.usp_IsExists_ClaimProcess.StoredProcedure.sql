USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_IsExists_ClaimProcess]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_IsExists_ClaimProcess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Claim].[usp_IsExists_ClaimProcess]
	@PatientVisitID BIGINT
	, @ClaimStatusID TINYINT
	, @AssignedTo INT = NULL
	, @StatusStartDate DATETIME
	, @StatusEndDate DATETIME
	, @StartEndMins BIGINT
	, @LogOutLogInMins BIGINT
	, @LockUnLockMins BIGINT
	, @DurationMins BIGINT
	, @Comment NVARCHAR(4000)
	, @ClaimProcessID	BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @ClaimProcessID = [Claim].[ufn_IsExists_ClaimProcess] (@PatientVisitID, @ClaimStatusID, @AssignedTo, @StatusStartDate, @StatusEndDate, @StartEndMins, @LogOutLogInMins, @LockUnLockMins, @DurationMins, @Comment, 0);
END
GO
