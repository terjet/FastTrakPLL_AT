CREATE TABLE [FEST].[Vilkar] (
  [Id] [varchar](40) NOT NULL,
  [Status] [char](1) NOT NULL,
  [Tidspunkt] [datetime] NOT NULL,
  [VilkarNr] [int] NOT NULL,
  [Gruppe] [int] NULL,
  [GjelderFor] [int] NULL,
  [Tekst] [varchar](max) NULL,
  [GyldigFraDato] [datetime] NOT NULL,
  [GyldigTilDato] [datetime] NULL,
  CONSTRAINT [PK_Vilkar] PRIMARY KEY CLUSTERED ([Id])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

GRANT SELECT ON [FEST].[Vilkar] TO [FastTrak]
GO