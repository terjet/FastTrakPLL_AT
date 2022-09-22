CREATE TABLE [dbo].[AlertResponse] (
  [ResponseId] [int] IDENTITY,
  [AlertId] [int] NOT NULL,
  [ActionId] [char](1) NOT NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_AlertResponse_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_AlertResponse_CreatedBy] DEFAULT (user_id()),
  [HideUntil] [datetime] NULL,
  CONSTRAINT [PK_AlertResponse] PRIMARY KEY CLUSTERED ([ResponseId])
)
ON [PRIMARY]
GO

CREATE INDEX [I_AlertResponse_AlertId]
  ON [dbo].[AlertResponse] ([AlertId])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[AlertResponse] TO [FastTrak]
GO

ALTER TABLE [dbo].[AlertResponse] WITH NOCHECK
  ADD CONSTRAINT [FK_AlertResponse_ActionId] FOREIGN KEY ([ActionId]) REFERENCES [dbo].[MetaAlertAction] ([ActionId])
GO

ALTER TABLE [dbo].[AlertResponse]
  ADD CONSTRAINT [FK_AlertResponse_AlertId] FOREIGN KEY ([AlertId]) REFERENCES [dbo].[Alert] ([AlertId]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[AlertResponse]
  ADD CONSTRAINT [FK_AlertResponse_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO