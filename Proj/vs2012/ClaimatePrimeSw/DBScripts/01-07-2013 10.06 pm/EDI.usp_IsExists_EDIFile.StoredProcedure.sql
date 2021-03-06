USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_IsExists_EDIFile]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_IsExists_EDIFile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [EDI].[usp_IsExists_EDIFile]
	@EDIReceiverID INT
	, @X12FileRelPath NVARCHAR(255)
	, @RefFileRelPath NVARCHAR(255)
	, @Comment NVARCHAR(4000) = NULL
	, @EDIFileID	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @EDIFileID = [EDI].[ufn_IsExists_EDIFile] (@EDIReceiverID, @X12FileRelPath, @RefFileRelPath, @Comment, 0);
END
GO
