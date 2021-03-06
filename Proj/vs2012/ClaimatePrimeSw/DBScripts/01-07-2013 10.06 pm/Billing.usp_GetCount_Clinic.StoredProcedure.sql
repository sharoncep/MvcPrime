USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetCount_Clinic]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetCount_Clinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Billing].[usp_GetCount_Clinic]
	@UserID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [CLINIC_COUNT] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		COUNT ([Billing].[Clinic].[ClinicID]) AS [ClinicCount]
	FROM
		[User].[UserClinic] 
	INNER JOIN 
		[Billing].[Clinic]
	ON
		[Billing].[Clinic].[ClinicID]=[User].[UserClinic].[ClinicID] 
	WHERE
		[User].[UserClinic].[UserID] = @UserID
	AND
		[User].[UserClinic].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1
	
	SELECT * FROM @TBL_RES;
	
	-- EXEC [Billing].[usp_GetCount_Clinic] @UserID = 101
END
GO
