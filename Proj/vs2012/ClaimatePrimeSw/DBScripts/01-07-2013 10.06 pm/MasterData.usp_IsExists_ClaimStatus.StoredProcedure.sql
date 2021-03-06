USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_IsExists_ClaimStatus]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_IsExists_ClaimStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [MasterData].[usp_IsExists_ClaimStatus]
	@ClaimStatusCode NVARCHAR(2)
	, @ClaimStatusName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @ClaimStatusID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @ClaimStatusID = [MasterData].[ufn_IsExists_ClaimStatus] (@ClaimStatusCode, @ClaimStatusName, @Comment, 0);
END
GO
