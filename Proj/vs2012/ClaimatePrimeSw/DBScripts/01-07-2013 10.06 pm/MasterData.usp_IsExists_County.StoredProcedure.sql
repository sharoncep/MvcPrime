USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_IsExists_County]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_IsExists_County]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [MasterData].[usp_IsExists_County]
	@CountyCode NVARCHAR(6)
	, @CountyName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CountyID	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @CountyID = [MasterData].[ufn_IsExists_County] (@CountyCode, @CountyName, @Comment, 0);
END
GO
