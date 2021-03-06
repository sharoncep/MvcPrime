USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_Update_Diagnosis]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_Update_Diagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the Diagnosis in the database.
	 
CREATE PROCEDURE [Diagnosis].[usp_Update_Diagnosis]
	@DiagnosisCode NVARCHAR(9)
	, @ICDFormat TINYINT
	, @DiagnosisGroupID INT = NULL
	, @ShortDesc NVARCHAR(150) = NULL
	, @MediumDesc NVARCHAR(150) = NULL
	, @LongDesc NVARCHAR(255) = NULL
	, @CustomDesc NVARCHAR(150) = NULL
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @DiagnosisID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @DiagnosisID_PREV BIGINT;
		SELECT @DiagnosisID_PREV = [Diagnosis].[ufn_IsExists_Diagnosis] (@DiagnosisCode, @ICDFormat, @DiagnosisGroupID, @ShortDesc, @MediumDesc, @LongDesc, @CustomDesc, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Diagnosis].[Diagnosis].[DiagnosisID] FROM [Diagnosis].[Diagnosis] WHERE [Diagnosis].[Diagnosis].[DiagnosisID] = @DiagnosisID AND [Diagnosis].[Diagnosis].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@DiagnosisID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Diagnosis].[Diagnosis].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Diagnosis].[Diagnosis].[LastModifiedOn]
			FROM 
				[Diagnosis].[Diagnosis] WITH (NOLOCK)
			WHERE
				[Diagnosis].[Diagnosis].[DiagnosisID] = @DiagnosisID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Diagnosis].[DiagnosisHistory]
					(
						[DiagnosisID]
						, [DiagnosisCode]
						, [ICDFormat]
						, [DiagnosisGroupID]
						, [ShortDesc]
						, [MediumDesc]
						, [LongDesc]
						, [CustomDesc]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Diagnosis].[Diagnosis].[DiagnosisID]
					, [Diagnosis].[Diagnosis].[DiagnosisCode]
					, [Diagnosis].[Diagnosis].[ICDFormat]
					, [Diagnosis].[Diagnosis].[DiagnosisGroupID]
					, [Diagnosis].[Diagnosis].[ShortDesc]
					, [Diagnosis].[Diagnosis].[MediumDesc]
					, [Diagnosis].[Diagnosis].[LongDesc]
					, [Diagnosis].[Diagnosis].[CustomDesc]
					, [Diagnosis].[Diagnosis].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Diagnosis].[Diagnosis].[IsActive]
				FROM 
					[Diagnosis].[Diagnosis]
				WHERE
					[Diagnosis].[Diagnosis].[DiagnosisID] = @DiagnosisID;
				
				UPDATE 
					[Diagnosis].[Diagnosis]
				SET
					[Diagnosis].[Diagnosis].[DiagnosisCode] = @DiagnosisCode
					, [Diagnosis].[Diagnosis].[ICDFormat] = @ICDFormat
					, [Diagnosis].[Diagnosis].[DiagnosisGroupID] = @DiagnosisGroupID
					, [Diagnosis].[Diagnosis].[ShortDesc] = @ShortDesc
					, [Diagnosis].[Diagnosis].[MediumDesc] = @MediumDesc
					, [Diagnosis].[Diagnosis].[LongDesc] = @LongDesc
					, [Diagnosis].[Diagnosis].[CustomDesc] = @CustomDesc
					, [Diagnosis].[Diagnosis].[Comment] = @Comment
					, [Diagnosis].[Diagnosis].[LastModifiedBy] = @CurrentModificationBy
					, [Diagnosis].[Diagnosis].[LastModifiedOn] = @CurrentModificationOn
					, [Diagnosis].[Diagnosis].[IsActive] = @IsActive
				WHERE
					[Diagnosis].[Diagnosis].[DiagnosisID] = @DiagnosisID;				
			END
			ELSE
			BEGIN
				SELECT @DiagnosisID = -2;
			END
		END
		ELSE IF @DiagnosisID_PREV <> @DiagnosisID
		BEGIN			
			SELECT @DiagnosisID = -1;			
		END
		-- ELSE
		-- BEGIN
		--	 SELECT @CurrentModificationOn = @LastModifiedOn;
		-- END
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY			
			EXEC [Audit].[usp_Insert_ErrorLog];			
			SELECT @DiagnosisID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
