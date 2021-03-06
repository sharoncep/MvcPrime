USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_IsExists_UserClinic]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_IsExists_UserClinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [User].[usp_IsExists_UserClinic]
	@UserID INT
	, @ClinicID INT
	, @Comment NVARCHAR(4000) = NULL
	, @UserClinicID	BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @UserClinicID = [User].[ufn_IsExists_UserClinic] (@UserID, @ClinicID, @Comment, 0);
END
GO
