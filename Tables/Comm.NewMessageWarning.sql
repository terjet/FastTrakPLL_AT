CREATE TABLE [Comm].[NewMessageWarning] (
  [WarnId] [int] IDENTITY,
  [PersonId] [int] NOT NULL,
  [NewMsgCount] [int] NULL,
  [LastUpdated] [datetime] NULL,
  CONSTRAINT [PK_NewMessageWarning] PRIMARY KEY CLUSTERED ([WarnId])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_NewMessageWarning_PersonId]
  ON [Comm].[NewMessageWarning] ([PersonId])
  ON [PRIMARY]
GO

ALTER TABLE [Comm].[NewMessageWarning]
  ADD CONSTRAINT [FK_Comm_NewMessageWarning_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
GO