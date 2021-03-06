USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetByManagerID_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetByManagerID_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User].[usp_GetByManagerID_User]
	
	 @SelManagerID INT 
	
AS
BEGIN

SELECT 
	(LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) AS [USER_DISP_NAME]
	, *
 FROM [User].[User] where [USER].[ManagerID] = @SelManagerID
	
	
END

-- EXEC [User].[usp_GetByManagerID_User] @SelManagerID = 48
GO
