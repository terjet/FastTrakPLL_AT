CREATE TABLE [dbo].[MetaFormCarryException] (
  [RowId] [int] NOT NULL,
  [FormId] [int] NOT NULL,
  [ItemId] [int] NOT NULL,
  [EnumVal] [int] NOT NULL,
  [LastUpdate] [datetime] NOT NULL,
  [ChkSum] [int] NOT NULL CONSTRAINT [DF_MetaFormCarryException_ChkSum] DEFAULT (0),
  CONSTRAINT [PK_MetaFormCarryException] PRIMARY KEY CLUSTERED ([RowId])
)
ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[MetaFormCarryException] TO [FastTrak]
GO

ALTER TABLE [dbo].[MetaFormCarryException]
  ADD CONSTRAINT [FK_MetaFormCarryException_FormId] FOREIGN KEY ([FormId]) REFERENCES [dbo].[MetaForm] ([FormId])
GO

ALTER TABLE [dbo].[MetaFormCarryException]
  ADD CONSTRAINT [FK_MetaFormCarryException_ItemId] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[MetaItem] ([ItemId])
GO