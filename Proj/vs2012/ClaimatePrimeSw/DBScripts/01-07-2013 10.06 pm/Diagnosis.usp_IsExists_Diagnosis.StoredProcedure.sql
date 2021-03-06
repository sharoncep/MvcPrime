USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_IsExists_Diagnosis]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_IsExists_Diagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Diagnosis].[usp_IsExists_Diagnosis]
	@DiagnosisCode NVARCHAR(9)
	, @ICDFormat TINYINT
	, @DiagnosisGroupID INT = NULL
	, @ShortDesc NVARCHAR(150) = NULL
	, @MediumDesc NVARCHAR(150) = NULL
	, @LongDesc NVARCHAR(255) = NULL
	, @CustomDesc NVARCHAR(150) = NULL
	, @Comment NVARCHAR(4000) = NULL
	, @DiagnosisID	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @DiagnosisID = [Diagnosis].[ufn_IsExists_Diagnosis] (@DiagnosisCode, @ICDFormat, @DiagnosisGroupID, @ShortDesc, @MediumDesc, @LongDesc, @CustomDesc, @Comment, 0);
END
GO
