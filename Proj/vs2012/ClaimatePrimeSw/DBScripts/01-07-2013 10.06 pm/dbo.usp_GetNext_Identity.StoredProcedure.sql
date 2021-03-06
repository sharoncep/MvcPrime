USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetNext_Identity]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [dbo].[usp_GetNext_Identity]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  Get Next Identity Value

CREATE PROCEDURE [dbo].[usp_GetNext_Identity]
	@SchemaName	NVARCHAR(150)
	, @TableName NVARCHAR(150)
AS
BEGIN
	SET NOCOUNT ON;
	
    DECLARE @TBL_RES TABLE
	(
		[ID] BIGINT NOT NULL IDENTITY (1, 1)
		, [NEXT_INDENTITY] BIGINT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT 
		IDENT_CURRENT(@SchemaName + '.' + @TableName) + IDENT_INCR(@SchemaName + '.' + @TableName) AS [NextIndentity];
	
	SELECT * FROM @TBL_RES;
    
    -- EXEC [dbo].[usp_GetNext_Identity] @SchemaName = 'Configuration', @TableName = 'General'
END
GO
