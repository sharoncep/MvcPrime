USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_IsExists_PrintSign]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_IsExists_PrintSign]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [EDI].[usp_IsExists_PrintSign]
	@PrintSignCode NVARCHAR(2)
	, @PrintSignName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @PrintSignID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @PrintSignID = [EDI].[ufn_IsExists_PrintSign] (@PrintSignCode, @PrintSignName, @Comment, 0);
END
GO
