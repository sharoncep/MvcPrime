USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetIDAutoComplete_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetIDAutoComplete_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [User].[usp_GetIDAutoComplete_User] 
	@UserName	nvarchar(15)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [User_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[User].[User].[UserID]
	FROM
		[User].[User]
	WHERE
		@UserName = [User].[User].[UserName]
	AND
		[User].[User].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [User].[usp_GetIDAutoComplete_User] 1, NULL
	-- EXEC [User].[usp_GetByPkId_User] 1, 1
	-- EXEC [User].[usp_GetByPkId_User] 1, 0
END
GO
