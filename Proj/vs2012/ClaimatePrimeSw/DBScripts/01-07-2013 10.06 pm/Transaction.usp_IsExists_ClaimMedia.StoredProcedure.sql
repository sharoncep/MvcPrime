USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_IsExists_ClaimMedia]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_IsExists_ClaimMedia]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Transaction].[usp_IsExists_ClaimMedia]
	@ClaimMediaCode NVARCHAR(15)
	, @ClaimMediaName NVARCHAR(150)
	, @MaxDiagnosis TINYINT
	, @Comment NVARCHAR(4000) = NULL
	, @ClaimMediaID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @ClaimMediaID = [Transaction].[ufn_IsExists_ClaimMedia] (@ClaimMediaCode, @ClaimMediaName, @MaxDiagnosis, @Comment, 0);
END
GO
