USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetByAZ_Clinic]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetByAZ_Clinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Billing].[usp_GetByAZ_Clinic] 

	@UserID		INT
	, @IsActive BIT = NULL	

AS
BEGIN
	
	SET NOCOUNT ON;
    
    DECLARE @TBL_ALL TABLE
    (
		[ClinicName] [nvarchar](40) NULL
    );
    
    DECLARE @TBL_AZ TABLE
    (
		[AZ] [varchar](1) PRIMARY KEY NOT NULL,
		[AZ_COUNT] INT NOT NULL
    );
   
    INSERT INTO
		@TBL_ALL
	 SELECT
		[Billing].[Clinic].[ClinicName]
	FROM
		[User].[UserClinic] 
	INNER JOIN 
		[Billing].[Clinic]
	ON
		[Billing].[Clinic].[ClinicID]=[User].[UserClinic].[ClinicID]
	AND
		[User].[UserClinic].[UserID] = @UserID
	AND
		[User].[UserClinic].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[UserClinic].[IsActive] ELSE @IsActive END
	AND
	    [Billing].[Clinic].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[Clinic].[IsActive] ELSE @IsActive END	
	ORDER BY
		[ClinicName]
	ASC;
	    
		
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
			[ClinicName] LIKE @AZ_CHR + '%';
	
		SELECT @AZ_LOOP = @AZ_LOOP + 1;
	END
	
	SELECT * FROM @TBL_AZ ORDER BY 1 ASC;
	
	-- EXEC [Billing].[usp_GetByAZ_Clinic] 1 , 1
END
GO
