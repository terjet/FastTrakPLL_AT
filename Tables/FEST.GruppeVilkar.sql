CREATE TABLE [FEST].[GruppeVilkar] (
  [Id] [uniqueidentifier] NOT NULL,
  [RefRefusjonsgruppe] [varchar](40) NOT NULL,
  [RefVilkar] [varchar](40) NOT NULL,
  CONSTRAINT [PK_GruppeVilkar] PRIMARY KEY CLUSTERED ([RefRefusjonsgruppe], [RefVilkar])
)
ON [PRIMARY]
GO

GRANT SELECT ON [FEST].[GruppeVilkar] TO [FastTrak]
GO

ALTER TABLE [FEST].[GruppeVilkar]
  ADD CONSTRAINT [FK_FEST_GruppeVilkar_RefRefusjonsgruppe] FOREIGN KEY ([RefRefusjonsgruppe]) REFERENCES [FEST].[Refusjonsgruppe] ([Id]) ON DELETE CASCADE
GO

ALTER TABLE [FEST].[GruppeVilkar]
  ADD CONSTRAINT [FK_FEST_GruppeVilkar_RefVilkar] FOREIGN KEY ([RefVilkar]) REFERENCES [FEST].[Vilkar] ([Id]) ON DELETE CASCADE
GO