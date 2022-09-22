CREATE TABLE [FEST].[Refusjonsgruppe] (
  [Id] [varchar](40) NOT NULL,
  [Status] [char](1) NOT NULL,
  [Tidspunkt] [datetime] NOT NULL,
  [RefRefusjonshjemmel] [int] NULL,
  [GruppeNr] [varchar](12) NOT NULL,
  [GruppeNavn] [varchar](max) NULL,
  [Atc] [varchar](7) NULL,
  [KreverRefusjonskode] [bit] NOT NULL,
  [RefusjonsberettigetBruk] [varchar](max) NULL,
  CONSTRAINT [PK_Refusjonsgruppe] PRIMARY KEY CLUSTERED ([Id])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE UNIQUE INDEX [IDX_Refusjonsgruppe_Gruppenr]
  ON [FEST].[Refusjonsgruppe] ([GruppeNr])
  ON [PRIMARY]
GO

ALTER TABLE [FEST].[Refusjonsgruppe]
  ADD CONSTRAINT [FK_FEST_Refusjonsgruppe_RefRefusjonshjemmel] FOREIGN KEY ([RefRefusjonshjemmel]) REFERENCES [FEST].[Refusjonshjemmel] ([V])
GO