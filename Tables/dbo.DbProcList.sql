CREATE TABLE [dbo].[DbProcList] (
  [ProcId] [int] NOT NULL,
  [ListId] [varchar](8) NOT NULL,
  [ProcName] [varchar](64) NOT NULL,
  [ProcDesc] [varchar](64) NOT NULL,
  [ProcParams] [varchar](64) NULL,
  [StudyName] [varchar](40) NULL,
  [ProcSourceCode] [varchar](max) NULL,
  [HelpText] [varchar](max) NULL,
  [InfoCaption] [varchar](64) NULL,
  [MinVersion] [int] NULL,
  [MaxVersion] [int] NULL,
  [LastUpdate] [datetime] NULL,
  [GrantTo] [varchar](max) NULL,
  [ChkSum] [int] NOT NULL CONSTRAINT [DF_DbProcList_ChkSum] DEFAULT (0),
  [NeedsRecompile] [bit] NOT NULL CONSTRAINT [DF_DbProcList_NeedsRecompile] DEFAULT (1),
  [DisabledAt] [datetime] NULL,
  [DisabledBy] [int] NULL,
  [DenyTo] [varchar](max) NULL,
  CONSTRAINT [PK_DbProcList] PRIMARY KEY CLUSTERED ([ProcId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[T_DbProcList_Recompile] ON [dbo].[DbProcList]
AFTER UPDATE AS 
BEGIN   
  IF UPDATE(ProcSourceCode) UPDATE dbo.DbProcList SET NeedsRecompile=1
  WHERE ProcId IN (SELECT ProcId FROM inserted );
END
GO

GRANT
  DELETE,
  UPDATE
ON [dbo].[DbProcList] TO [Administrator]
GO

GRANT SELECT ON [dbo].[DbProcList] TO [FastTrak]
GO

ALTER TABLE [dbo].[DbProcList]
  ADD CONSTRAINT [FK_DbProcList_DisabledBy] FOREIGN KEY ([DisabledBy]) REFERENCES [dbo].[UserList] ([UserId])
GO