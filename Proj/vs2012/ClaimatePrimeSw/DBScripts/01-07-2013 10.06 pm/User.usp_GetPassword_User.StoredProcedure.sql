USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetPassword_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetPassword_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [User].[usp_GetPassword_User] 	
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [NEW_PWD] NVARCHAR(10) NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT [dbo].ufn_GetPassword();
	
	SELECT * FROM @TBL_RES;
		
	-- [User].[usp_GetPassword_User]
END
GO
