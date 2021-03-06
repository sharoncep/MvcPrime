USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetIDAutoComplete_EDIReceiver]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetIDAutoComplete_EDIReceiver]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [EDI].[usp_GetIDAutoComplete_EDIReceiver] 
	@EDIReceiverCode	nvarchar(15)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [EDIReceiver_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[EDI].[EDIReceiver].[EDIReceiverID]
	FROM
		[EDI].[EDIReceiver]
	WHERE
		@EDIReceiverCode = [EDI].[EDIReceiver].[EDIReceiverCode]
	AND
		[EDI].[EDIReceiver].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [EDI].[usp_GetIDAutoComplete_EDIReceiver] 1
	-- EXEC [EDI].[usp_GetIDAutoComplete_EDIReceiver] 1, 1
	-- EXEC [EDI].[usp_GetIDAutoComplete_EDIReceiver] 1, 0
END
GO
