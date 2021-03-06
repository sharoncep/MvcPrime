USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_IsExists_DiagnosisGroup]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_IsExists_DiagnosisGroup]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Diagnosis].[usp_IsExists_DiagnosisGroup]
	@DiagnosisGroupCode NVARCHAR(9)
	, @DiagnosisGroupDescription NVARCHAR(150)
	, @Amount DECIMAL
	, @Comment NVARCHAR(4000) = NULL
	, @DiagnosisGroupID	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @DiagnosisGroupID = [Diagnosis].[ufn_IsExists_DiagnosisGroup] (@DiagnosisGroupCode, @DiagnosisGroupDescription, @Amount, @Comment, 0);
END
GO
