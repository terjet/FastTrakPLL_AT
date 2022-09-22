CREATE TABLE [dbo].[LabClass] (
  [LabClassId] [int] NOT NULL,
  [FriendlyName] [varchar](128) NOT NULL,
  [VarName] [varchar](64) NULL,
  [IncludeRegEx] [varchar](max) NOT NULL,
  [ExcludeRegEx] [varchar](max) NULL,
  [Loinc] [varchar](8) NULL,
  [FurstId] [int] NULL,
  [UnitStr] [varchar](24) NULL,
  [MinValid] [decimal](12, 2) NULL,
  [MaxValid] [decimal](12, 2) NULL,
  [LastUpdate] [datetime] NOT NULL,
  [IsGroup] [bit] NULL,
  [TrustLevel] [int] NOT NULL CONSTRAINT [DF_LabClass_TrustLevel] DEFAULT (0),
  [NLK] [varchar](8) NULL,
  [ClassifyWithUnit] [bit] NOT NULL CONSTRAINT [DF_LabClass_ClassifyWithUnit] DEFAULT (0),
  [Decimals] [int] NULL,
  [ValidUntil] [date] NULL,
  [ValidFrom] [date] NULL,
  [ManualEntry] [bit] NULL,
  [SearchText] [varchar](64) NULL,
  CONSTRAINT [PK_LabClass] PRIMARY KEY CLUSTERED ([LabClassId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [IDX_LabClass_VarName]
  ON [dbo].[LabClass] ([VarName])
  ON [PRIMARY]
GO