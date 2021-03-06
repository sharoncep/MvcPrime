USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_Update_EDIReceiver]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_Update_EDIReceiver]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the EDIReceiver in the database.
	 
CREATE PROCEDURE [EDI].[usp_Update_EDIReceiver]
	@EDIReceiverCode NVARCHAR(25)
	, @EDIReceiverName NVARCHAR(25)
	, @AuthorizationInformationQualifierID TINYINT
	, @AuthorizationInformation NVARCHAR(10) = NULL
	, @SecurityInformationQualifierID TINYINT
	, @SecurityInformation NVARCHAR(10) = NULL
	, @SecurityInformationQualifierUserName NVARCHAR(25) = NULL
	, @SecurityInformationQualifierPassword NVARCHAR(25) = NULL
	, @LastInterchangeControlNumber BIGINT
	, @SenderInterchangeIDQualifierID TINYINT
	, @SenderInterchangeID NVARCHAR(15)
	, @ReceiverInterchangeIDQualifierID TINYINT
	, @ReceiverInterchangeID NVARCHAR(15)
	, @TransactionSetPurposeCodeID TINYINT
	, @TransactionTypeCodeID TINYINT
	, @IsGroupPractice BIT
	, @ClaimMediaID TINYINT
	, @ApplicationSenderCode NVARCHAR(25)
	, @ApplicationReceiverCode NVARCHAR(25)
	, @InterchangeUsageIndicatorID TINYINT
	, @FunctionalIdentifierCode NVARCHAR(2)
	, @SubmitterEntityIdentifierCodeID TINYINT
	, @ReceiverEntityIdentifierCodeID TINYINT
	, @BillingProviderEntityIdentifierCodeID TINYINT
	, @SubscriberEntityIdentifierCodeID TINYINT
	, @PayerEntityIdentifierCodeID TINYINT
	, @EntityTypeQualifierID TINYINT
	, @CurrencyCodeID TINYINT
	, @PayerResponsibilitySequenceNumberCodeID TINYINT
	, @EmailCommunicationNumberQualifierID TINYINT
	, @FaxCommunicationNumberQualifierID TINYINT
	, @PhoneCommunicationNumberQualifierID TINYINT
	, @PatientEntityTypeQualifierID TINYINT
	, @ProviderEntityTypeQualifierID TINYINT
	, @InsuranceEntityTypeQualifierID TINYINT
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @EDIReceiverID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @EDIReceiverID_PREV BIGINT;
		SELECT @EDIReceiverID_PREV = [EDI].[ufn_IsExists_EDIReceiver] (@EDIReceiverCode, @EDIReceiverName, @AuthorizationInformationQualifierID, @AuthorizationInformation, @SecurityInformationQualifierID, @SecurityInformation, @SecurityInformationQualifierUserName, @SecurityInformationQualifierPassword, @LastInterchangeControlNumber, @SenderInterchangeIDQualifierID, @SenderInterchangeID, @ReceiverInterchangeIDQualifierID, @ReceiverInterchangeID, @TransactionSetPurposeCodeID, @TransactionTypeCodeID, @IsGroupPractice, @ClaimMediaID, @ApplicationSenderCode, @ApplicationReceiverCode, @InterchangeUsageIndicatorID, @FunctionalIdentifierCode, @SubmitterEntityIdentifierCodeID, @ReceiverEntityIdentifierCodeID, @BillingProviderEntityIdentifierCodeID, @SubscriberEntityIdentifierCodeID, @PayerEntityIdentifierCodeID, @EntityTypeQualifierID, @CurrencyCodeID, @PayerResponsibilitySequenceNumberCodeID, @EmailCommunicationNumberQualifierID, @FaxCommunicationNumberQualifierID, @PhoneCommunicationNumberQualifierID, @PatientEntityTypeQualifierID, @ProviderEntityTypeQualifierID, @InsuranceEntityTypeQualifierID, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [EDI].[EDIReceiver].[EDIReceiverID] FROM [EDI].[EDIReceiver] WHERE [EDI].[EDIReceiver].[EDIReceiverID] = @EDIReceiverID AND [EDI].[EDIReceiver].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@EDIReceiverID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [EDI].[EDIReceiver].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [EDI].[EDIReceiver].[LastModifiedOn]
			FROM 
				[EDI].[EDIReceiver] WITH (NOLOCK)
			WHERE
				[EDI].[EDIReceiver].[EDIReceiverID] = @EDIReceiverID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[EDI].[EDIReceiverHistory]
					(
						[EDIReceiverID]
						, [EDIReceiverCode]
						, [EDIReceiverName]
						, [AuthorizationInformationQualifierID]
						, [AuthorizationInformation]
						, [SecurityInformationQualifierID]
						, [SecurityInformation]
						, [SecurityInformationQualifierUserName]
						, [SecurityInformationQualifierPassword]
						, [LastInterchangeControlNumber]
						, [SenderInterchangeIDQualifierID]
						, [SenderInterchangeID]
						, [ReceiverInterchangeIDQualifierID]
						, [ReceiverInterchangeID]
						, [TransactionSetPurposeCodeID]
						, [TransactionTypeCodeID]
						, [IsGroupPractice]
						, [ClaimMediaID]
						, [ApplicationSenderCode]
						, [ApplicationReceiverCode]
						, [InterchangeUsageIndicatorID]
						, [FunctionalIdentifierCode]
						, [SubmitterEntityIdentifierCodeID]
						, [ReceiverEntityIdentifierCodeID]
						, [BillingProviderEntityIdentifierCodeID]
						, [SubscriberEntityIdentifierCodeID]
						, [PayerEntityIdentifierCodeID]
						, [EntityTypeQualifierID]
						, [CurrencyCodeID]
						, [PayerResponsibilitySequenceNumberCodeID]
						, [EmailCommunicationNumberQualifierID]
						, [FaxCommunicationNumberQualifierID]
						, [PhoneCommunicationNumberQualifierID]
						, [PatientEntityTypeQualifierID]
						, [ProviderEntityTypeQualifierID]
						, [InsuranceEntityTypeQualifierID]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[EDI].[EDIReceiver].[EDIReceiverID]
					, [EDI].[EDIReceiver].[EDIReceiverCode]
					, [EDI].[EDIReceiver].[EDIReceiverName]
					, [EDI].[EDIReceiver].[AuthorizationInformationQualifierID]
					, [EDI].[EDIReceiver].[AuthorizationInformation]
					, [EDI].[EDIReceiver].[SecurityInformationQualifierID]
					, [EDI].[EDIReceiver].[SecurityInformation]
					, [EDI].[EDIReceiver].[SecurityInformationQualifierUserName]
					, [EDI].[EDIReceiver].[SecurityInformationQualifierPassword]
					, [EDI].[EDIReceiver].[LastInterchangeControlNumber]
					, [EDI].[EDIReceiver].[SenderInterchangeIDQualifierID]
					, [EDI].[EDIReceiver].[SenderInterchangeID]
					, [EDI].[EDIReceiver].[ReceiverInterchangeIDQualifierID]
					, [EDI].[EDIReceiver].[ReceiverInterchangeID]
					, [EDI].[EDIReceiver].[TransactionSetPurposeCodeID]
					, [EDI].[EDIReceiver].[TransactionTypeCodeID]
					, [EDI].[EDIReceiver].[IsGroupPractice]
					, [EDI].[EDIReceiver].[ClaimMediaID]
					, [EDI].[EDIReceiver].[ApplicationSenderCode]
					, [EDI].[EDIReceiver].[ApplicationReceiverCode]
					, [EDI].[EDIReceiver].[InterchangeUsageIndicatorID]
					, [EDI].[EDIReceiver].[FunctionalIdentifierCode]
					, [EDI].[EDIReceiver].[SubmitterEntityIdentifierCodeID]
					, [EDI].[EDIReceiver].[ReceiverEntityIdentifierCodeID]
					, [EDI].[EDIReceiver].[BillingProviderEntityIdentifierCodeID]
					, [EDI].[EDIReceiver].[SubscriberEntityIdentifierCodeID]
					, [EDI].[EDIReceiver].[PayerEntityIdentifierCodeID]
					, [EDI].[EDIReceiver].[EntityTypeQualifierID]
					, [EDI].[EDIReceiver].[CurrencyCodeID]
					, [EDI].[EDIReceiver].[PayerResponsibilitySequenceNumberCodeID]
					, [EDI].[EDIReceiver].[EmailCommunicationNumberQualifierID]
					, [EDI].[EDIReceiver].[FaxCommunicationNumberQualifierID]
					, [EDI].[EDIReceiver].[PhoneCommunicationNumberQualifierID]
					, [EDI].[EDIReceiver].[PatientEntityTypeQualifierID]
					, [EDI].[EDIReceiver].[ProviderEntityTypeQualifierID]
					, [EDI].[EDIReceiver].[InsuranceEntityTypeQualifierID]
					, [EDI].[EDIReceiver].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [EDI].[EDIReceiver].[IsActive]
				FROM 
					[EDI].[EDIReceiver]
				WHERE
					[EDI].[EDIReceiver].[EDIReceiverID] = @EDIReceiverID;
				
				UPDATE 
					[EDI].[EDIReceiver]
				SET
					[EDI].[EDIReceiver].[EDIReceiverCode] = @EDIReceiverCode
					, [EDI].[EDIReceiver].[EDIReceiverName] = @EDIReceiverName
					, [EDI].[EDIReceiver].[AuthorizationInformationQualifierID] = @AuthorizationInformationQualifierID
					, [EDI].[EDIReceiver].[AuthorizationInformation] = @AuthorizationInformation
					, [EDI].[EDIReceiver].[SecurityInformationQualifierID] = @SecurityInformationQualifierID
					, [EDI].[EDIReceiver].[SecurityInformation] = @SecurityInformation
					, [EDI].[EDIReceiver].[SecurityInformationQualifierUserName] = @SecurityInformationQualifierUserName
					, [EDI].[EDIReceiver].[SecurityInformationQualifierPassword] = @SecurityInformationQualifierPassword
					, [EDI].[EDIReceiver].[LastInterchangeControlNumber] = @LastInterchangeControlNumber
					, [EDI].[EDIReceiver].[SenderInterchangeIDQualifierID] = @SenderInterchangeIDQualifierID
					, [EDI].[EDIReceiver].[SenderInterchangeID] = @SenderInterchangeID
					, [EDI].[EDIReceiver].[ReceiverInterchangeIDQualifierID] = @ReceiverInterchangeIDQualifierID
					, [EDI].[EDIReceiver].[ReceiverInterchangeID] = @ReceiverInterchangeID
					, [EDI].[EDIReceiver].[TransactionSetPurposeCodeID] = @TransactionSetPurposeCodeID
					, [EDI].[EDIReceiver].[TransactionTypeCodeID] = @TransactionTypeCodeID
					, [EDI].[EDIReceiver].[IsGroupPractice] = @IsGroupPractice
					, [EDI].[EDIReceiver].[ClaimMediaID] = @ClaimMediaID
					, [EDI].[EDIReceiver].[ApplicationSenderCode] = @ApplicationSenderCode
					, [EDI].[EDIReceiver].[ApplicationReceiverCode] = @ApplicationReceiverCode
					, [EDI].[EDIReceiver].[InterchangeUsageIndicatorID] = @InterchangeUsageIndicatorID
					, [EDI].[EDIReceiver].[FunctionalIdentifierCode] = @FunctionalIdentifierCode
					, [EDI].[EDIReceiver].[SubmitterEntityIdentifierCodeID] = @SubmitterEntityIdentifierCodeID
					, [EDI].[EDIReceiver].[ReceiverEntityIdentifierCodeID] = @ReceiverEntityIdentifierCodeID
					, [EDI].[EDIReceiver].[BillingProviderEntityIdentifierCodeID] = @BillingProviderEntityIdentifierCodeID
					, [EDI].[EDIReceiver].[SubscriberEntityIdentifierCodeID] = @SubscriberEntityIdentifierCodeID
					, [EDI].[EDIReceiver].[PayerEntityIdentifierCodeID] = @PayerEntityIdentifierCodeID
					, [EDI].[EDIReceiver].[EntityTypeQualifierID] = @EntityTypeQualifierID
					, [EDI].[EDIReceiver].[CurrencyCodeID] = @CurrencyCodeID
					, [EDI].[EDIReceiver].[PayerResponsibilitySequenceNumberCodeID] = @PayerResponsibilitySequenceNumberCodeID
					, [EDI].[EDIReceiver].[EmailCommunicationNumberQualifierID] = @EmailCommunicationNumberQualifierID
					, [EDI].[EDIReceiver].[FaxCommunicationNumberQualifierID] = @FaxCommunicationNumberQualifierID
					, [EDI].[EDIReceiver].[PhoneCommunicationNumberQualifierID] = @PhoneCommunicationNumberQualifierID
					, [EDI].[EDIReceiver].[PatientEntityTypeQualifierID] = @PatientEntityTypeQualifierID
					, [EDI].[EDIReceiver].[ProviderEntityTypeQualifierID] = @ProviderEntityTypeQualifierID
					, [EDI].[EDIReceiver].[InsuranceEntityTypeQualifierID] = @InsuranceEntityTypeQualifierID
					, [EDI].[EDIReceiver].[Comment] = @Comment
					, [EDI].[EDIReceiver].[LastModifiedBy] = @CurrentModificationBy
					, [EDI].[EDIReceiver].[LastModifiedOn] = @CurrentModificationOn
					, [EDI].[EDIReceiver].[IsActive] = @IsActive
				WHERE
					[EDI].[EDIReceiver].[EDIReceiverID] = @EDIReceiverID;				
			END
			ELSE
			BEGIN
				SELECT @EDIReceiverID = -2;
			END
		END
		ELSE IF @EDIReceiverID_PREV <> @EDIReceiverID
		BEGIN			
			SELECT @EDIReceiverID = -1;			
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
			SELECT @EDIReceiverID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
