USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetByPrintSignID_PrintSign]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetByPrintSignID_PrintSign]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [EDI].[usp_GetByPrintSignID_PrintSign]
	@InsuranceID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    DECLARE @TBL_ANS TABLE 
    (
		 [NAME_CODE_PAT] NVARCHAR(165) NOT NULL
		, [NAME_CODE_INSURED] NVARCHAR(165)  NULL
		, [NAME_CODE_PROVIDER] NVARCHAR(165)  NULL
	);
	DECLARE @PatientPrintSignID	NVARCHAR(165) 
	,@InsuredPrintSignID	NVARCHAR(165) 
	,@PhysicianPrintSignID NVARCHAR(165) 
	
    BEGIN
		--PAT PRINT
		SELECT @PatientPrintSignID =
			[EDI].[PrintSign].[PrintSignName] --+ ' [' + [EDI].[PrintSign].[PrintSignCode] + ']' 
		FROM
			[EDI].[PrintSign]
		INNER JOIN
			[Insurance].[Insurance] 
		ON
			[EDI].[PrintSign].[PrintSignID] = [Insurance].[Insurance].[PatientPrintSignID]
		WHERE
			 [Insurance].[Insurance] .[InsuranceID] = @InsuranceID
			 
		--INSU PRINT
		SELECT @InsuredPrintSignID =
			[EDI].[PrintSign].[PrintSignName] --+ ' [' + [EDI].[PrintSign].[PrintSignCode] + ']' 
		FROM
			[EDI].[PrintSign]
		INNER JOIN
			[Insurance].[Insurance] 
		ON
			[EDI].[PrintSign].[PrintSignID] = [Insurance].[Insurance].[InsuredPrintSignID]
		WHERE
			 [Insurance].[Insurance] .[InsuranceID] = @InsuranceID	 
		
		--PHY PRINT
		SELECT @PhysicianPrintSignID =
			[EDI].[PrintSign].[PrintSignName] --+ ' [' + [EDI].[PrintSign].[PrintSignCode] + ']' 
		FROM
			[EDI].[PrintSign]
		INNER JOIN
			[Insurance].[Insurance] 
		ON
			[EDI].[PrintSign].[PrintSignID] = [Insurance].[Insurance].[PhysicianPrintSignID]
		WHERE
			 [Insurance].[Insurance] .[InsuranceID] = @InsuranceID	
	END
    
    BEGIN
		INSERT INTO
			@TBL_ANS
			VALUES 
			(
				@PatientPrintSignID	 
				,@InsuredPrintSignID	 
				,@PhysicianPrintSignID  
			)
	END
	
	SELECT * FROM @TBL_ANS
	
	-- EXEC [EDI].[usp_GetByPrintSignID_PrintSign] @InsuranceID = 1
END
GO
