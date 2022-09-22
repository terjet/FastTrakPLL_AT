CREATE SYNONYM [dbo].[KBAtcIndex] FOR [FEST].[AtcIndex]
GO

GRANT
  DELETE,
  INSERT,
  UPDATE
ON [dbo].[KBAtcIndex] TO [Administrator]
GO

GRANT SELECT ON [dbo].[KBAtcIndex] TO [FastTrak]
GO