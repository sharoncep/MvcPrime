USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_IsExists_Modifier]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_IsExists_Modifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Diagnosis].[usp_IsExists_Modifier]
	@ModifierCode NVARCHAR(2)
	, @ModifierName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @ModifierID	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @ModifierID = [Diagnosis].[ufn_IsExists_Modifier] (@ModifierCode, @ModifierName, @Comment, 0);
END
GO
