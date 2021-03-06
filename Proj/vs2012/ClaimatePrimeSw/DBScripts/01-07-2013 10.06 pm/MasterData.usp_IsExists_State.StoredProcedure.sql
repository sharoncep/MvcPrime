USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_IsExists_State]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_IsExists_State]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [MasterData].[usp_IsExists_State]
	@StateCode NVARCHAR(2)
	, @StateName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @StateID	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @StateID = [MasterData].[ufn_IsExists_State] (@StateCode, @StateName, @Comment, 0);
END
GO
