USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_GetByAZ_Diagnosis]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_GetByAZ_Diagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Diagnosis].[usp_GetByAZ_Diagnosis] 
	@SearchName NVARCHAR(150) = NULL
	, @IsActive BIT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT Diagnosisments.
	SET NOCOUNT ON;
	
	IF @SearchName IS NULL
	BEGIN
		SET @SearchName = '';
	END
    
    DECLARE @TBL_ALL TABLE
    (
		[DiagnosisName] [nvarchar](150) NULL
    );
    
    DECLARE @TBL_AZ TABLE
    (
		[AZ] [varchar](1) PRIMARY KEY NOT NULL,
		[AZ_COUNT] INT NOT NULL
    );
    
    INSERT INTO
		@TBL_ALL
	SELECT
		ISNULL([Diagnosis].[Diagnosis].[ShortDesc],ISNULL([Diagnosis].[Diagnosis].[LongDesc],ISNULL([Diagnosis].[Diagnosis].[CustomDesc],ISNULL([Diagnosis].[Diagnosis].[MediumDesc],'NO DESC'))))
	FROM
		[Diagnosis].[Diagnosis]
	WHERE
	(
		ISNULL([Diagnosis].[Diagnosis].[ShortDesc],ISNULL([Diagnosis].[Diagnosis].[LongDesc],ISNULL([Diagnosis].[Diagnosis].[CustomDesc],ISNULL([Diagnosis].[Diagnosis].[MediumDesc],'NO DESC')))) LIKE '%' + @SearchName + '%' 
	OR
		[Diagnosis].[Diagnosis].[DiagnosisCode] LIKE '%' + @SearchName + '%' 		
	)
	AND
		[Diagnosis].[Diagnosis].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Diagnosis].[Diagnosis].[IsActive] ELSE @IsActive END;
		
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
			[DiagnosisName] LIKE @AZ_CHR + '%';
	
		SELECT @AZ_LOOP = @AZ_LOOP + 1;
	END
	
	SELECT * FROM @TBL_AZ ORDER BY 1 ASC;
	
	-- EXEC [Diagnosis].[usp_GetByAZ_Diagnosis] @Searchname = '0.006' 
END
GO
