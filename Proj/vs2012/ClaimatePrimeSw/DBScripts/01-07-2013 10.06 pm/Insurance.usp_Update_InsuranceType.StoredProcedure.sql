USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_Update_InsuranceType]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_Update_InsuranceType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the InsuranceType in the database.
	 
CREATE PROCEDURE [Insurance].[usp_Update_InsuranceType]
	@InsuranceTypeCode NVARCHAR(2)
	, @InsuranceTypeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @InsuranceTypeID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @InsuranceTypeID_PREV BIGINT;
		SELECT @InsuranceTypeID_PREV = [Insurance].[ufn_IsExists_InsuranceType] (@InsuranceTypeCode, @InsuranceTypeName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Insurance].[InsuranceType].[InsuranceTypeID] FROM [Insurance].[InsuranceType] WHERE [Insurance].[InsuranceType].[InsuranceTypeID] = @InsuranceTypeID AND [Insurance].[InsuranceType].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@InsuranceTypeID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Insurance].[InsuranceType].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Insurance].[InsuranceType].[LastModifiedOn]
			FROM 
				[Insurance].[InsuranceType] WITH (NOLOCK)
			WHERE
				[Insurance].[InsuranceType].[InsuranceTypeID] = @InsuranceTypeID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Insurance].[InsuranceTypeHistory]
					(
						[InsuranceTypeID]
						, [InsuranceTypeCode]
						, [InsuranceTypeName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Insurance].[InsuranceType].[InsuranceTypeID]
					, [Insurance].[InsuranceType].[InsuranceTypeCode]
					, [Insurance].[InsuranceType].[InsuranceTypeName]
					, [Insurance].[InsuranceType].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Insurance].[InsuranceType].[IsActive]
				FROM 
					[Insurance].[InsuranceType]
				WHERE
					[Insurance].[InsuranceType].[InsuranceTypeID] = @InsuranceTypeID;
				
				UPDATE 
					[Insurance].[InsuranceType]
				SET
					[Insurance].[InsuranceType].[InsuranceTypeCode] = @InsuranceTypeCode
					, [Insurance].[InsuranceType].[InsuranceTypeName] = @InsuranceTypeName
					, [Insurance].[InsuranceType].[Comment] = @Comment
					, [Insurance].[InsuranceType].[LastModifiedBy] = @CurrentModificationBy
					, [Insurance].[InsuranceType].[LastModifiedOn] = @CurrentModificationOn
					, [Insurance].[InsuranceType].[IsActive] = @IsActive
				WHERE
					[Insurance].[InsuranceType].[InsuranceTypeID] = @InsuranceTypeID;				
			END
			ELSE
			BEGIN
				SELECT @InsuranceTypeID = -2;
			END
		END
		ELSE IF @InsuranceTypeID_PREV <> @InsuranceTypeID
		BEGIN			
			SELECT @InsuranceTypeID = -1;			
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
			SELECT @InsuranceTypeID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
