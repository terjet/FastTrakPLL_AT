CREATE TABLE [dbo].[MetaFormItem] (
  [FormId] [int] NOT NULL,
  [ItemId] [int] NOT NULL,
  [OrderNumber] [int] NOT NULL,
  [ItemHeader] [varchar](80) NULL,
  [ItemText] [varchar](max) NULL,
  [CreatedAt] [datetime] NULL CONSTRAINT [DF_MetaFormItem_CreatedAt] DEFAULT (getdate()),
  [CreatedBy] [int] NULL CONSTRAINT [DF_MetaFormItem_CreatedBy] DEFAULT (user_id()),
  [MinExpression] [varchar](max) NULL,
  [MaxExpression] [varchar](max) NULL,
  [Decimals] [tinyint] NULL,
  [Expression] [varchar](max) NULL,
  [ItemHelp] [varchar](max) NULL,
  [CarryForward] [tinyint] NULL,
  [ExcludeCaption] [bit] NULL,
  [LastUpdate] [datetime] NULL,
  [FormItemId] [int] NOT NULL,
  [ExcludeFromText] [bit] NULL,
  [Optional] [bit] NULL,
  [ReadOnly] [bit] NULL,
  [DefaultValue] [varchar](max) NULL,
  [Visibility] [int] NULL,
  [PageId] [int] NULL,
  [PageNumber] [int] NULL,
  [FormatStr] [varchar](48) NULL,
  [Label] [varchar](32) NULL,
  [Highlight] [tinyint] NULL,
  [QuantityFormatStr] [varchar](16) NULL,
  [ClearStrategy] [tinyint] NULL,
  [MaxCarryDays] [decimal](8, 2) NULL,
  [ExcludeFromPrint] [bit] NULL,
  [DisplayFormat] [varchar](64) NULL,
  [DetailFormId] [int] NULL,
  CONSTRAINT [PK_MetaFormItem] PRIMARY KEY CLUSTERED ([FormItemId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [I_MetaFormItem_FormItem]
  ON [dbo].[MetaFormItem] ([FormId], [ItemId])
  ON [PRIMARY]
GO

GRANT SELECT ON [dbo].[MetaFormItem] TO [FastTrak]
GO

ALTER TABLE [dbo].[MetaFormItem]
  ADD CONSTRAINT [FK_MetaFormItem_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[UserList] ([UserId])
GO

ALTER TABLE [dbo].[MetaFormItem]
  ADD CONSTRAINT [FK_MetaFormItem_DetailFormId] FOREIGN KEY ([DetailFormId]) REFERENCES [dbo].[MetaForm] ([FormId])
GO

ALTER TABLE [dbo].[MetaFormItem]
  ADD CONSTRAINT [FK_MetaFormItem_FormId] FOREIGN KEY ([FormId]) REFERENCES [dbo].[MetaForm] ([FormId]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[MetaFormItem]
  ADD CONSTRAINT [FK_MetaFormItem_ItemId] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[MetaItem] ([ItemId]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[MetaFormItem]
  ADD CONSTRAINT [FK_MetaFormItem_PageId] FOREIGN KEY ([PageId]) REFERENCES [dbo].[MetaFormPage] ([PageId]) ON DELETE CASCADE
GO