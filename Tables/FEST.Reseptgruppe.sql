CREATE TABLE [FEST].[Reseptgruppe] (
  [V] [char](2) NOT NULL,
  [DN] [varchar](24) NOT NULL,
  CONSTRAINT [PK_Reseptgruppe] PRIMARY KEY CLUSTERED ([V])
)
ON [PRIMARY]
GO

GRANT SELECT ON [FEST].[Reseptgruppe] TO [FastTrak]
GO