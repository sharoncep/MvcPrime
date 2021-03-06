USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [AccessPrivilege].[usp_IsExists_Role]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [AccessPrivilege].[usp_IsExists_Role]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [AccessPrivilege].[usp_IsExists_Role]
	@RoleCode NVARCHAR(2)
	, @RoleName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @RoleID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @RoleID = [AccessPrivilege].[ufn_IsExists_Role] (@RoleCode, @RoleName, @Comment, 0);
END
GO
