USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetByAZ_InterchangeUsageIndicator]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetByAZ_InterchangeUsageIndicator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Transaction].[usp_GetByAZ_InterchangeUsageIndicator] 
	@SearchName NVARCHAR(150) = NULL
	, @IsActive BIT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @SearchName IS NULL
	BEGIN
		SET @SearchName = '';
	END
    
    DECLARE @TBL_ALL TABLE
    (
		[InterchangeUsageIndicatorName] [nvarchar](150) NULL
    );
    
    DECLARE @TBL_AZ TABLE
    (
		[AZ] [varchar](1) PRIMARY KEY NOT NULL,
		[AZ_COUNT] INT NOT NULL
    );
    
    INSERT INTO
		@TBL_ALL
	SELECT
		[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorName]
	FROM
		[Transaction].[InterchangeUsageIndicator]
	WHERE
	(
		[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorName] LIKE '%' + @SearchName + '%' 
	OR
		[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorCode] LIKE '%' + @SearchName + '%'
	) 
	AND
		[Transaction].[InterchangeUsageIndicator].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[InterchangeUsageIndicator].[IsActive] ELSE @IsActive END;
		
	DECLARE @AZ_TMP VARCHAR(26);
	SELECT @AZ_TMP = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	DECLARE @AZ_LOOP INT;
	SELECT 	@AZ_LOOP = 1;
	DECLARE @AZ_CNT INT;
	SELECT @AZ_CNT = LEN(@AZ_TMP);
	DECLARE @AZ_CHR VARCHAR(1);
	SELECT @AZ_CHR = '';
	
	WHILE @AZ_LOOP <= @AZ_CNT
	BEGIN
		SELECT @AZ_CHR = SUBSTRING(@AZ_TMP, @AZ_LOOP, 1);
		
		INSERT INTO
			@TBL_AZ
		SELECT
			@AZ_CHR	AS [AZ]
			, COUNT(*) AS [AZ_COUNT]
		FROM
			@TBL_ALL
		WHERE
			[InterchangeUsageIndicatorName] LIKE @AZ_CHR + '%';
	
		SELECT @AZ_LOOP = @AZ_LOOP + 1;
	END
	
	SELECT * FROM @TBL_AZ ORDER BY 1 ASC;
	
	-- EXEC [Transaction].[usp_GetByAZ_InterchangeUsageIndicator] 
END
GO
