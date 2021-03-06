USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_GetIDAutoComplete_DiagnosisGroup]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_GetIDAutoComplete_DiagnosisGroup]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Diagnosis].[usp_GetIDAutoComplete_DiagnosisGroup] 
	@DiagnosisGroupCode	NVARCHAR(17)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] TINYINT NOT NULL IDENTITY (1, 1)
		, [DiagnosisGroupID] TINYINT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID]
	FROM
		[Diagnosis].[DiagnosisGroup]
	WHERE
		@DiagnosisGroupCode = [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Diagnosis].[usp_GetIDAutoComplete_DiagnosisGroup] 'D.O.'
	
END
GO
