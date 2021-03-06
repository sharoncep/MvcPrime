USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_GetRecent_LogInLogOut]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_GetRecent_LogInLogOut]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [Audit].[usp_GetRecent_LogInLogOut]
	@UserID INT
AS
BEGIN
	SET NOCOUNT ON;
SELECT 
	TOP 10 
       [LogInOn]
      ,[LogOutOn]
      ,[ClientHostIPAddress]      
FROM
	[Audit].[LogInLogOut]
WHERE 
	[Audit].[LogInLogOut].[UserID] = @UserID
AND 
	[Audit].[LogInLogOut].[LogOutOn] IS NOT NULL
ORDER BY
	[Audit].[LogInLogOut].[LogInOn]
DESC;
    
    -- EXEC [Audit].[usp_GetRecent_LogInLogOut] '1'
END
GO
