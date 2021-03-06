USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetByAZDashboardAgent_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetByAZDashboardAgent_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User].[usp_GetByAZDashboardAgent_User]
	@UserID		INT = 0
	, @IsWebAdmin	BIT = 0
AS
BEGIN

	SET NOCOUNT ON;

    DECLARE @TBL_ALL TABLE
    (
		[UserName] [nvarchar](40) NULL
    );
    
    DECLARE @TBL_AZ TABLE
    (
		[AZ] [varchar](1) PRIMARY KEY NOT NULL,
		[AZ_COUNT] INT NOT NULL
    );
    
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
	
    INSERT INTO
		@TBL_ALL
	SELECT
		[User].[User].[LastName]
	FROM
		[User].[User]
	WHERE
		[User].[User].[UserID] IN (SELECT [USER_ID] FROM @TBL_USER)
	AND
		[User].[User].[IsActive] = 1
	ORDER BY
		[LastName]
	DESC;

		
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
			[UserName] LIKE @AZ_CHR + '%';
	
		SELECT @AZ_LOOP = @AZ_LOOP + 1;
	END
	
	SELECT * FROM @TBL_AZ ORDER BY 1 ASC;
	
	-- [User].[usp_GetByAZDashboardAgent_User] @UserID = 101, @IsWebAdmin = 1
	-- [User].[usp_GetByAZDashboardAgent_User] @UserID = 48, @IsWebAdmin = 0
END
GO
