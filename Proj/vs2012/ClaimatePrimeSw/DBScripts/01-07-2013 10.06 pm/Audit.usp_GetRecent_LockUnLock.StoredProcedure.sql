USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_GetRecent_LockUnLock]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_GetRecent_LockUnLock]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [Audit].[usp_GetRecent_LockUnLock]
	@UserID INT
AS
BEGIN
	SET NOCOUNT ON;
SELECT 
	TOP 5
	   [LockOn]
      ,[UnLockOn]
FROM
	[Audit].[LockUnLock]
WHERE 
	[Audit].[LockUnLock].[UserID] = @UserID
AND 
	[Audit].[LockUnLock].[UnLockOn] IS NOT NULL
ORDER BY
	[Audit].[LockUnLock].[UnLockOn] 
DESC;
    
    -- EXEC [Audit].[usp_GetRecent_LockUnLock] '6'
END
GO
