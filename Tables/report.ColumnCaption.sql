CREATE TABLE [report].[ColumnCaption] (
  [CaptionId] [int] NOT NULL,
  [VarSpec] [varchar](64) NULL,
  [Caption] [varchar](8) NULL,
  [ColWidth] [int] NULL,
  [ChkSum] [int] NOT NULL CONSTRAINT [DF_ColumnCaption_ChkSum] DEFAULT (0),
  [VarDescription] [varchar](255) NULL,
  CONSTRAINT [PK_Report_ColumnCaption] PRIMARY KEY CLUSTERED ([CaptionId])
)
ON [PRIMARY]
GO