USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_IsExists_UserRole]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_IsExists_UserRole]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [User].[usp_IsExists_UserRole]
	@UserID INT
	, @RoleID TINYINT
	, @Comment NVARCHAR(4000) = NULL
	, @UserRoleID	BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @UserRoleID = [User].[ufn_IsExists_UserRole] (@UserID, @RoleID, @Comment, 0);
END
GO
