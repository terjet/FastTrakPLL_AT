CREATE TABLE [dbo].[MetaFormAction] (
  [OrderNumber] [int] NOT NULL,
  [FormId] [int] NOT NULL,
  [PageConditionId] [int] NOT NULL,
  [MasterId] [int] NOT NULL,
  [DetailId] [int] NOT NULL,
  [ComparisonType] [int] NULL,
  [MasterEnumVal] [int] NULL,
  [LastUpdate] [datetime] NOT NULL,
  CONSTRAINT [PK_MetaFormAction] PRIMARY KEY CLUSTERED ([OrderNumber])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[MetaFormAction]
  ADD CONSTRAINT [FK_MetaFormAction_FormId] FOREIGN KEY ([FormId]) REFERENCES [dbo].[MetaForm] ([FormId])
GO