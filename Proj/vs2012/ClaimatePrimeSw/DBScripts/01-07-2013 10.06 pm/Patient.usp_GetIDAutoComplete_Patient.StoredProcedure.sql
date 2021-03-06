USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetIDAutoComplete_Patient]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetIDAutoComplete_Patient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetIDAutoComplete_Patient] 

	@ChartNumber nvarchar(20)
	, @IsActive	BIT = NULL
	
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [PatientID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Patient].[Patient].[PatientID]
	FROM
		[Patient].[Patient]
	WHERE
		@ChartNumber = [Patient].[Patient].[ChartNumber]
	AND
			[Patient].[Patient].[IsActive]=1
	
	SELECT * FROM @TBL_RES;
	-- EXEC [Patient].[usp_GetIDAutoComplete_Patient] coo1, 1
	-- EXEC [Patient].[usp_GetIDAutoComplete_Patient] 1, 1
	-- EXEC [Patient].[usp_GetIDAutoComplete_Patient] 1, 0
END
GO
