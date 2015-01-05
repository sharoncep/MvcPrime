USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetByUserID_UserClinic]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetByUserID_UserClinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User].[usp_GetByUserID_UserClinic]
	@UserID	int 
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    SELECT *
		
	FROM
		 [User].[UserClinic]
	WHERE
	
	 [User].[UserClinic].[UserID] = @UserID
	

	
	-- EXEC [User].[usp_GetByUserID_UserClinic] @UserID = 15
END
GO
