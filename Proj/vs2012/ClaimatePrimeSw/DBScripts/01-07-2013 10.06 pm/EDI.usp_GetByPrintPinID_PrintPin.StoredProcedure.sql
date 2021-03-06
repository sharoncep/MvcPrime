USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetByPrintPinID_PrintPin]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetByPrintPinID_PrintPin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [EDI].[usp_GetByPrintPinID_PrintPin]
	@InsuranceID	BIGINT 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    SELECT
		[EDI].[PrintPin].[PrintPinID], [EDI].[PrintPin].[PrintPinName] + ' [' + [EDI].[PrintPin].[PrintPinCode] + ']' as [NAME_CODE]
	FROM
		[EDI].[PrintPin]
	INNER JOIN
		[Insurance].[Insurance]
	ON
		[EDI].[PrintPin].[PrintPinID] = [Insurance].[Insurance].[PrintPinID]
	WHERE
		 [Insurance].[Insurance].[InsuranceID] = @InsuranceID
	
	-- EXEC [EDI].[usp_GetByPrintPinID_PrintPin] @InsuranceID = 1
END
GO
