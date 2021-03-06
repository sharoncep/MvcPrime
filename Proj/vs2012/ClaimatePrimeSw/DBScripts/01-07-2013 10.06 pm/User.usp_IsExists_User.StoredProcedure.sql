USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_IsExists_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_IsExists_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [User].[usp_IsExists_User]
	@UserName NVARCHAR(15)
	, @Password NVARCHAR(200)
	, @Email NVARCHAR(256)
	, @LastName NVARCHAR(150)
	, @MiddleName NVARCHAR(50) = NULL
	, @FirstName NVARCHAR(150)
	, @PhoneNumber NVARCHAR(13)
	, @ManagerID INT = NULL
	, @PhotoRelPath NVARCHAR(350) = NULL
	, @AlertChangePassword BIT
	, @Comment NVARCHAR(4000) = NULL
	, @IsBlocked BIT
	, @UserID	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @UserID = [User].[ufn_IsExists_User] (@UserName, @Password, @Email, @LastName, @MiddleName, @FirstName, @PhoneNumber, @ManagerID, @PhotoRelPath, @AlertChangePassword, @Comment, @IsBlocked, 0);
END
GO
