CREATE TABLE [dbo].[DrugReason] (
  [ATC] [varchar](7) NOT NULL,
  [ReasonType] [int] NOT NULL,
  [ReasonText] [varchar](64) NOT NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_DrugReason_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NULL CONSTRAINT [DF_DrugReason_CreatedBy] DEFAULT (user_id()),
  CONSTRAINT [PK_DrugReason] PRIMARY KEY CLUSTERED ([ATC], [ReasonType], [ReasonText])
)
ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[DrugReason] TO [FastTrak]
GO

ALTER TABLE [dbo].[DrugReason]
  ADD CONSTRAINT [FK_DrugReason_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[DrugReason] WITH NOCHECK
  ADD CONSTRAINT [FK_DrugReason_ReasonType] FOREIGN KEY ([ReasonType]) REFERENCES [dbo].[MetaReasonType] ([ReasonType])
GO