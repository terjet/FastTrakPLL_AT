CREATE TABLE [dbo].[MetaAlertLevel] (
  [AlertLevel] [tinyint] NOT NULL,
  [LevelDesc] [varchar](16) NOT NULL,
  CONSTRAINT [PK_MetaAlertLevel] PRIMARY KEY CLUSTERED ([AlertLevel])
)
ON [PRIMARY]
GO