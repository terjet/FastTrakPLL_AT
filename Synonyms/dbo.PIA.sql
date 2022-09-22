CREATE SYNONYM [dbo].[PIA] FOR [FEST].[PIA]
GO

GRANT
  DELETE,
  INSERT,
  UPDATE
ON [dbo].[PIA] TO [Administrator]
GO

GRANT SELECT ON [dbo].[PIA] TO [FastTrak]
GO