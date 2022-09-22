CREATE TABLE [dbo].[PostalCodeRegister] (
  [RowId] [int] IDENTITY,
  [Country] [int] NOT NULL CONSTRAINT [DF_PostalCodeRegister_Country] DEFAULT (47),
  [PostalCode] [varchar](12) NOT NULL,
  [City] [varchar](32) NULL,
  [MuniCode] [varchar](4) NULL,
  [MuniName] [varchar](32) NULL,
  [CodeType] [char](1) NULL
)
ON [PRIMARY]
GO