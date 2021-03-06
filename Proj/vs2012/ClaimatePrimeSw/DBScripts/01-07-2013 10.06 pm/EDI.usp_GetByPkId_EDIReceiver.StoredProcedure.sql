USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetByPkId_EDIReceiver]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetByPkId_EDIReceiver]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [EDI].[usp_GetByPkId_EDIReceiver] 
	@EDIReceiverID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[EDI].[EDIReceiver].*
	FROM
		[EDI].[EDIReceiver]
	WHERE
		[EDI].[EDIReceiver].[EDIReceiverID] = @EDIReceiverID
	AND
		[EDI].[EDIReceiver].[IsActive] = CASE WHEN @IsActive IS NULL THEN [EDI].[EDIReceiver].[IsActive] ELSE @IsActive END;

	-- EXEC [EDI].[usp_GetByPkId_EDIReceiver] 1, NULL
	-- EXEC [EDI].[usp_GetByPkId_EDIReceiver] 1, 1
	-- EXEC [EDI].[usp_GetByPkId_EDIReceiver] 1, 0
END
GO
