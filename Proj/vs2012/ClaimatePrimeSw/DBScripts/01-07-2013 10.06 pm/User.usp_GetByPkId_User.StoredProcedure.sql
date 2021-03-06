USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetByPkId_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetByPkId_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [User].[usp_GetByPkId_User] 
	@UserID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[User].[User].*
	FROM
		[User].[User]
	WHERE
		[User].[User].[UserID] = @UserID
	AND
		[User].[User].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[User].[IsActive] ELSE @IsActive END;

	-- EXEC [User].[usp_GetByPkId_User] 1, NULL
	-- EXEC [User].[usp_GetByPkId_User] 1, 1
	-- EXEC [User].[usp_GetByPkId_User] 1, 0
END
GO
