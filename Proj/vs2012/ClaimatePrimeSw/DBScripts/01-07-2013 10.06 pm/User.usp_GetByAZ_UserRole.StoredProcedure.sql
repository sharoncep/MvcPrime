USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetByAZ_UserRole]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetByAZ_UserRole]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User].[usp_GetByAZ_UserRole]
	@WebAdminRoleID TINYINT = 1
	, @ManagerRoleID TINYINT = 2
	, @SelManagerID INT = 2
	, @SearchName NVARCHAR(450) = NULL
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
		[User].[User].[LastName]
	FROM
		[User].[User]
	WHERE
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
	
	-- [User].[usp_GetByAZ_UserRole] @SelManagerID = 15
END
GO
