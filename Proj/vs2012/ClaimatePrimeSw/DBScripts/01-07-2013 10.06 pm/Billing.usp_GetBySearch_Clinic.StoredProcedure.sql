USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_Clinic]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetBySearch_Clinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Billing].[usp_GetBySearch_Clinic]
	@UserID		INT
	, @StartBy NVARCHAR(1) = NULL
	, @IsActive BIT = NULL	
AS
BEGIN-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @StartBy IS NULL
	BEGIN
		SET @StartBy = '';
	END
    
    SELECT
		[Billing].[Clinic].[ClinicCode]	
		, [Billing].[Clinic].[ClinicName]
		, [Billing].[Clinic].[ClinicID]
		, [Billing].[Clinic].[IsActive]
	FROM
		[User].[UserClinic] 
	INNER JOIN 
		[Billing].[Clinic]
	ON
		[Billing].[Clinic].[ClinicID]=[User].[UserClinic].[ClinicID] 
	
	AND 
		[Billing].[Clinic].[ClinicName]
	LIKE 
		@StartBy + '%'
	AND
		[User].[UserClinic].[UserID] = @UserID
	AND
		[User].[UserClinic].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[UserClinic].[IsActive] ELSE @IsActive END
	AND
	    [Billing].[Clinic].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[Clinic].[IsActive] ELSE @IsActive END	
	ORDER BY
		[ClinicName]
	ASC;
		
	
	-- EXEC [Billing].[usp_GetBySearch_Clinic] @UserID = 103 , @RoleID = 5, @StartBy='W'
END
GO
