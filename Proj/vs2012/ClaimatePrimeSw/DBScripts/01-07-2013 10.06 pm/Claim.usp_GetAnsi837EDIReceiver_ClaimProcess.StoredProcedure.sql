USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetAnsi837EDIReceiver_ClaimProcess]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetAnsi837EDIReceiver_ClaimProcess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetAnsi837EDIReceiver_ClaimProcess]
	@EDIReceiverID INT
AS
BEGIN

	SET NOCOUNT ON;
	
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
		, [EDI].[EDIReceiver].[FunctionalIdentifierCode]
		, [EDI].[EDIReceiver].[ApplicationSenderCode]
		, [EDI].[EDIReceiver].[ApplicationReceiverCode]
		, [EDI].[EDIReceiver].[InterchangeUsageIndicatorID]
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
		, [EDI].[EDIReceiver].[IsActive]
		, [EDI].[EDIReceiver].[LastModifiedBy]
		, [EDI].[EDIReceiver].[LastModifiedOn]
		, [EDI].[EDIReceiver].[CreatedBy]
		, [EDI].[EDIReceiver].[CreatedOn]
		
		, [Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierCode]
		, [SENDER].[InterchangeIDQualifierCode] AS [SenderInterchangeIDQualifierCode]
		, [RECEIVER].[InterchangeIDQualifierCode] AS [ReceiverInterchangeIDQualifierCode]
		, [Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeCode]
		, [Transaction].[TransactionTypeCode].[TransactionTypeCodeCode]
		, [Transaction].[ClaimMedia].[ClaimMediaCode]
		, [Transaction].[ClaimMedia].[MaxDiagnosis]
		, [Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorCode]
		, [SUBMITTER].[EntityIdentifierCodeCode] AS [SubmitterEntityIdentifierCodeCode]
		, [RECEIVER1].[EntityIdentifierCodeCode] AS [ReceiverEntityIdentifierCodeCode]
		, [BILLING_PROVIDER].[EntityIdentifierCodeCode] AS [BillingProviderEntityIdentifierCodeCode]
		, [SUBSCRIBER].[EntityIdentifierCodeCode] AS [SubscriberEntityIdentifierCodeCode]
		, [PAYER].[EntityIdentifierCodeCode] AS [PayerEntityIdentifierCodeCode]
		, [PROVIDER].[EntityTypeQualifierCode] AS [ProviderEntityTypeQualifierCode]
		, [Transaction].[EntityTypeQualifier].[EntityTypeQualifierCode]
		, [Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeCode]
		, [EMAIL].[CommunicationNumberQualifierCode] AS [EmailCommunicationNumberQualifierCode]
		, [FAX].[CommunicationNumberQualifierCode] AS [FaxCommunicationNumberQualifierCode]
		, [PHONE].[CommunicationNumberQualifierCode] AS [PhoneCommunicationNumberQualifierCode]
		, [PATIENT].[EntityTypeQualifierCode] AS [PatientEntityTypeQualifierCode]
		, [INSURANCE].[EntityTypeQualifierCode] AS [InsuranceEntityTypeQualifierCode]
	FROM
		[EDI].[EDIReceiver]
	INNER JOIN
		[Transaction].[AuthorizationInformationQualifier]
	ON
		[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID] = [EDI].[EDIReceiver].[AuthorizationInformationQualifierID]
	INNER JOIN
		[Transaction].[InterchangeIDQualifier] SENDER
	ON
		[SENDER].[InterchangeIDQualifierID] = [EDI].[EDIReceiver].[SenderInterchangeIDQualifierID]
	INNER JOIN
		[Transaction].[InterchangeIDQualifier] RECEIVER
	ON
		[RECEIVER].[InterchangeIDQualifierID] = [EDI].[EDIReceiver].[ReceiverInterchangeIDQualifierID]
	INNER JOIN
		[Transaction].[TransactionSetPurposeCode]
	ON
		[Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeID] = [EDI].[EDIReceiver].[TransactionSetPurposeCodeID]
	INNER JOIN
		[Transaction].[TransactionTypeCode]
	ON
		[Transaction].[TransactionTypeCode].[TransactionTypeCodeID] = [EDI].[EDIReceiver].[TransactionTypeCodeID]
	INNER JOIN
		[Transaction].[ClaimMedia]
	ON
		[Transaction].[ClaimMedia].[ClaimMediaID] = [EDI].[EDIReceiver].[ClaimMediaID]
	INNER JOIN 
		[Transaction].[InterchangeUsageIndicator]
	ON
		[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorID] = [EDI].[EDIReceiver].[InterchangeUsageIndicatorID]
	INNER JOIN
		[Transaction].[EntityIdentifierCode] SUBMITTER
	ON
		[SUBMITTER].[EntityIdentifierCodeID] = [EDI].[EDIReceiver].[SubmitterEntityIdentifierCodeID]
	INNER JOIN
		[Transaction].[EntityIdentifierCode] RECEIVER1
	ON
		[RECEIVER1].[EntityIdentifierCodeID] = [EDI].[EDIReceiver].[ReceiverEntityIdentifierCodeID]
	INNER JOIN
		[Transaction].[EntityIdentifierCode] BILLING_PROVIDER
	ON
		[BILLING_PROVIDER].[EntityIdentifierCodeID] = [EDI].[EDIReceiver].[BillingProviderEntityIdentifierCodeID]
	INNER JOIN
		[Transaction].[EntityIdentifierCode] SUBSCRIBER
	ON
		[SUBSCRIBER].[EntityIdentifierCodeID] = [EDI].[EDIReceiver].[SubscriberEntityIdentifierCodeID]
	INNER JOIN
		[Transaction].[EntityIdentifierCode] PAYER
	ON
		[PAYER].[EntityIdentifierCodeID] = [EDI].[EDIReceiver].[PayerEntityIdentifierCodeID]
	INNER JOIN
		[Transaction].[EntityTypeQualifier] PROVIDER
	ON
		[PROVIDER].[EntityTypeQualifierID] = [EDI].[EDIReceiver].[ProviderEntityTypeQualifierID]
	INNER JOIN
		[Transaction].[EntityTypeQualifier] 
	ON
		[Transaction].[EntityTypeQualifier].[EntityTypeQualifierID] = [EDI].[EDIReceiver].[EntityTypeQualifierID]
	INNER JOIN
		[Transaction].[PayerResponsibilitySequenceNumberCode]
	ON
		[Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeID] = [EDI].[EDIReceiver].[PayerResponsibilitySequenceNumberCodeID]
	INNER JOIN
		[Transaction].[CommunicationNumberQualifier] EMAIL
	ON
		[EMAIL].[CommunicationNumberQualifierID] = [EDI].[EDIReceiver].[EmailCommunicationNumberQualifierID]
	INNER JOIN
		[Transaction].[CommunicationNumberQualifier] FAX
	ON
		[FAX].[CommunicationNumberQualifierID] = [EDI].[EDIReceiver].[FaxCommunicationNumberQualifierID]
	INNER JOIN
		[Transaction].[CommunicationNumberQualifier] PHONE
	ON
		[PHONE].[CommunicationNumberQualifierID] = [EDI].[EDIReceiver].[PhoneCommunicationNumberQualifierID]
	INNER JOIN
		[Transaction].[EntityTypeQualifier] PATIENT
	ON
		[PATIENT].[EntityTypeQualifierID] = [EDI].[EDIReceiver].[PatientEntityTypeQualifierID]
	INNER JOIN
		[Transaction].[EntityTypeQualifier] INSURANCE
	ON
		[INSURANCE].[EntityTypeQualifierID] = [EDI].[EDIReceiver].[InsuranceEntityTypeQualifierID]
		
	WHERE
		[EDI].[EDIReceiver].[EDIReceiverID] = @EDIReceiverID
	AND
		[EDI].[EDIReceiver].[IsActive] = 1
	AND
		[Transaction].[AuthorizationInformationQualifier].[IsActive] = 1
	AND
		[SENDER].[IsActive] = 1
	AND
		[RECEIVER].[IsActive] = 1
	AND
		[Transaction].[TransactionSetPurposeCode].[IsActive] = 1
	AND
		[Transaction].[TransactionTypeCode].[IsActive] = 1
	AND
		[Transaction].[ClaimMedia].[IsActive] = 1
	AND
		[Transaction].[InterchangeUsageIndicator].[IsActive] = 1
	AND
		[SUBMITTER].[IsActive] = 1
	AND
		[RECEIVER1].[IsActive] = 1
	AND
		[BILLING_PROVIDER].[IsActive] = 1
	AND
		[SUBSCRIBER].[IsActive] = 1
	AND
		[PAYER].[IsActive] = 1
	AND
		[PROVIDER].[IsActive] = 1
	AND
		[Transaction].[EntityTypeQualifier].[IsActive] = 1
	AND
		[Transaction].[PayerResponsibilitySequenceNumberCode].[IsActive] = 1
	AND
		[EMAIL].[IsActive] = 1
	AND
		[FAX].[IsActive] = 1
	AND
		[PHONE].[IsActive] = 1
	AND
		[PATIENT].[IsActive] = 1
	AND
		[INSURANCE].[IsActive] = 1
		
	-- EXEC [Claim].[usp_GetAnsi837EDIReceiver_ClaimProcess] 1
END
GO
