USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetByUserID_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetByUserID_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Patient].[usp_GetByUserID_PatientVisit] 
   @RoleID tinyint
	,@UserID BIGINT = NULL
	, @IsActive	BIT = NULL
AS

IF @RoleID = 5

BEGIN
	SET NOCOUNT ON;

	SELECT
		[Patient].[PatientVisit].*
	FROM
		[Patient].[PatientVisit]
	WHERE
		@UserID = [Patient].[PatientVisit].[TargetBAUserID]
	AND
		[Patient].[PatientVisit].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientVisit].[IsActive] ELSE @IsActive END;
			
END	

ELSE IF @RoleID = 4	

BEGIN
	SET NOCOUNT ON;

	SELECT
		[Patient].[PatientVisit].*
	FROM
		[Patient].[PatientVisit]
	WHERE
		@UserID = [Patient].[PatientVisit].[TargetQAUserID]
	AND
		[Patient].[PatientVisit].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientVisit].[IsActive] ELSE @IsActive END;
			
END

ELSE IF @RoleID = 3

BEGIN
	SET NOCOUNT ON;

	SELECT
		[Patient].[PatientVisit].*
	FROM
		[Patient].[PatientVisit]
	WHERE
		@UserID = [Patient].[PatientVisit].[TargetEAUserID]
	AND
		[Patient].[PatientVisit].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientVisit].[IsActive] ELSE @IsActive END;
			

	-- EXEC [Patient].[usp_GetByUserID_PatientVisit] @RoleID = 5 , @UserID = 14
	-- EXEC [Patient].[usp_GetByUserID_PatientVisit] 1, 1
	-- EXEC [Patient].[usp_GetByUserID_PatientVisit] 1, 0
END
GO
