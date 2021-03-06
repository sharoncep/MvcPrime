USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_GetByPkId_UserClinic]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_GetByPkId_UserClinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [User].[usp_GetByPkId_UserClinic] 
	@UserClinicID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[User].[UserClinic].*
	FROM
		[User].[UserClinic]
	WHERE
		[User].[UserClinic].[UserClinicID] = @UserClinicID
	AND
		[User].[UserClinic].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[UserClinic].[IsActive] ELSE @IsActive END;

	-- EXEC [User].[usp_GetByPkId_UserClinic] 1, NULL
	-- EXEC [User].[usp_GetByPkId_UserClinic] 1, 1
	-- EXEC [User].[usp_GetByPkId_UserClinic] 1, 0
END
GO
