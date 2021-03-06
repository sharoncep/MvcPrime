USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetByUserName_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetByUserName_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select a record from the table based on user name

CREATE PROCEDURE [User].[usp_GetByUserName_User] 
	@UserInput  NVARCHAR(256)
	, @IsEmail	BIT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[User].[User].*
	FROM
		[User].[User]
	WHERE
		@UserInput = CASE WHEN @IsEmail = 0 THEN [User].[User].[UserName] ELSE [User].[User].[Email] END
	AND 
		[User].[User].[IsBlocked] = 0
	AND
		[User].[User].[IsActive] = 1;
			
	-- EXEC [User].[usp_GetByUserName_User] 'wasai', 0
	-- EXEC [User].[usp_GetByUserName_User] 'srs@gmail.com', 1
END
GO
