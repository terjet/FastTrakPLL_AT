CREATE TABLE [dbo].[Study] (
  [StudyId] [int] IDENTITY,
  [StudName] [varchar](40) NOT NULL,
  [LabModule] [tinyint] NOT NULL CONSTRAINT [DF_Study_LabModule] DEFAULT (0),
  [ProblemModule] [tinyint] NOT NULL CONSTRAINT [DF_Study_ProblemModule] DEFAULT (0),
  [DrugModule] [tinyint] NOT NULL CONSTRAINT [DF_Study_DrugModule] DEFAULT (0),
  [CDSSModule] [tinyint] NOT NULL CONSTRAINT [DF_Study_CDSSModule] DEFAULT (0),
  [StudyName] AS ([StudName]),
  [FixedStatus] [bit] NOT NULL CONSTRAINT [DF_Study_FixedStatus] DEFAULT (0),
  [StudyLifecycle] [int] NOT NULL CONSTRAINT [DF_Study_StudyLifecycle] DEFAULT (2),
  CONSTRAINT [PK_Study] PRIMARY KEY CLUSTERED ([StudyId]),
  CONSTRAINT [IX_Study] UNIQUE ([StudName])
)
ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[Study] TO [FastTrak]
GO