USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetByPkId_UserRole]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetByPkId_UserRole]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [User].[usp_GetByPkId_UserRole] 
	@UserRoleID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[User].[UserRole].*
	FROM
		[User].[UserRole]
	WHERE
		[User].[UserRole].[UserRoleID] = @UserRoleID
	AND
		[User].[UserRole].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[UserRole].[IsActive] ELSE @IsActive END;

	-- EXEC [User].[usp_GetByPkId_UserRole] 1, NULL
	-- EXEC [User].[usp_GetByPkId_UserRole] 1, 1
	-- EXEC [User].[usp_GetByPkId_UserRole] 1, 0
END
GO
