USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetNameByID_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetNameByID_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [User].[usp_GetNameByID_User] 
	@UserID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;	

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [NAME_CODE] NVARCHAR(500) NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		((LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL([User].[User].[MiddleName], '')))) + ' [' +[User].[User].[UserName] + ']') AS [NAME_CODE]
	FROM
		[User].[User]
	WHERE
		@UserID = [User].[User].[UserID]
	AND
		[User].[User].[IsActive]=1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [User].[usp_GetNameByID_User] 1, NULL
	
END
GO
