CREATE TABLE [dbo].[MetaRelation] (
  [RelId] [int] IDENTITY,
  [ProfType] [varchar](3) NULL,
  [RelName] [varchar](64) NULL,
  [RelDuration] [float] NULL,
  [DisabledBy] [int] NULL,
  [DisabledAt] [datetime] NULL,
  CONSTRAINT [PK_MetaRelation] PRIMARY KEY CLUSTERED ([RelId])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[MetaRelation]
  ADD CONSTRAINT [FK_MetaRelation_DisabledBy] FOREIGN KEY ([DisabledBy]) REFERENCES [dbo].[UserList] ([UserId])
GO