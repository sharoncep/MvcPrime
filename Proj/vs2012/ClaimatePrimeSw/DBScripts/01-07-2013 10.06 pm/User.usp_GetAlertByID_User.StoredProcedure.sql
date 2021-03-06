USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetAlertByID_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetAlertByID_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [User].[usp_GetAlertByID_User] 
	@UserID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [ALERT_CHANGE_PASSWORD] BIT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[User].[User].[AlertChangePassword]
	FROM
		[User].[User]
	WHERE
		@UserID = [User].[User].[UserID]
	AND
		[User].[User].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[User].[IsActive] ELSE @IsActive END;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [User].[usp_GetAlertById_User] 1, NULL
	-- EXEC [User].[usp_GetAlertById_User] 1, 1
	-- EXEC [User].[usp_GetAlertById_User] 1, 0
END
GO
