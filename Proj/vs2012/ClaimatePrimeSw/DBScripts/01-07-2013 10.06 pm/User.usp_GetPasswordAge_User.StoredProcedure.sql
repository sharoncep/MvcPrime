USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetPasswordAge_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetPasswordAge_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select a record from the table based on user name

CREATE PROCEDURE [User].[usp_GetPasswordAge_User] 
	@Email NVARCHAR(256)
	, @PwdAge TINYINT	
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @UserID INT;
	DECLARE @TBL_ANS TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [IS_AGED] BIT NOT NULL
	);
	
	SELECT @UserID = [User].[User].[UserID] FROM [User].[User] WHERE [User].[User].[Email] = @Email
	
	IF @PwdAge = 0
		BEGIN
			INSERT INTO @TBL_ANS SELECT CAST('0' AS BIT) AS [IS_AGED];
		END	
	ELSE
		DECLARE @pwdDate DATETIME
		
		SELECT 
			@pwdDate = MAX([Audit].[UserPassword].[CreatedOn]) 
		FROM 
			[Audit].[UserPassword]
		WHERE
			[Audit].[UserPassword].[UserID] = @UserID;
			
		IF @pwdDate IS NULL
		BEGIN
			SELECT @pwdDate = '1900-01-01';
		END
		
		IF (DATEDIFF(DAY, @pwdDate, GETDATE()) >= @PwdAge)
		BEGIN
			INSERT INTO @TBL_ANS SELECT CAST('1' AS BIT) AS [IS_AGED];
		END
		ELSE
		BEGIN
			INSERT INTO @TBL_ANS SELECT CAST('0' AS BIT) AS [IS_AGED];
		END
		
		SELECT * FROM @TBL_ANS;
		
	-- EXEC [User].[usp_GetPasswordAge_User] @Email = 'sharon.joseph@in.arivameddata.com', @PwdAge = 5
END
GO
