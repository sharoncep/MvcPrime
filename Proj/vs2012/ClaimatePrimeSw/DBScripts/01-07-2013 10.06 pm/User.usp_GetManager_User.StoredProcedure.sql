USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetManager_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetManager_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [User].[usp_GetManager_User] 
	@IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;



DECLARE @TBL_ALL TABLE
    (
		[UserID] INT
    );
    
    	
    
    INSERT INTO @TBL_ALL
    
    

SELECT
		
 [User].[User].[UserID]
		
	FROM
		[User].[User]
		
		INNER JOIN
		[User].[UserRole]
		ON
		[User].[User].[UserID] = [User].[UserRole].[UserID]
		
		
		
WHERE
	 [User].[UserRole].[RoleID] = 2
	 
	 	ORDER BY [User].[User].[UserID] DESC
	 	
	DECLARE @TBL_NEW TABLE
    (
		[Manager] INT
    );
	 	
	 	INSERT INTO @TBL_NEW
	 	
	 	SELECT ManagerID FROM [User].[User] 
	 	INNER JOIN 
	 	@TBL_ALL 
	 	ON
	 	[USER].[ManagerID] = [@TBL_ALL].[UserID]
	 	
	SELECT TOP 1
		
		[User].[User].[UserID]
		,([User].[User].[LastName] +[User].[User].[FirstName]+ ' [' +[User].[User].[UserName] + ']') AS [NAME_CODE] FROM 
	[User].[User] 
	INNER JOIN
	@TBL_NEW
	ON
		[User].[User].[UserID] = [@TBL_NEW].[Manager]
	AND
		[User].[User].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[User].[IsActive] ELSE @IsActive END
	ORDER BY 
		[User].[User].[UserID] 
	DESC;
	 	
	 	
	 	
	 	
	 
			
	-- EXEC [User].[usp_GetManager_User] NULL
	-- EXEC [User].[usp_GetManager_User] 1
	-- EXEC [User].[usp_GetManager_User] 0
END
GO
