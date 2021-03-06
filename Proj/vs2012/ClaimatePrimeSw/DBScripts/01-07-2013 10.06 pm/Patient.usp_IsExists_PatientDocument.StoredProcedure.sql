USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_IsExists_PatientDocument]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_IsExists_PatientDocument]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Patient].[usp_IsExists_PatientDocument]
	@PatientID BIGINT
	, @DocumentCategoryID TINYINT
	, @ServiceOrFromDate DATE
	, @ToDate DATE = NULL
	, @DocumentRelPath NVARCHAR(350) = NULL
	, @Comment NVARCHAR(4000) = NULL
	, @PatientDocumentID	BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @PatientDocumentID = [Patient].[ufn_IsExists_PatientDocument] (@PatientID, @DocumentCategoryID, @ServiceOrFromDate, @ToDate, @DocumentRelPath, @Comment, 0);
END
GO
