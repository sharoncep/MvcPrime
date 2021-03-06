USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_GetRecent_LogInTrial]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_GetRecent_LogInTrial]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [Audit].[usp_GetRecent_LogInTrial]
	@UserName NVARCHAR(128) 
AS
BEGIN
	SET NOCOUNT ON;
SELECT 
	TOP 5
	   [TrialOn]
      ,[ClientHostIPAddress]
FROM
	[Audit].[LogInTrial]
WHERE 
	[Audit].[LogInTrial].[TrialUserName] = @UserName
AND 
	[Audit].[LogInTrial].[IsSuccess] = 0
ORDER BY
	[Audit].[LogInTrial].[TrialOn]
DESC;
    
    -- EXEC [Audit].[usp_GetRecent_LogInTrial] 'sharon.joseph@in.arivameddata.com'
END
GO
