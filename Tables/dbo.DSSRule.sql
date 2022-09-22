CREATE TABLE [dbo].[DSSRule] (
  [RuleId] [int] NOT NULL,
  [RuleClass] [varchar](24) NOT NULL,
  [RuleType] [char](1) NOT NULL,
  [RuleProc] [nvarchar](128) NOT NULL,
  [RuleSourceCode] [ntext] NULL,
  [MinVersion] [int] NULL,
  [MaxVersion] [int] NULL,
  [LastUpdate] [datetime] NULL,
  [Title] [varchar](64) NULL,
  [Description] [varchar](max) NULL,
  [ChkSum] [int] NOT NULL CONSTRAINT [DF_DSSRule_ChkSum] DEFAULT (0),
  [NeedsRecompile] [bit] NOT NULL CONSTRAINT [DF_DSSRule_NeedsRecompile] DEFAULT (1),
  CONSTRAINT [PK_DSSRule] PRIMARY KEY CLUSTERED ([RuleId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO