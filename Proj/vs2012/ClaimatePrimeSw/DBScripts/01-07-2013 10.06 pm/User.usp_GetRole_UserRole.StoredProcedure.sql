USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetRole_UserRole]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetRole_UserRole]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [User].[usp_GetRole_UserRole] 
	@UserID BIGINT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT TOP 1
		[AccessPrivilege].[Role].[RoleID],
		[AccessPrivilege].[Role].[RoleName]
	FROM
		[User].[UserRole] 
	INNER JOIN
		[AccessPrivilege].[Role] 
	ON 
		[User].[UserRole].[RoleID] = [AccessPrivilege].[Role].[RoleID]
	WHERE
		[User].[UserRole].[UserID] = @UserID
	AND
		[User].[UserRole].[IsActive] = 1
	AND
		[AccessPrivilege].[Role].[IsActive] = 1
	ORDER BY
		[AccessPrivilege].[Role].[RoleID]
	ASC;
		

	-- EXEC [User].[usp_GetRole_UserRole] 1, NULL
	-- EXEC [User].[usp_GetRole_UserRole] 1, 1
	-- EXEC [User].[usp_GetRole_UserRole] 1, 0
END
GO
