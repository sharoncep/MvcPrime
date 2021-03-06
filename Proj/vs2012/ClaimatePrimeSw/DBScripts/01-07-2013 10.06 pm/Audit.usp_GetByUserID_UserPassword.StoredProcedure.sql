USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_GetByUserID_UserPassword]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_GetByUserID_UserPassword]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Audit].[usp_GetByUserID_UserPassword] 
	@UserID INT
	,@RecCnt INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [ALL_CAPS_PASSWORD] NVARCHAR(200) NOT NULL
	);
	
	INSERT INTO
		@TBL_RES
	SELECT TOP (@RecCnt)
		[Audit].[UserPassword].[AllCapsPassword]
	FROM 
		[Audit].[UserPassword]
	WHERE 
		[Audit].[UserPassword].[UserID] = @UserID
	ORDER BY
		[Audit].[UserPassword].[UserPasswordID]
	DESC;
	
	SELECT * FROM @TBL_RES;
	
	-- EXEC [Audit].[usp_GetByUserID_UserPassword] @UserID = 8, @RecCnt = 2
END
GO
