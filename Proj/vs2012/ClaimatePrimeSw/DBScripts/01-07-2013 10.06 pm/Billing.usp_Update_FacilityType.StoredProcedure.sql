USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_Update_FacilityType]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_Update_FacilityType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the FacilityType in the database.
	 
CREATE PROCEDURE [Billing].[usp_Update_FacilityType]
	@FacilityTypeCode NVARCHAR(2)
	, @FacilityTypeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @FacilityTypeID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @FacilityTypeID_PREV BIGINT;
		SELECT @FacilityTypeID_PREV = [Billing].[ufn_IsExists_FacilityType] (@FacilityTypeCode, @FacilityTypeName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Billing].[FacilityType].[FacilityTypeID] FROM [Billing].[FacilityType] WHERE [Billing].[FacilityType].[FacilityTypeID] = @FacilityTypeID AND [Billing].[FacilityType].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@FacilityTypeID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Billing].[FacilityType].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Billing].[FacilityType].[LastModifiedOn]
			FROM 
				[Billing].[FacilityType] WITH (NOLOCK)
			WHERE
				[Billing].[FacilityType].[FacilityTypeID] = @FacilityTypeID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Billing].[FacilityTypeHistory]
					(
						[FacilityTypeID]
						, [FacilityTypeCode]
						, [FacilityTypeName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Billing].[FacilityType].[FacilityTypeID]
					, [Billing].[FacilityType].[FacilityTypeCode]
					, [Billing].[FacilityType].[FacilityTypeName]
					, [Billing].[FacilityType].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Billing].[FacilityType].[IsActive]
				FROM 
					[Billing].[FacilityType]
				WHERE
					[Billing].[FacilityType].[FacilityTypeID] = @FacilityTypeID;
				
				UPDATE 
					[Billing].[FacilityType]
				SET
					[Billing].[FacilityType].[FacilityTypeCode] = @FacilityTypeCode
					, [Billing].[FacilityType].[FacilityTypeName] = @FacilityTypeName
					, [Billing].[FacilityType].[Comment] = @Comment
					, [Billing].[FacilityType].[LastModifiedBy] = @CurrentModificationBy
					, [Billing].[FacilityType].[LastModifiedOn] = @CurrentModificationOn
					, [Billing].[FacilityType].[IsActive] = @IsActive
				WHERE
					[Billing].[FacilityType].[FacilityTypeID] = @FacilityTypeID;				
			END
			ELSE
			BEGIN
				SELECT @FacilityTypeID = -2;
			END
		END
		ELSE IF @FacilityTypeID_PREV <> @FacilityTypeID
		BEGIN			
			SELECT @FacilityTypeID = -1;			
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
			SELECT @FacilityTypeID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
