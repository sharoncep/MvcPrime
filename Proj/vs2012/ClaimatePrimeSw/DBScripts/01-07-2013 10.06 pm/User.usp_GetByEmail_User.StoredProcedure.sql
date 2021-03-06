USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetByEmail_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetByEmail_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User].[usp_GetByEmail_User]
	@Email varchar(200)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[User].[User].*
	FROM
		[User].[User]
	WHERE
		[User].[Email] = @Email
		and
		[User].[User].[IsActive] = 1;
			
	-- EXEC [User].[usp_GetAll_User] NULL
	-- EXEC [User].[usp_GetAll_User] 1
	-- EXEC [User].[usp_GetAll_User] 0
END
GO
