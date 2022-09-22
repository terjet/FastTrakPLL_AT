CREATE TABLE [FEST].[Refusjonskode] (
  [Id] [uniqueidentifier] NOT NULL,
  [RefRefusjonsgruppe] [varchar](40) NOT NULL,
  [V] [varchar](6) NOT NULL,
  [S] [varchar](32) NOT NULL,
  [DN] [varchar](max) NOT NULL,
  [OID] [int] NOT NULL,
  [Underterm] [varchar](max) NULL,
  [RefVilkar] [uniqueidentifier] NULL,
  [GyldigFraDato] [datetime] NOT NULL,
  [GyldigTilDato] [datetime] NULL,
  [ICPC2] AS ((1)-abs(sign([OID]-(7170)))),
  [ICD10] AS ((1)-abs(sign([OID]-(7110)))),
  CONSTRAINT [PK_Refusjonskode] PRIMARY KEY CLUSTERED ([Id])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

GRANT SELECT ON [FEST].[Refusjonskode] TO [FastTrak]
GO

ALTER TABLE [FEST].[Refusjonskode]
  ADD CONSTRAINT [FK_FEST_Refusjonskode_RefRefusjonsgruppe] FOREIGN KEY ([RefRefusjonsgruppe]) REFERENCES [FEST].[Refusjonsgruppe] ([Id]) ON DELETE CASCADE
GO