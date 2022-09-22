CREATE TABLE [Pandemic].[LocalTracking] (
  [LocalId] [int] IDENTITY,
  [LocalKey] [varchar](8) NULL,
  [LocalName] [varchar](64) NULL,
  [PhoneNumber] [varchar](20) NULL,
  [EmailAddress] [varchar](64) NULL,
  [Popularity] [int] NULL,
  PRIMARY KEY CLUSTERED ([LocalId])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [I_Pandemic_LocalTracking]
  ON [Pandemic].[LocalTracking] ([LocalKey])
  ON [PRIMARY]
GO