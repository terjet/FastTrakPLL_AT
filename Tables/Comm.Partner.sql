CREATE TABLE [Comm].[Partner] (
  [PartnerId] [int] NOT NULL,
  [PartnerName] [varchar](64) NULL,
  [OrgId] [int] NULL,
  [HERId] [int] NULL,
  [HPRNo] [int] NULL,
  [LastUpdate] [datetime] NULL,
  CONSTRAINT [PK_Partner] PRIMARY KEY CLUSTERED ([PartnerId])
)
ON [PRIMARY]
GO

ALTER TABLE [Comm].[Partner]
  ADD CONSTRAINT [FK_Comm_Partner_OrgId] FOREIGN KEY ([OrgId]) REFERENCES [Comm].[Organization] ([OrgId])
GO