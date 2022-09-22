CREATE TABLE [Comm].[MetaStatusCode] (
  [StatusCode] [int] NOT NULL,
  [StatusText] [varchar](32) NOT NULL,
  CONSTRAINT [PK_StatusCode] PRIMARY KEY CLUSTERED ([StatusCode])
)
ON [PRIMARY]
GO