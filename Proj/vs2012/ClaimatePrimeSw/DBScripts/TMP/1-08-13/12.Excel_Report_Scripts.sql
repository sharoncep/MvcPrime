
/****** Object:  ForeignKey [FK_UserReport_ReportType_ReportTypeID]    Script Date: 07/26/2013 13:13:39 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Audit].[FK_UserReport_ReportType_ReportTypeID]') AND parent_object_id = OBJECT_ID(N'[Audit].[UserReport]'))
ALTER TABLE [Audit].[UserReport] DROP CONSTRAINT [FK_UserReport_ReportType_ReportTypeID]
GO
/****** Object:  ForeignKey [FK_ReportTypeHistory_ReportType_ReportTypeID]    Script Date: 07/26/2013 13:13:39 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Excel].[FK_ReportTypeHistory_ReportType_ReportTypeID]') AND parent_object_id = OBJECT_ID(N'[Excel].[ReportTypeHistory]'))
ALTER TABLE [Excel].[ReportTypeHistory] DROP CONSTRAINT [FK_ReportTypeHistory_ReportType_ReportTypeID]
GO
/****** Object:  Check [CK_ReportType_ReportTypeCode]    Script Date: 07/26/2013 13:13:39 ******/
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Excel].[CK_ReportType_ReportTypeCode]') AND parent_object_id = OBJECT_ID(N'[Excel].[ReportType]'))
BEGIN
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Excel].[CK_ReportType_ReportTypeCode]') AND parent_object_id = OBJECT_ID(N'[Excel].[ReportType]'))
ALTER TABLE [Excel].[ReportType] DROP CONSTRAINT [CK_ReportType_ReportTypeCode]

END
GO
/****** Object:  Table [Excel].[ReportTypeHistory]    Script Date: 07/26/2013 13:13:39 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Excel].[FK_ReportTypeHistory_ReportType_ReportTypeID]') AND parent_object_id = OBJECT_ID(N'[Excel].[ReportTypeHistory]'))
ALTER TABLE [Excel].[ReportTypeHistory] DROP CONSTRAINT [FK_ReportTypeHistory_ReportType_ReportTypeID]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Excel].[ReportTypeHistory]') AND type in (N'U'))
DROP TABLE [Excel].[ReportTypeHistory]
GO
/****** Object:  Table [Audit].[UserReport]    Script Date: 07/26/2013 13:13:39 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Audit].[FK_UserReport_ReportType_ReportTypeID]') AND parent_object_id = OBJECT_ID(N'[Audit].[UserReport]'))
ALTER TABLE [Audit].[UserReport] DROP CONSTRAINT [FK_UserReport_ReportType_ReportTypeID]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[UserReport]') AND type in (N'U'))
DROP TABLE [Audit].[UserReport]
GO
/****** Object:  Table [Excel].[ReportType]    Script Date: 07/26/2013 13:13:39 ******/
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Excel].[CK_ReportType_ReportTypeCode]') AND parent_object_id = OBJECT_ID(N'[Excel].[ReportType]'))
ALTER TABLE [Excel].[ReportType] DROP CONSTRAINT [CK_ReportType_ReportTypeCode]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Excel].[ReportType]') AND type in (N'U'))
DROP TABLE [Excel].[ReportType]
GO
/****** Object:  Schema [Excel]    Script Date: 07/26/2013 13:13:39 ******/
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'Excel')
DROP SCHEMA [Excel]
GO
/****** Object:  Schema [Excel]    Script Date: 07/26/2013 13:13:39 ******/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'Excel')
EXEC sys.sp_executesql N'CREATE SCHEMA [Excel] AUTHORIZATION [dbo]'
GO
/****** Object:  Table [Excel].[ReportType]    Script Date: 07/26/2013 13:13:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Excel].[ReportType]') AND type in (N'U'))
BEGIN
CREATE TABLE [Excel].[ReportType](
	[ReportTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ReportTypeCode] [nvarchar](2) NOT NULL,
	[ReportTypeName] [nvarchar](150) NOT NULL,
	[Comment] [nvarchar](4000) NULL,
	[IsActive] [bit] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[LastModifiedOn] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_ReportType] PRIMARY KEY CLUSTERED 
(
	[ReportTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UK_ReportType_ReportTypeCode] UNIQUE NONCLUSTERED 
(
	[ReportTypeCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Excel].[ReportType]') AND name = N'IX_ReportType1')
CREATE NONCLUSTERED INDEX [IX_ReportType1] ON [Excel].[ReportType] 
(
	[ReportTypeID] ASC,
	[ReportTypeName] ASC
)
INCLUDE ( [IsActive],
[ReportTypeCode]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET IDENTITY_INSERT [Excel].[ReportType] ON
INSERT [Excel].[ReportType] ([ReportTypeID], [ReportTypeCode], [ReportTypeName], [Comment], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn]) VALUES (1, N'01', N'CLINIC', N'Master Data', 1, 1, CAST(0x0000A16F01333B1B AS DateTime), 1, CAST(0x0000A16F01333B1B AS DateTime))
INSERT [Excel].[ReportType] ([ReportTypeID], [ReportTypeCode], [ReportTypeName], [Comment], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn]) VALUES (2, N'02', N'PROVIDER', N'Master Data', 1, 1, CAST(0x0000A16F0133447F AS DateTime), 1, CAST(0x0000A16F0133447F AS DateTime))
INSERT [Excel].[ReportType] ([ReportTypeID], [ReportTypeCode], [ReportTypeName], [Comment], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn]) VALUES (3, N'03', N'PATIENT', N'Master Data', 1, 1, CAST(0x0000A16F01335249 AS DateTime), 1, CAST(0x0000A16F01335249 AS DateTime))
INSERT [Excel].[ReportType] ([ReportTypeID], [ReportTypeCode], [ReportTypeName], [Comment], [IsActive], [LastModifiedBy], [LastModifiedOn], [CreatedBy], [CreatedOn]) VALUES (4, N'04', N'USER', N'Master Data', 1, 1, CAST(0x0000A16F01335249 AS DateTime), 1, CAST(0x0000A16F01335249 AS DateTime))
SET IDENTITY_INSERT [Excel].[ReportType] OFF
/****** Object:  Table [Audit].[UserReport]    Script Date: 07/26/2013 13:13:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[UserReport]') AND type in (N'U'))
BEGIN
CREATE TABLE [Audit].[UserReport](
	[UserReportID] [bigint] IDENTITY(1,1) NOT NULL,
	[ReportTypeID] [tinyint] NOT NULL,
	[ReportObjectID] [bigint] NULL,
	[DateFrom] [datetime] NULL,
	[DateTo] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_UserReport] PRIMARY KEY CLUSTERED 
(
	[UserReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [Excel].[ReportTypeHistory]    Script Date: 07/26/2013 13:13:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Excel].[ReportTypeHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [Excel].[ReportTypeHistory](
	[ReportTypeHistoryID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ReportTypeID] [tinyint] NOT NULL,
	[ReportTypeCode] [nvarchar](2) NOT NULL,
	[ReportTypeName] [nvarchar](150) NOT NULL,
	[Comment] [nvarchar](4000) NULL,
	[IsActive] [bit] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[LastModifiedOn] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_ReportTypeHistory] PRIMARY KEY CLUSTERED 
(
	[ReportTypeHistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Check [CK_ReportType_ReportTypeCode]    Script Date: 07/26/2013 13:13:39 ******/
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Excel].[CK_ReportType_ReportTypeCode]') AND parent_object_id = OBJECT_ID(N'[Excel].[ReportType]'))
ALTER TABLE [Excel].[ReportType]  WITH CHECK ADD  CONSTRAINT [CK_ReportType_ReportTypeCode] CHECK  ((len([ReportTypeCode])=(2)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Excel].[CK_ReportType_ReportTypeCode]') AND parent_object_id = OBJECT_ID(N'[Excel].[ReportType]'))
ALTER TABLE [Excel].[ReportType] CHECK CONSTRAINT [CK_ReportType_ReportTypeCode]
GO
/****** Object:  ForeignKey [FK_UserReport_ReportType_ReportTypeID]    Script Date: 07/26/2013 13:13:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Audit].[FK_UserReport_ReportType_ReportTypeID]') AND parent_object_id = OBJECT_ID(N'[Audit].[UserReport]'))
ALTER TABLE [Audit].[UserReport]  WITH CHECK ADD  CONSTRAINT [FK_UserReport_ReportType_ReportTypeID] FOREIGN KEY([ReportTypeID])
REFERENCES [Excel].[ReportType] ([ReportTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Audit].[FK_UserReport_ReportType_ReportTypeID]') AND parent_object_id = OBJECT_ID(N'[Audit].[UserReport]'))
ALTER TABLE [Audit].[UserReport] CHECK CONSTRAINT [FK_UserReport_ReportType_ReportTypeID]
GO
/****** Object:  ForeignKey [FK_ReportTypeHistory_ReportType_ReportTypeID]    Script Date: 07/26/2013 13:13:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Excel].[FK_ReportTypeHistory_ReportType_ReportTypeID]') AND parent_object_id = OBJECT_ID(N'[Excel].[ReportTypeHistory]'))
ALTER TABLE [Excel].[ReportTypeHistory]  WITH CHECK ADD  CONSTRAINT [FK_ReportTypeHistory_ReportType_ReportTypeID] FOREIGN KEY([ReportTypeID])
REFERENCES [Excel].[ReportType] ([ReportTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Excel].[FK_ReportTypeHistory_ReportType_ReportTypeID]') AND parent_object_id = OBJECT_ID(N'[Excel].[ReportTypeHistory]'))
ALTER TABLE [Excel].[ReportTypeHistory] CHECK CONSTRAINT [FK_ReportTypeHistory_ReportType_ReportTypeID]
GO
