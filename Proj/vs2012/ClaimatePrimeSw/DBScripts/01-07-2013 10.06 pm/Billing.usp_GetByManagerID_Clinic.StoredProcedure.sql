USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetByManagerID_Clinic]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetByManagerID_Clinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Billing].[usp_GetByManagerID_Clinic]
	@ManagerID	int 
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    SELECT *
		
	FROM
		 [Billing].[Clinic]
	--WHERE
	
	-- [Billing].[Clinic].[ManagerID] = @ManagerID
	

	
	-- EXEC [Billing].[usp_GetByManagerID_Clinic] @ManagerID = 15
END
GO
