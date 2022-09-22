CREATE TABLE [dbo].[MetaStudyForm] (
  [StudyId] [int] NOT NULL,
  [FormId] [int] NOT NULL,
  [Popularity] [int] NULL,
  [PopularityDate] [datetime] NULL,
  [CreatedAt] [datetime] NULL CONSTRAINT [DF_MetaStudyForm_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NULL CONSTRAINT [DF_MetaStudyForm_CreatedBy] DEFAULT (user_id()),
  [ParentId] [int] NULL,
  [Repeatable] [bit] NULL,
  [SurveyStatus] [varchar](6) NULL,
  [FormActive] AS (charindex('Open',[SurveyStatus])),
  [LastUpdate] [datetime] NULL,
  [StudyFormId] [int] NOT NULL,
  [HideComment] [tinyint] NULL,
  [FormTitle] [varchar](128) NOT NULL,
  [MonthInterval] [int] NULL,
  [DisabledAt] [datetime] NULL,
  [DisabledBy] [int] NULL,
  [SortOrder] [smallint] NULL,
  CONSTRAINT [PK_MetaStudyForm] PRIMARY KEY CLUSTERED ([StudyFormId])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_MetaStudyForm_StudyForm]
  ON [dbo].[MetaStudyForm] ([StudyId], [FormId])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[MetaStudyForm] TO [FastTrak]
GO

ALTER TABLE [dbo].[MetaStudyForm]
  ADD CONSTRAINT [FK_MetaStudyForm_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[MetaStudyForm]
  ADD CONSTRAINT [FK_MetaStudyForm_DisabledBy] FOREIGN KEY ([DisabledBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[MetaStudyForm]
  ADD CONSTRAINT [FK_MetaStudyForm_FormId] FOREIGN KEY ([FormId]) REFERENCES [dbo].[MetaForm] ([FormId])
GO

ALTER TABLE [dbo].[MetaStudyForm]
  ADD CONSTRAINT [FK_MetaStudyForm_StudyId] FOREIGN KEY ([StudyId]) REFERENCES [dbo].[Study] ([StudyId])
GO