USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetBySearch_EDIReceiver]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetBySearch_EDIReceiver]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [EDI].[usp_GetBySearch_EDIReceiver]	
	@OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
	, @IsActive BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
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
		[EDI].[EDIReceiver].[EDIReceiverID]
		, ROW_NUMBER() OVER (
			ORDER BY						
				CASE WHEN @OrderByField = 'EDIReceiverCode' AND @OrderByDirection = 'A' THEN [EDI].[EDIReceiver].[EDIReceiverCode] END ASC,
				CASE WHEN @orderByField = 'EDIReceiverCode' AND @orderByDirection = 'D' THEN [EDI].[EDIReceiver].[EDIReceiverCode] END DESC,
				
				CASE WHEN @OrderByField = 'AuthQual' AND @OrderByDirection = 'A' THEN ([Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierName] + ' [' +[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierCode] + ']') END ASC,
				CASE WHEN @orderByField = 'AuthQual' AND @orderByDirection = 'D' THEN ([Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierName] + ' [' +[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierCode] + ']') END DESC,
				
				CASE WHEN @OrderByField = 'ApplicationReceiverCode' AND @OrderByDirection = 'A' THEN [EDI].[EDIReceiver].[ApplicationReceiverCode] END ASC,
				CASE WHEN @orderByField = 'ApplicationReceiverCode' AND @orderByDirection = 'D' THEN [EDI].[EDIReceiver].[ApplicationReceiverCode] END DESC,
				
				CASE WHEN @OrderByField = 'ApplicationSenderCode' AND @OrderByDirection = 'A' THEN [EDI].[EDIReceiver].[ApplicationSenderCode] END ASC,
				CASE WHEN @orderByField = 'ApplicationSenderCode' AND @orderByDirection = 'D' THEN [EDI].[EDIReceiver].[ApplicationSenderCode] END DESC,
				
				--CASE WHEN @OrderByField = 'ReceiverID' AND @OrderByDirection = 'A' THEN [EDI].[EDIReceiver].[ReceiverID] END ASC,
				--CASE WHEN @orderByField = 'ReceiverID' AND @orderByDirection = 'D' THEN [EDI].[EDIReceiver].[ReceiverID] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [EDI].[EDIReceiver].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [EDI].[EDIReceiver].[LastModifiedOn] END DESC			
			) AS ROW_NUM
FROM
		[EDI].[EDIReceiver]
		
		INNER JOIN
		
		[Transaction].[AuthorizationInformationQualifier]
		
		ON
		
		[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID] = [EDI].[EDIReceiver].[AuthorizationInformationQualifierID]
		
	WHERE
		[EDI].[EDIReceiver].[IsActive] = CASE WHEN @IsActive IS NULL THEN [EDI].[EDIReceiver].[IsActive] ELSE @IsActive END;
		
	DECLARE @TBL_RES TABLE
	(
		[EDIReceiverID] INT NOT NULL 
		, [EDIReceiverCode] NVARCHAR(15) NOT NULL
		, [AuthQual] NVARCHAR(150) NOT NULL 
		,[ApplicationReceiverCode] NVARCHAR(25) NOT NULL
		,[ApplicationSenderCode] NVARCHAR(25) NOT NULL
		--,[ReceiverID]  NVARCHAR(25) NOT NULL
		, [IsActive] BIT NOT NULL 
	);

	INSERT INTO
		@TBL_RES
	SELECT		
		[EDIReceiver].[EDIReceiverID]
		, [EDIReceiver].[EDIReceiverCode]
		, ([AuthorizationInformationQualifier].[AuthorizationInformationQualifierName] + ' [' + [AuthorizationInformationQualifier].[AuthorizationInformationQualifierCode] + ']') as AuthQual
		,[EDIReceiver].[ApplicationReceiverCode]
		,[EDIReceiver].[ApplicationSenderCode]
		--,[EDIReceiver].[ReceiverID]
		, [EDIReceiver].[IsActive]
	FROM
		[EDIReceiver] WITH (NOLOCK)
		
		INNER JOIN
		
		[Transaction].[AuthorizationInformationQualifier]
		
		ON
		
		[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID] = [EDI].[EDIReceiver].[AuthorizationInformationQualifierID]
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [EDIReceiver].[EDIReceiverID]
	
		
	ORDER BY
		[ID]
	ASC;
	
	
	SELECT * FROM @TBL_RES;

	-- EXEC [EDI].[usp_GetBySearch_EDIReceiver]
	-- EXEC [EDI].[usp_GetBySearch_EDIReceiver] @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
