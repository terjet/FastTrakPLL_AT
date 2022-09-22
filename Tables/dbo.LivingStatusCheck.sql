CREATE TABLE [dbo].[LivingStatusCheck] (
  [NationalId] [varchar](16) NOT NULL,
  [LastChecked] [datetime] NOT NULL,
  [CheckStatus] [bit] NULL,
  [CheckMessage] [varchar](100) NULL,
  CONSTRAINT [PK_LivingStatusCheck] PRIMARY KEY CLUSTERED ([NationalId])
)
ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[LivingStatusCheck] TO [FastTrak]
GO