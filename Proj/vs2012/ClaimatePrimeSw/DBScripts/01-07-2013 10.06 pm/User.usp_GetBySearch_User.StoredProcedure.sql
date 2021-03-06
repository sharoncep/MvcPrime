USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetBySearch_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetBySearch_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User].[usp_GetBySearch_User]
	  @SelHighRoleID TINYINT
	, @ManagerRoleID TINYINT
	, @SelManagerID INT = NULL
	, @SearchName NVARCHAR(150) = NULL
	, @StartBy NVARCHAR(1) = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
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
	
	DECLARE @USER_TMP TABLE
	(
		[USER_ID] INT NOT NULL
	);
		
	IF @SelHighRoleID <= @ManagerRoleID
	BEGIN
		SELECT @SelManagerID = NULL;
	
		INSERT INTO
			@USER_TMP
		SELECT 
			[User].[UserRole].[UserID]
		FROM 
			[User].[UserRole]
		WHERE
			[User].[UserRole].[RoleID] = @SelHighRoleID
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
					[User].[UserRole].[RoleID] < @SelHighRoleID
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
					[User].[User].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[User].[IsActive] ELSE @IsActive END
			);
	END
	ELSE
	BEGIN	
		INSERT INTO
			@USER_TMP
		SELECT 
			[User].[UserRole].[UserID]
		FROM 
			[User].[UserRole]
		WHERE
			[User].[UserRole].[RoleID] >= @SelHighRoleID
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
					[User].[UserRole].[RoleID] < @SelHighRoleID
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
					[User].[User].[ManagerID] IS NULL
				AND
					[User].[User].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[User].[IsActive] ELSE @IsActive END
			);
			
		IF @SelManagerID IS NOT NULL
		BEGIN
			DELETE FROM
				@USER_TMP
			WHERE
				[USER_ID] IN
				(
					SELECT 
						[User].[User].[UserID]
					FROM 
						[User].[User]
					WHERE
						[User].[User].[ManagerID] <> @SelManagerID
					AND
						[User].[User].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[User].[IsActive] ELSE @IsActive END
				);
		END
	END
	
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
		(LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) LIKE @StartBy + '%'
	AND
	(
			[User].[User].[Email] LIKE '%' + @SearchName + '%'	    
	    OR	    
			(LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) LIKE '%' + @SearchName + '%'
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
		[User].[User].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[User].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT		
		[User].[UserID]
		, (LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) AS [Name]
		, [User].[Email]
		, [User].[IsActive]
		, [User].[User].[ManagerID]
	FROM
		[User] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [User].[UserID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [User].[usp_GetBySearch_User] @SelHighRoleID = 3, @ManagerRoleID = 2
	-- EXEC [User].[usp_GetBySearch_User] @SelHighRoleID = 3, @ManagerRoleID = 2, @SelManagerID = 48
	-- EXEC [User].[usp_GetBySearch_User] @SelHighRoleID = 2, @ManagerRoleID = 2
	-- EXEC [User].[usp_GetBySearch_User] @SelHighRoleID = 2, @ManagerRoleID = 2, @SelManagerID = 48
	
END
GO
