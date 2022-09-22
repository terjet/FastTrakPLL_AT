CREATE TABLE [FEST].[KodeVilkar] (
  [Id] [uniqueidentifier] NOT NULL,
  [RefRefusjonskode] [uniqueidentifier] NOT NULL,
  [RefVilkar] [varchar](40) NOT NULL,
  CONSTRAINT [PK_KodeVilkar] PRIMARY KEY CLUSTERED ([RefRefusjonskode], [RefVilkar])
)
ON [PRIMARY]
GO

GRANT SELECT ON [FEST].[KodeVilkar] TO [FastTrak]
GO

ALTER TABLE [FEST].[KodeVilkar]
  ADD CONSTRAINT [FK_FEST_KodeVilkar_RefRefusjonskode] FOREIGN KEY ([RefRefusjonskode]) REFERENCES [FEST].[Refusjonskode] ([Id]) ON DELETE CASCADE
GO

ALTER TABLE [FEST].[KodeVilkar]
  ADD CONSTRAINT [FK_FEST_KodeVilkar_RefVilkar] FOREIGN KEY ([RefVilkar]) REFERENCES [FEST].[Vilkar] ([Id]) ON DELETE CASCADE
GO