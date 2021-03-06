USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetTime_Server]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [dbo].[usp_GetTime_Server]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 

CREATE PROCEDURE [dbo].[usp_GetTime_Server]
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @TBL_ANS TABLE
    (
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [CURR_DT_TM] DATETIME NOT NULL
    );
    
    INSERT INTO @TBL_ANS VALUES (GETDATE());
		
	SELECT * FROM @TBL_ANS;
	
	-- EXEC [dbo].[usp_GetTime_Server]
END
GO
