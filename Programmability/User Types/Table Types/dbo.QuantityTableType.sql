CREATE TYPE [dbo].[QuantityTableType] AS TABLE (
  [PersonId] [int] NOT NULL,
  [EventTime] [datetime] NOT NULL,
  [Quantity] [decimal](18, 4) NOT NULL,
  PRIMARY KEY CLUSTERED ([PersonId])
)
GO