USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetAll_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetAll_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [User].[usp_GetAll_User] 
	@IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[User].[User].*
	FROM
		[User].[User]
	WHERE
		[User].[User].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[User].[IsActive] ELSE @IsActive END;
			
	-- EXEC [User].[usp_GetAll_User] NULL
	-- EXEC [User].[usp_GetAll_User] 1
	-- EXEC [User].[usp_GetAll_User] 0
END
GO
