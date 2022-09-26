CREATE TABLE [dbo].[StudyCenter] (
  [CenterId] [int] IDENTITY,
  [CenterName] [varchar](40) NOT NULL,
  [CenterPostCode] [varchar](5) NULL,
  [CenterCity] [varchar](32) NULL,
  [CenterAddress] [varchar](32) NULL,
  [CenterPhone] [varchar](12) NULL,
  [BlockRules] [tinyint] NOT NULL CONSTRAINT [DF_StudyCenter_BlockRules] DEFAULT (0),
  [DatabaseId] [varchar](8) NULL,
  [CenterActive] [tinyint] NOT NULL CONSTRAINT [DF_StudyCenter_CenterActive] DEFAULT (1),
  [guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_StudyCenter_guid] DEFAULT (newid()) ROWGUIDCOL,
  [ReshId] [int] NULL,
  CONSTRAINT [PK_StudyCenter] PRIMARY KEY CLUSTERED ([CenterId])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_Study_CenterName]
  ON [dbo].[StudyCenter] ([CenterName])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[StudyCenter] TO [FastTrak]
GO

GRANT UPDATE ON [dbo].[StudyCenter] TO [superuser]
GO