USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetBySearch_UserRole]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetBySearch_UserRole]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User].[usp_GetBySearch_UserRole]
	@WebAdminRoleID TINYINT = 1
	, @ManagerRoleID TINYINT = 2
	, @EARoleID TINYINT = 3
	, @QARoleID TINYINT = 4
	, @BARoleID TINYINT = 5
	, @SelManagerID INT = 2
	, @SearchName NVARCHAR(150) = NULL
	, @StartBy NVARCHAR(1) = NULL
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
	, @IsActive BIT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @SearchName IS NULL
	BEGIN
		SET @SearchName = '';
	END
	
	IF @StartBy IS NULL
	BEGIN
		SET @StartBy = '';
	END
	
	DECLARE @TBL_ANS TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [USER_ID] [INT] NOT NULL PRIMARY KEY
		, [USER_DISP_NAME] [NVARCHAR](500) NOT NULL
		, [USER_EMAIL] [NVARCHAR](256) NOT NULL
		, [USER_IS_ACTIVE] [BIT] NOT NULL
		--
		, [USER_ROLE_ID_EA] [BIGINT] NOT NULL DEFAULT(0)
		, [USER_ROLE_IS_ACTIVE_EA] [BIT] NOT NULL DEFAULT(0)
		--
		, [USER_ROLE_ID_QA] [BIGINT] NOT NULL DEFAULT(0)
		, [USER_ROLE_IS_ACTIVE_QA] [BIT] NOT NULL DEFAULT(0)
		--
		, [USER_ROLE_ID_BA] [BIGINT] NOT NULL DEFAULT(0)
		, [USER_ROLE_IS_ACTIVE_BA] [BIT] NOT NULL DEFAULT(0)
	);
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
		INSERT INTO
			@SEARCH_TMP
			(
				[PK_ID]
				, [ROW_NUM]
			)
		SELECT
			[User].[User].[UserID]
			, ROW_NUMBER() OVER (
				ORDER BY
							
					CASE WHEN @OrderByField = 'Name' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) END ASC,
					CASE WHEN @orderByField = 'Name' AND @orderByDirection = 'D' THEN (LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) END DESC,
					
					CASE WHEN @OrderByField = 'Email' AND @OrderByDirection = 'A' THEN [User].[User].[Email] END ASC,
					CASE WHEN @orderByField = 'Email' AND @orderByDirection = 'D' THEN [User].[User].[Email] END DESC,
					
					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [User].[User].[LastModifiedOn] END ASC,
					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [User].[User].[LastModifiedOn] END DESC
					
				) AS ROW_NUM
		FROM
			[User].[User]
		WHERE
			[User].[User].[LastName] LIKE @StartBy + '%'
		AND
		(
			[User].[User].[LastName] LIKE '%' + @SearchName + '%'
		OR
			[User].[User].[FirstName] LIKE '%' + @SearchName + '%'
		OR
			(
				[User].[User].[MiddleName] IS NOT NULL
			AND
				[User].[User].[MiddleName] LIKE '%' + @SearchName + '%'
			)
		OR
			[User].[User].[Email] LIKE '%' + @SearchName + '%'
		)
		AND
			[User].[User].[UserID] NOT IN
			(
				SELECT
					[User].[UserRole].[UserID]
				FROM
					[User].[UserRole]
				WHERE
					[User].[UserRole].[RoleID] IN (@WebAdminRoleID, @ManagerRoleID)
				AND
					[User].[UserRole].[IsActive] = 1
			)
			AND
			[User].[User].[ManagerID] = @SelManagerID
		AND
			[User].[User].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[User].[IsActive] ELSE @IsActive END;
	
	
	INSERT INTO
		@TBL_ANS
		(
			[USER_ID]
			, [USER_DISP_NAME]
			, [USER_EMAIL]
			, [USER_IS_ACTIVE]
		)
	SELECT
		[T].[PK_ID] AS [USER_ID]
		, (LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) AS [USER_DISP_NAME]
		, [User].[User].[Email] AS [USER_EMAIL]
		, [User].[User].[IsActive] AS [USER_IS_ACTIVE]
	FROM
		@SEARCH_TMP T
	INNER JOIN
		[User].[User]
	ON
		[User].[User].[UserID] = [T].[PK_ID]
	ORDER BY
		[T].[ID]
	ASC;
	
	--
	UPDATE
		[T]
	SET
		[T].[USER_ROLE_ID_EA] = [U].[UserRoleID]
		, [T].[USER_ROLE_IS_ACTIVE_EA] = [U].[IsActive]
	FROM
		@TBL_ANS T
	INNER JOIN
		[User].[UserRole] U
	ON
		[U].[UserID] = [T].[USER_ID]
	WHERE
		[U].[RoleID] = @EARoleID;
	
	--
	UPDATE
		[T]
	SET
		[T].[USER_ROLE_ID_QA] = [U].[UserRoleID]
		, [T].[USER_ROLE_IS_ACTIVE_QA] = [U].[IsActive]
	FROM
		@TBL_ANS T
	INNER JOIN
		[User].[UserRole] U
	ON
		[U].[UserID] = [T].[USER_ID]
	WHERE
		[U].[RoleID] = @QARoleID;
	
	--
	UPDATE
		[T]
	SET
		[T].[USER_ROLE_ID_BA] = [U].[UserRoleID]
		, [T].[USER_ROLE_IS_ACTIVE_BA] = [U].[IsActive]
	FROM
		@TBL_ANS T
	INNER JOIN
		[User].[UserRole] U
	ON
		[U].[UserID] = [T].[USER_ID]
	WHERE
		[U].[RoleID] = @BARoleID;
	
	SELECT * FROM @TBL_ANS ORDER BY 1 ASC;
	
	-- EXEC [User].[usp_GetBySearch_UserRole] @SelManagerID = 15
END
GO
