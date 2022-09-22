CREATE TABLE [dbo].[MetaFormStatus] (
  [FormStatus] [char](1) NOT NULL,
  [StatusDesc] [varchar](8) NOT NULL,
  CONSTRAINT [PK_MetaFormStatus] PRIMARY KEY CLUSTERED ([FormStatus])
)
ON [PRIMARY]
GO