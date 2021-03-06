USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetByAZ_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetByAZ_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User].[usp_GetByAZ_User]
	  @SelHighRoleID TINYINT
	, @ManagerRoleID TINYINT
	, @SelManagerID INT = NULL
	, @SearchName NVARCHAR(150) = NULL
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
    
    DECLARE @TBL_ALL TABLE
    (
		[SearchName] [nvarchar](40) NULL
    );
    
    DECLARE @TBL_AZ TABLE
    (
		[AZ] [varchar](1) PRIMARY KEY NOT NULL,
		[AZ_COUNT] INT NOT NULL
    );
    
    INSERT INTO
		@TBL_ALL
	SELECT
		(LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], ''))))
	FROM
		[User].[User]
	WHERE
	(
			[User].[User].[Email] LIKE '%' + @SearchName + '%'	    
	    OR	    
			(LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) LIKE '%' + @SearchName + '%'
	)
	AND
		(([User].[User].[ManagerID] IS NULL AND @SelManagerID IS NULL) OR ([User].[User].[ManagerID] = CASE WHEN @SelManagerID IS NULL THEN [User].[User].[ManagerID] ELSE @SelManagerID END))
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
		
	DECLARE @AZ_TMP VARCHAR(26);
	SELECT @AZ_TMP = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	DECLARE @AZ_LOOP INT;
	SELECT 	@AZ_LOOP = 1;
	DECLARE @AZ_CNT INT;
	SELECT @AZ_CNT = LEN(@AZ_TMP);
	DECLARE @AZ_CHR VARCHAR(1);
	SELECT @AZ_CHR = '';
	
	WHILE @AZ_LOOP <= @AZ_CNT
	BEGIN
		SELECT @AZ_CHR = SUBSTRING(@AZ_TMP, @AZ_LOOP, 1);
		
		INSERT INTO
			@TBL_AZ
		SELECT
			@AZ_CHR	AS [AZ]
			, COUNT(*) AS [AZ_COUNT]
		FROM
			@TBL_ALL
		WHERE
			[SearchName] LIKE @AZ_CHR + '%';
	
		SELECT @AZ_LOOP = @AZ_LOOP + 1;
	END
	
	SELECT * FROM @TBL_AZ ORDER BY 1 ASC;
	
    -- EXEC [User].[usp_GetByAZ_User] @SelHighRoleID = 3, @ManagerRoleID = 2
    -- EXEC [User].[usp_GetByAZ_User] @SelHighRoleID = 3, @ManagerRoleID = 2, @SelManagerID = 48
    -- EXEC [User].[usp_GetByAZ_User] @SelHighRoleID = 2, @ManagerRoleID = 2
    -- EXEC [User].[usp_GetByAZ_User] @SelHighRoleID = 2, @ManagerRoleID = 2, @SelManagerID = 48
END
GO
