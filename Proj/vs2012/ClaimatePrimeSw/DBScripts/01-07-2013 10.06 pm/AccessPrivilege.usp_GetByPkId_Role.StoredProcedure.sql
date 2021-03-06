USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [AccessPrivilege].[usp_GetByPkId_Role]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [AccessPrivilege].[usp_GetByPkId_Role]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [AccessPrivilege].[usp_GetByPkId_Role] 
	@RoleID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[AccessPrivilege].[Role].*
	FROM
		[AccessPrivilege].[Role]
	WHERE
		[AccessPrivilege].[Role].[RoleID] = @RoleID
	AND
		[AccessPrivilege].[Role].[IsActive] = CASE WHEN @IsActive IS NULL THEN [AccessPrivilege].[Role].[IsActive] ELSE @IsActive END;

	-- EXEC [AccessPrivilege].[usp_GetByPkId_Role] 1, NULL
	-- EXEC [AccessPrivilege].[usp_GetByPkId_Role] 1, 1
	-- EXEC [AccessPrivilege].[usp_GetByPkId_Role] 1, 0
END
GO
