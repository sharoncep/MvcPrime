USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetIDAutoComplete_ClaimMedia]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetIDAutoComplete_ClaimMedia]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Transaction].[usp_GetIDAutoComplete_ClaimMedia] 
	@ClaimMediaCode	NVARCHAR(15)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] TINYINT NOT NULL IDENTITY (1, 1)
		, [ClaimMediaID] TINYINT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Transaction].[ClaimMedia].[ClaimMediaID]
	FROM
		[Transaction].[ClaimMedia]
	WHERE
		@ClaimMediaCode = [Transaction].[ClaimMedia].[ClaimMediaCode]
	AND
		[Transaction].[ClaimMedia].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Transaction].[usp_GetIDAutoComplete_ClaimMedia] '00'
	
END
GO
