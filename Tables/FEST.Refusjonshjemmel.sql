CREATE TABLE [FEST].[Refusjonshjemmel] (
  [V] [int] NOT NULL,
  [S] [varchar](24) NULL,
  [DN] [varchar](max) NOT NULL,
  [KreverVedtak] [bit] NULL,
  [KreverVarekobling] [bit] NULL,
  [OldCodeId] [int] NULL,
  [ShortCode] [varchar](8) NULL,
  [Informasjon] [varchar](max) NULL,
  CONSTRAINT [PK_Refusjonshjemmel] PRIMARY KEY CLUSTERED ([V])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO