IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Audit].[FK_SyncStatus_User_UserID]') AND parent_object_id = OBJECT_ID(N'[Audit].[SyncStatus]'))
ALTER TABLE [Audit].[SyncStatus] DROP CONSTRAINT [FK_SyncStatus_User_UserID]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SyncStatus_IsSuccess]') AND type = 'D')
BEGIN
ALTER TABLE [Audit].[SyncStatus] DROP CONSTRAINT [DF_SyncStatus_IsSuccess]
END
GO

/****** Object:  Table [Audit].[SyncStatus]    Script Date: 07/18/2013 12:06:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[SyncStatus]') AND type in (N'U'))
DROP TABLE [Audit].[SyncStatus]
GO

/****** Object:  Table [Audit].[SyncStatus]    Script Date: 07/18/2013 12:06:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Audit].[SyncStatus](
	[SyncStatusID] [bigint] IDENTITY(1,1) NOT NULL,
	[StartOn] [datetime] NOT NULL,
	[EndOn] [datetime] NULL,
	[IsSuccess] [bit] NOT NULL,
	[UserID] [int] NULL,
 CONSTRAINT [PK_SyncStatus] PRIMARY KEY CLUSTERED 
(
	[SyncStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [Audit].[SyncStatus]  WITH CHECK ADD  CONSTRAINT [FK_SyncStatus_User_UserID] FOREIGN KEY([UserID])
REFERENCES [User].[User] ([UserID])
GO

ALTER TABLE [Audit].[SyncStatus] CHECK CONSTRAINT [FK_SyncStatus_User_UserID]
GO

ALTER TABLE [Audit].[SyncStatus] ADD  CONSTRAINT [DF_SyncStatus_IsSuccess]  DEFAULT ((0)) FOR [IsSuccess]
GO


INSERT INTO [Audit].[SyncStatus] ([StartOn], [EndOn], [IsSuccess], [UserID]) VALUES ('1900-Jan-01', '1900-Jan-01', 1, 1);
GO

UPDATE [AccessPrivilege].[Page] SET [ControllerName] = 'RptDashboard' WHERE [ControllerName] = 'DashboardRpt';

UPDATE [AccessPrivilege].[Page] SET [ControllerName] = 'RptClinicAll' WHERE [ControllerName] = 'ClinicAllRpt';

UPDATE [AccessPrivilege].[Page] SET [ControllerName] = 'RptClinicAllSum' WHERE [ControllerName] = 'ClinicAllSumRpt';

UPDATE [AccessPrivilege].[Page] SET [ControllerName] = 'RptClinic'  WHERE [ControllerName] = 'ClinicRpt';

UPDATE [AccessPrivilege].[Page] SET [ControllerName] = 'RptClinicSel', SessionName = 'SelClinicID' WHERE [ControllerName] = 'ClinicSelRpt';

UPDATE [AccessPrivilege].[Page] SET [ControllerName] = 'RptAgent', SessionName = NULL WHERE [ControllerName] = 'AgentRpt';

UPDATE [AccessPrivilege].[Page] SET [SessionName] = NULL WHERE [ControllerName] = 'RptAgent';


--[AccessPrivilege].[Page]

SET IDENTITY_INSERT [AccessPrivilege].[Page] ON;

INSERT INTO [AccessPrivilege].[Page] ([PageID],[SessionName],[ControllerName],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(137, NULL, 'RptProviderwise', 1,1,CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[Page] ([PageID],[SessionName],[ControllerName],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(138, NULL, 'RptPatientWise', 1,1,CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[Page] ([PageID],[SessionName],[ControllerName],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(139, NULL, 'Case', 1,1,CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

SET IDENTITY_INSERT [AccessPrivilege].[Page] OFF;

UPDATE [AccessPrivilege].[Page] SET [ControllerName] = 'RptProviderWise' WHERE [ControllerName] = 'RptProviderwise';

--RptProviderwise_R
SET IDENTITY_INSERT [AccessPrivilege].[PageRole] ON;

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(716, '1', '137', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(717, '2', '137', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(718, '3', '137', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(719, '4', '137', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(720, '5', '137', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

SET IDENTITY_INSERT [AccessPrivilege].[PageRole] OFF;

--RptPatientWise_R
SET IDENTITY_INSERT [AccessPrivilege].[PageRole] ON;

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(721, '1', '138', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(722, '2', '138', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(723, '3', '138', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(724, '4', '138', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(725, '5', '138', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

SET IDENTITY_INSERT [AccessPrivilege].[PageRole] OFF;

--Case
SET IDENTITY_INSERT [AccessPrivilege].[PageRole] ON;

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(726, '1', '139', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]( [PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(727, '2', '139', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(728, '3', '139', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(729, '4', '139', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

INSERT INTO [AccessPrivilege].[PageRole]([PageRoleID], [RoleID],[PageID],[CreatePermission],[ReadPermission],[UpdatePermission],[DeletePermission],[IsActive],[LastModifiedBy],[LastModifiedOn],[CreatedBy],[CreatedOn])
	VALUES(730, '5', '139', 0, 1, 0, 0, 1, 1, CAST(0x0000A16A007E89BF AS DateTime), 1, CAST(0x0000A16A007E89BF AS DateTime));

SET IDENTITY_INSERT [AccessPrivilege].[PageRole] OFF;

