CREATE TABLE [dbo].[KBAnticholinDrug] (
  [ATC] [varchar](7) NOT NULL,
  [DrugName] [varchar](32) NOT NULL,
  [AlertLevel] [char](1) NOT NULL,
  CONSTRAINT [PK_KBAnticholin] PRIMARY KEY CLUSTERED ([ATC])
)
ON [PRIMARY]
GO