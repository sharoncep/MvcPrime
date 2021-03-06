USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetByEDIReceiverID_EDIReceiver]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetByEDIReceiverID_EDIReceiver]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [EDI].[usp_GetByEDIReceiverID_EDIReceiver]
	@InsuranceID	BIGINT 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    SELECT
		[EDI].[EDIReceiver].[EDIReceiverID]
		, [EDI].[EDIReceiver].[EDIReceiverName] + ' [' + CAST([EDI].[EDIReceiver].[EDIReceiverCode] AS NVARCHAR) + ']' AS [NAME_CODE]
	FROM
		[EDI].[EDIReceiver]
	INNER JOIN
		[Insurance].[Insurance]
	ON
		[EDI].[EDIReceiver].[EDIReceiverID] = [Insurance].[Insurance].[EDIReceiverID]
	WHERE
		 [Insurance].[Insurance].[InsuranceID] = @InsuranceID
	
	-- EXEC [Insurance].[usp_GetByEDIReceiverID_EDIReceiver] @InsuranceID = 1
END
GO
