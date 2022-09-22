CREATE TABLE [PROM].[FieldMapping] (
  [LocalRowId] [int] IDENTITY,
  [PromId] [int] NOT NULL,
  [FieldName] [varchar](64) NULL,
  [ItemId] [int] NOT NULL,
  CONSTRAINT [UC_PromId_FieldName] UNIQUE ([PromId], [FieldName])
)
ON [PRIMARY]
GO

ALTER TABLE [PROM].[FieldMapping]
  ADD CONSTRAINT [FK_PROM_FieldMapping_ItemId] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[MetaItem] ([ItemId])
GO

ALTER TABLE [PROM].[FieldMapping]
  ADD CONSTRAINT [FK_PROM_FieldMapping_PromId] FOREIGN KEY ([PromId]) REFERENCES [PROM].[FormMapping] ([PromId])
GO