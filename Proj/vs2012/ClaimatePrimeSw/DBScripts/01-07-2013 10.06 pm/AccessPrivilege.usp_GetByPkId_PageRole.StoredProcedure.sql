USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [AccessPrivilege].[usp_GetByPkId_PageRole]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [AccessPrivilege].[usp_GetByPkId_PageRole]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [AccessPrivilege].[usp_GetByPkId_PageRole] 
	@PageRoleID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[AccessPrivilege].[PageRole].*
	FROM
		[AccessPrivilege].[PageRole]
	WHERE
		[AccessPrivilege].[PageRole].[PageRoleID] = @PageRoleID
	AND
		[AccessPrivilege].[PageRole].[IsActive] = CASE WHEN @IsActive IS NULL THEN [AccessPrivilege].[PageRole].[IsActive] ELSE @IsActive END;

	-- EXEC [AccessPrivilege].[usp_GetByPkId_PageRole] 1, NULL
	-- EXEC [AccessPrivilege].[usp_GetByPkId_PageRole] 1, 1
	-- EXEC [AccessPrivilege].[usp_GetByPkId_PageRole] 1, 0
END
GO
