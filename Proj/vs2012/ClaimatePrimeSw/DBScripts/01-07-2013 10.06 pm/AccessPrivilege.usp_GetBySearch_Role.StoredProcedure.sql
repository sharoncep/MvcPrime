USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [AccessPrivilege].[usp_GetBySearch_Role]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [AccessPrivilege].[usp_GetBySearch_Role]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [AccessPrivilege].[usp_GetBySearch_Role]
@SearchName NVARCHAR(150) = NULL
	, @StartBy NVARCHAR(1) = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
	, @IsActive BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @SearchName IS NULL
	BEGIN
		SET @SearchName = '';
	END
	
	IF @StartBy IS NULL
	BEGIN
		SET @StartBy = '';
	END
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	INSERT INTO
		@SEARCH_TMP
		(
			[PK_ID]
			, [ROW_NUM]
		)
	SELECT
		[AccessPrivilege].[Role].[RoleID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'RoleName' AND @OrderByDirection = 'A' THEN [AccessPrivilege].[Role].[RoleName] END ASC,
				CASE WHEN @orderByField = 'RoleName' AND @orderByDirection = 'D' THEN [AccessPrivilege].[Role].[RoleName] END DESC,
				
			    CASE WHEN @OrderByField = 'RoleCode' AND @OrderByDirection = 'A' THEN [AccessPrivilege].[Role].[RoleCode] END ASC,
				CASE WHEN @orderByField = 'RoleCode' AND @orderByDirection = 'D' THEN [AccessPrivilege].[Role].[RoleCode] END DESC,
				
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [AccessPrivilege].[Role].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [AccessPrivilege].[Role].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[AccessPrivilege].[Role]
	WHERE
		[AccessPrivilege].[Role].[RoleName] LIKE @StartBy + '%' 
	AND
		[AccessPrivilege].[Role].[RoleName] LIKE '%' + @SearchName + '%' 
	AND
		[AccessPrivilege].[Role].[IsActive] = CASE WHEN @IsActive IS NULL THEN [AccessPrivilege].[Role].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Role].[RoleID], [Role].[RoleName],[Role].[RoleCode],[Role].[IsActive]
	FROM
		[Role] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Role].[RoleID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[Role].[RoleID]
	
	
	-- EXEC [AccessPrivilege].[usp_GetBySearch_Role] @SearchName  = '45'
	-- EXEC [AccessPrivilege].[usp_GetBySearch_Role] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
