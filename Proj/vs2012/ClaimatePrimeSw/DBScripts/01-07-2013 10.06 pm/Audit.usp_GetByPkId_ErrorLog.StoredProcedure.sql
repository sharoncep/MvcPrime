USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_GetByPkId_ErrorLog]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_GetByPkId_ErrorLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Audit].[usp_GetByPkId_ErrorLog] 
	@ErrorLogID	BIGINT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Audit].[ErrorLog].*
	FROM
		[Audit].[ErrorLog]
	WHERE
		@ErrorLogID = [Audit].[ErrorLog].[ErrorLogID];

	-- EXEC [Audit].[usp_GetByPkId_ErrorLog] 1, NULL
	-- EXEC [Audit].[usp_GetByPkId_ErrorLog] 1, 1
	-- EXEC [Audit].[usp_GetByPkId_ErrorLog] 1, 0
END
GO
