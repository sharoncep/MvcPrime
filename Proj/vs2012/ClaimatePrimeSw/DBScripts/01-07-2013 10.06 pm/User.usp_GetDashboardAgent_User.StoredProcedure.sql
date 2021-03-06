USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetDashboardAgent_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetDashboardAgent_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User].[usp_GetDashboardAgent_User]
	@StartBy		VARCHAR(1) = 'A'
	, @UserID		INT = 0
	, @IsWebAdmin	BIT = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_USER TABLE
	(
		[USER_ID] INT NOT NULL
	);
	
	IF @IsWebAdmin = 1
	BEGIN
		INSERT INTO
			@TBL_USER
		SELECT
			[User].[User].[UserID]
		FROM
			[User].[User];
	END
	ELSE
	BEGIN
		INSERT INTO
			@TBL_USER
		SELECT
			[User].[User].[UserID]
		FROM
			[User].[User]
		WHERE
			[User].[User].[ManagerID] = @UserID;
			
		INSERT INTO
			@TBL_USER
		SELECT
			@UserID;
	END
	
	IF LEN(LTRIM(RTRIM(@StartBy))) = 0
	BEGIN
		SELECT @StartBy = 'A';
	END
	
	SELECT
		[User].[User].[UserID]
		, (LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL([User].[User].[MiddleName], '')))) AS [Name]
	FROM
		[User].[User]
	WHERE
		[User].[User].[LastName] LIKE @StartBy + '%'
	AND
		[User].[User].[UserID] IN (SELECT [USER_ID] FROM @TBL_USER)
	AND
		[User].[User].[IsActive] = 1
	ORDER BY
		[Name]
	DESC;
   
	-- EXEC [User].[usp_GetDashboardAgent_User] @UserID = 101, @IsWebAdmin = 1, @StartBy = ''
	-- EXEC [User].[usp_GetDashboardAgent_User] @UserID = 48, @IsWebAdmin = 0, @StartBy = 'S'
END
GO
