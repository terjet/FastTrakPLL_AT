CREATE TABLE [dbo].[ClinicalDataDeletion] (
  [LogId] [int] IDENTITY,
  [PersonId] [int] NOT NULL,
  [ReasonText] [varchar](max) NOT NULL,
  [DeletedAt] [datetime] NOT NULL CONSTRAINT [DF_ClinicalDataDeletion_DeletedAt] DEFAULT (getdate()),
  [DeletedBy] [int] NOT NULL CONSTRAINT [DF_ClinicalDataDeletion_DeletedBy] DEFAULT (user_id()),
  PRIMARY KEY CLUSTERED ([LogId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ClinicalDataDeletion]
  ADD CONSTRAINT [FK_ClinicalDataDeletion_DeletedBy] FOREIGN KEY ([DeletedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO