CREATE SYNONYM [dbo].[KBInteraction] FOR [FEST].[Interaction]
GO

GRANT
  DELETE,
  INSERT,
  UPDATE
ON [dbo].[KBInteraction] TO [Administrator]
GO

GRANT SELECT ON [dbo].[KBInteraction] TO [FastTrak]
GO