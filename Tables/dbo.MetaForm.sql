CREATE TABLE [dbo].[MetaForm] (
  [FormId] [int] NOT NULL,
  [FormName] [varchar](24) NOT NULL,
  [FormTitle] [varchar](128) NOT NULL,
  [FormXML] [varchar](max) NULL,
  [CreatedAt] [datetime] NULL CONSTRAINT [DF_MetaForm_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NULL CONSTRAINT [DF_MetaForm_CreatedBy] DEFAULT (user_id()),
  [SurveyStatus] [varchar](6) NULL,
  [FormActive] AS (charindex('Open',[SurveyStatus])),
  [CalculateInvalid] [bit] NULL CONSTRAINT [DF_MetaForm_CalculateInvalid] DEFAULT (0),
  [RatingScale] [bit] NULL CONSTRAINT [DF_MetaForm_RatingScale] DEFAULT (0),
  [Copyright] [varchar](max) NULL,
  [Instructions] [varchar](max) NULL,
  [Repeatable] [bit] NULL,
  [ThreadTypeId] [int] NULL,
  [ParentId] [int] NULL,
  [Subtitle] [varchar](max) NULL,
  [LastUpdate] [datetime] NULL,
  [FormDateItemId] [int] NULL,
  [DaySpan] [int] NULL,
  [AfterSaveProcId] [int] NULL,
  CONSTRAINT [PK_MetaForm] PRIMARY KEY CLUSTERED ([FormId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [I_MetaForm_FormName]
  ON [dbo].[MetaForm] ([FormName])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[MetaForm] TO [FastTrak]
GO

ALTER TABLE [dbo].[MetaForm]
  ADD CONSTRAINT [FK_MetaForm_AfterSaveProcId] FOREIGN KEY ([AfterSaveProcId]) REFERENCES [dbo].[DbProcList] ([ProcId])
GO

ALTER TABLE [dbo].[MetaForm]
  ADD CONSTRAINT [FK_MetaForm_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[MetaForm]
  ADD CONSTRAINT [FK_MetaForm_FormDateItemId] FOREIGN KEY ([FormDateItemId]) REFERENCES [dbo].[MetaItem] ([ItemId])
GO

ALTER TABLE [dbo].[MetaForm]
  ADD CONSTRAINT [FK_MetaForm_ThreadTypeId] FOREIGN KEY ([ThreadTypeId]) REFERENCES [dbo].[MetaThreadType] ([V])
GO