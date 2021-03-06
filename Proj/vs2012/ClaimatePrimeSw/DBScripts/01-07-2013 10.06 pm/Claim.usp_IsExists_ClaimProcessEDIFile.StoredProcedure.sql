USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_IsExists_ClaimProcessEDIFile]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_IsExists_ClaimProcessEDIFile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Claim].[usp_IsExists_ClaimProcessEDIFile]
	@ClaimProcessID BIGINT
	, @EDIFileID INT
	, @Comment NVARCHAR(4000) = NULL
	, @ClaimProcessEDIFileID	BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @ClaimProcessEDIFileID = [Claim].[ufn_IsExists_ClaimProcessEDIFile] (@ClaimProcessID, @EDIFileID, @Comment, 0);
END
GO
