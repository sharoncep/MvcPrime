USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetIDAutoComplete_IPA]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetIDAutoComplete_IPA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Billing].[usp_GetIDAutoComplete_IPA] 
	@IPACode	NVARCHAR(17)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] TINYINT NOT NULL IDENTITY (1, 1)
		, [IPAID] TINYINT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Billing].[IPA].[IPAID]
	FROM
		[Billing].[IPA]
	WHERE
		@IPACode = [Billing].[IPA].[IPACode]
	AND
		[Billing].[IPA].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Billing].[usp_GetIDAutoComplete_IPA] '171100000X'
	
END
GO
