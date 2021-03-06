USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [AccessPrivilege].[usp_GetByPage_PageRole]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [AccessPrivilege].[usp_GetByPage_PageRole]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [AccessPrivilege].[usp_GetByPage_PageRole] 
	  @RoleID TINYINT
	, @ControllerName NVARCHAR(150)
AS
BEGIN
	SET NOCOUNT ON;
	
SELECT
		 [AccessPrivilege].[Page].[PageID] 
		, [AccessPrivilege].[Page].[SessionName]
		, [AccessPrivilege].[Page].[ControllerName]
		, [AccessPrivilege].[PageRole].[PageRoleID]
		, [AccessPrivilege].[PageRole].[CreatePermission]
		, [AccessPrivilege].[PageRole].[UpdatePermission]
		, [AccessPrivilege].[PageRole].[ReadPermission]
		, [AccessPrivilege].[PageRole].[DeletePermission]
	FROM
		[AccessPrivilege].[Page] 
	INNER JOIN
		[AccessPrivilege].[PageRole] 
	ON 
		[AccessPrivilege].[Page].[PageID]  = [AccessPrivilege].[PageRole].[PageID]
	WHERE
		[AccessPrivilege].[PageRole].[RoleID] = @RoleID
	AND
		[AccessPrivilege].[Page].[ControllerName] = @ControllerName
	AND
		[AccessPrivilege].[Page].[IsActive] = 1
	AND
		[AccessPrivilege].[PageRole].[IsActive] = 1

	-- EXEC [AccessPrivilege].[usp_GetByPage_PageRole] 1, 'ClinicView'
	
END
GO
