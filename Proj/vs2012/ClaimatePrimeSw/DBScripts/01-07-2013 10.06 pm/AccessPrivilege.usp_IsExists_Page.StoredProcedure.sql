USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [AccessPrivilege].[usp_IsExists_Page]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [AccessPrivilege].[usp_IsExists_Page]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [AccessPrivilege].[usp_IsExists_Page]
	@SessionName NVARCHAR(15) = NULL
	, @ControllerName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @PageID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @PageID = [AccessPrivilege].[ufn_IsExists_Page] (@SessionName, @ControllerName, @Comment, 0);
END
GO
