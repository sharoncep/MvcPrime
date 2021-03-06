USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAll_MvcInit]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [dbo].[usp_GetAll_MvcInit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- MVC Init Checking

CREATE PROCEDURE [dbo].[usp_GetAll_MvcInit]
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [SCHEMA_NAME] NVARCHAR(255) NOT NULL
		, [OBJECT_NAME] NVARCHAR(255) NOT NULL
		, [OBJECT_TYPE] NVARCHAR(255) NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT DISTINCT
		[T].[TABLE_SCHEMA] AS [SCHEMA_NAME]
		, [T].[TABLE_NAME] AS [OBJECT_NAME]
		, [T].[TABLE_TYPE] AS [OBJECT_TYPE]
	FROM
		[INFORMATION_SCHEMA].[TABLES] T
	WHERE
		[T].[TABLE_TYPE] = 'BASE TABLE'
	AND
		[T].[TABLE_NAME] NOT LIKE '%History';

	INSERT INTO
		@TBL_RES
	SELECT DISTINCT
		[R].[ROUTINE_SCHEMA] AS [SCHEMA_NAME]
		, [R].[ROUTINE_NAME] AS [OBJECT_NAME]
		, [R].[ROUTINE_TYPE] AS [OBJECT_TYPE]
	FROM
		[INFORMATION_SCHEMA].[ROUTINES] R;
	
	SELECT * FROM @TBL_RES ORDER BY [SCHEMA_NAME] ASC, [OBJECT_NAME] ASC, [OBJECT_TYPE] ASC;
	
	-- EXEC [dbo].[usp_GetAll_MvcInit]
END
GO
