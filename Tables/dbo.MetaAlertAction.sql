CREATE TABLE [dbo].[MetaAlertAction] (
  [ActionId] [char](1) NOT NULL,
  [ActionName] [varchar](64) NULL,
  [HideDays] [int] NULL,
  CONSTRAINT [PK_MetaAlertAction] PRIMARY KEY CLUSTERED ([ActionId])
)
ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[MetaAlertAction] TO [FastTrak]
GO