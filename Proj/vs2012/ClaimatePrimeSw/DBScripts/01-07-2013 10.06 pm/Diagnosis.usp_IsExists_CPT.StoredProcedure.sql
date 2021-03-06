USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_IsExists_CPT]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_IsExists_CPT]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Diagnosis].[usp_IsExists_CPT]
	@CPTCode NVARCHAR(9)
	, @ShortDesc NVARCHAR(150) = NULL
	, @MediumDesc NVARCHAR(150) = NULL
	, @LongDesc NVARCHAR(255) = NULL
	, @CustomDesc NVARCHAR(150) = NULL
	, @ChargePerUnit DECIMAL
	, @IsHCPCSCode BIT
	, @Comment NVARCHAR(4000) = NULL
	, @CPTID	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @CPTID = [Diagnosis].[ufn_IsExists_CPT] (@CPTCode, @ShortDesc, @MediumDesc, @LongDesc, @CustomDesc, @ChargePerUnit, @IsHCPCSCode, @Comment, 0);
END
GO
