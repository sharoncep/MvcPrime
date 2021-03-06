USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_IsExists_PrintPin]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_IsExists_PrintPin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [EDI].[usp_IsExists_PrintPin]
	@PrintPinCode NVARCHAR(2)
	, @PrintPinName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @PrintPinID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @PrintPinID = [EDI].[ufn_IsExists_PrintPin] (@PrintPinCode, @PrintPinName, @Comment, 0);
END
GO
