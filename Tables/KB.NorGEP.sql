CREATE TABLE [KB].[NorGEP] (
  [Id] [int] NOT NULL,
  [ATC] [varchar](7) NULL,
  [MaxDose] [decimal](12, 2) NULL,
  [AgeLow] [int] NULL,
  [AgeHigh] [int] NULL,
  [Warning] [varchar](max) NOT NULL,
  CONSTRAINT [PK_NorGEP] PRIMARY KEY CLUSTERED ([Id])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO