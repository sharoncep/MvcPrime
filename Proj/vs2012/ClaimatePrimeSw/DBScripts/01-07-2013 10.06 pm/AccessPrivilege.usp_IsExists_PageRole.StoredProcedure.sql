USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [AccessPrivilege].[usp_IsExists_PageRole]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [AccessPrivilege].[usp_IsExists_PageRole]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [AccessPrivilege].[usp_IsExists_PageRole]
	@RoleID TINYINT
	, @PageID TINYINT
	, @CreatePermission BIT
	, @UpdatePermission BIT
	, @ReadPermission BIT
	, @DeletePermission BIT
	, @Comment NVARCHAR(4000) = NULL
	, @PageRoleID	BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @PageRoleID = [AccessPrivilege].[ufn_IsExists_PageRole] (@RoleID, @PageID, @CreatePermission, @UpdatePermission, @ReadPermission, @DeletePermission, @Comment, 0);
END
GO
