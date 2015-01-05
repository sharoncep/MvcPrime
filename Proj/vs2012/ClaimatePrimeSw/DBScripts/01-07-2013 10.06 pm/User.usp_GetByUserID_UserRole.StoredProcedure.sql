USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetByUserID_UserRole]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetByUserID_UserRole]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Created by sai for Assign Manager


CREATE PROCEDURE [User].[usp_GetByUserID_UserRole]
	@UserID	int 
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    SELECT *
		
	FROM
		 [User].[UserRole]
	WHERE
	
	 [User].[UserRole].[UserID] = @UserID
	

	
	-- EXEC [User].[usp_GetByUserID_UserClinic] @UserID = 15
END
GO
