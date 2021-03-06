USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetByID_UserClinic]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetByID_UserClinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [User].[usp_GetByID_UserClinic] 
	@UserID INT
	, @ClinicID INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[User].[UserClinic].[UserClinicID]
		, [User].[UserClinic].[IsActive]
	FROM
		[User].[UserClinic]
		
	WHERE
		[User].[UserClinic].[UserID] =@UserID
	AND
		[User].[UserClinic].[ClinicID] = @ClinicID;
			
	-- EXEC [User].[usp_GetByID_UserClinic] @ClinicID = 2, @UserID = 16
	
END
GO
