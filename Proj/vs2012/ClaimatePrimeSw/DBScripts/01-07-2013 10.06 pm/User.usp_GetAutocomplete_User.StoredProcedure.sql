USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetAutocomplete_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetAutocomplete_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [User].[usp_GetAutocomplete_User] 
	@stats	NVARCHAR (150) = NULL
	, @ManagerRoleID TINYINT
AS
BEGIN
	SET NOCOUNT ON;
		
	DECLARE @TBL_ANS TABLE ([ID] INT NOT NULL IDENTITY (1, 1), [NAME_CODE] NVARCHAR(165) NOT NULL);
	
	IF @stats IS NULL
	BEGIN
		SELECT @stats = '';
	END
	ELSE
	BEGIN
		SELECT @stats = LTRIM(RTRIM(@stats));
	END
	
	DECLARE @USER_TMP TABLE
	(
		[USER_ID] INT NOT NULL
	);
	
	INSERT INTO
		@USER_TMP
	SELECT 
		[User].[UserRole].[UserID]
	FROM 
		[User].[UserRole]
	WHERE
		[User].[UserRole].[RoleID] = @ManagerRoleID
	AND
		[User].[UserRole].[IsActive] = 1;
	
	DELETE FROM
		@USER_TMP
	WHERE
		[USER_ID] IN
		(
			SELECT 
				[User].[UserRole].[UserID]
			FROM 
				[User].[UserRole]
			WHERE
				[User].[UserRole].[RoleID] < @ManagerRoleID
			AND
				[User].[UserRole].[IsActive] = 1
		)
	OR
		[USER_ID] IN
		(
			SELECT 
				[User].[User].[UserID]
			FROM 
				[User].[User]
			WHERE
				[User].[User].[ManagerID] IS NOT NULL
			AND
				[User].[User].[IsActive] = 1
		);
	
	IF LEN(@stats) = 0
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT
			([User].[User].[LastName] +[User].[User].[FirstName] + ' [' +[User].[User].[UserName] + ']') AS [NAME_CODE]
		FROM
			[User].[User]
		WHERE
			[User].[User].[UserID] IN
			(
				SELECT
					[User].[UserClinic].[UserID]
				FROM
					[User].[UserClinic]
				WHERE
					[User].[UserClinic].[IsActive] = 1
			)
		AND
			[User].[User].[UserID] IN
			(
				SELECT 
					[USER_ID]
				FROM 
					@USER_TMP
			)
		AND
			[User].[User].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;
	END
	ELSE
	BEGIN
		SELECT @stats = REPLACE(@stats, '[', '\[');
		SELECT @stats = @stats + '%';
		
		INSERT INTO
			@TBL_ANS
		SELECT TOP 10
			([User].[User].[LastName] +[User].[User].[FirstName]+ ' [' +[User].[User].[UserName] + ']') AS [NAME_CODE]
		FROM
			[User].[User]
		WHERE
			([User].[User].[LastName] +[User].[User].[FirstName]+ ' [' +[User].[User].[UserName] + ']') LIKE @stats ESCAPE '\'		
		AND
			[User].[User].[UserID] IN
			(
				SELECT
					[User].[UserClinic].[UserID]
				FROM
					[User].[UserClinic]
				WHERE
					[User].[UserClinic].[IsActive] = 1
			)
		AND
			[User].[User].[UserID] IN
			(
				SELECT 
					[USER_ID]
				FROM 
					@USER_TMP
			)
		AND
			[User].[User].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT  TOP 10
			([User].[User].[LastName] +[User].[User].[FirstName]+ ' [' +[User].[User].[UserName] + ']') AS [NAME_CODE]
			FROM
				[User].[User]
			WHERE
				[User].[User].[UserName] LIKE @stats ESCAPE '\'
			AND
				[User].[User].[UserID] IN
				(
					SELECT
						[User].[UserClinic].[UserID]
					FROM
						[User].[UserClinic]
					WHERE
						[User].[UserClinic].[IsActive] = 1
				)
			AND
				[User].[User].[UserID] IN
				(
					SELECT 
						[USER_ID]
					FROM 
						@USER_TMP
				)
			AND
				[User].[User].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			SELECT @stats = '%' + @stats;
			
			INSERT INTO
				@TBL_ANS
			SELECT 	TOP 10
				([User].[User].[LastName] +[User].[User].[FirstName]+ ' [' +[User].[User].[UserName] + ']') AS [NAME_CODE]
			FROM
				[User].[User]
			WHERE
				([User].[User].[LastName] +[User].[User].[FirstName]+ ' [' +[User].[User].[UserName] + ']') LIKE @stats ESCAPE '\'
			AND
				[User].[User].[UserID] IN
				(
					SELECT
						[User].[UserClinic].[UserID]
					FROM
						[User].[UserClinic]
					WHERE
						[User].[UserClinic].[IsActive] = 1
				)
			AND
				[User].[User].[UserID] IN
				(
					SELECT 
						[USER_ID]
					FROM 
						@USER_TMP
				)
			AND
				[User].[User].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
	END
		
	SELECT * FROM @TBL_ANS;	
	
	-- EXEC [User].[usp_GetAutoComplete_User] @stats = 'R', @ManagerRoleID = 2
	-- EXEC [User].[usp_GetAutoComplete_User] @stats = '', @ManagerRoleID = 2
END
GO
