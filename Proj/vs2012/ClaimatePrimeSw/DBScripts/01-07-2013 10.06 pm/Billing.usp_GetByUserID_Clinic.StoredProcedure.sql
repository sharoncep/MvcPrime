USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetByUserID_Clinic]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetByUserID_Clinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

Create PROCEDURE [Billing].[usp_GetByUserID_Clinic] 
	@IsActive	BIT = NULL,
	@UserID  BIGINT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[User].[UserClinic].*,[Billing].[Clinic].[ClinicName]
	FROM
		[User].[UserClinic] 
	INNER JOIN 
		[Billing].[Clinic]
	ON
		[Billing].[Clinic].[ClinicID]=[User].[UserClinic].[ClinicID]
	AND
		[User].[UserClinic].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[UserClinic].[IsActive] ELSE @IsActive END
	AND
		[User].[UserClinic].[UserID] = @UserID
			
	-- EXEC [Billing].[usp_GetByUserID_Clinic] NULL
	-- EXEC [Billing].[usp_GetByUserID_Clinic] @UserID=1
	-- EXEC [Billing].[usp_GetByUserID_Clinic] 0
END
GO
