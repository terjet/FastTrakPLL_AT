CREATE TABLE [dbo].[LabMapping] (
  [MapId] [int] IDENTITY,
  [OrigCodeId] [int] NOT NULL,
  [MapToCodeId] [int] NULL,
  [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_LabMapping_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NOT NULL CONSTRAINT [DF_LabMapping_CreatedBy] DEFAULT (user_id()),
  CONSTRAINT [PK_LabMapping] PRIMARY KEY CLUSTERED ([MapId])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[LabMapping]
  ADD CONSTRAINT [FK_LabMapping_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO