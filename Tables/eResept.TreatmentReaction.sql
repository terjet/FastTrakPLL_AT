CREATE TABLE [eResept].[TreatmentReaction] (
  [RowId] [int] IDENTITY,
  [LegemiddelId] [varchar](40) NOT NULL,
  [CaveId] [varchar](40) NOT NULL,
  [CreatedAt] [datetime] NOT NULL DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL DEFAULT (user_id()),
  [UpdatedAt] [datetime] NOT NULL DEFAULT (getdate()),
  [UpdatedBy] [int] NOT NULL DEFAULT (user_id()),
  [DeletedAt] [datetime] NULL,
  [DeletedBy] [int] NULL,
  PRIMARY KEY CLUSTERED ([RowId])
)
ON [PRIMARY]
GO

ALTER TABLE [eResept].[TreatmentReaction]
  ADD FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [eResept].[TreatmentReaction]
  ADD FOREIGN KEY ([DeletedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [eResept].[TreatmentReaction]
  ADD FOREIGN KEY ([UpdatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO