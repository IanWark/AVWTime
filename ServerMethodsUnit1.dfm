object ServerMethods1: TServerMethods1
  OldCreateOrder = False
  Height = 449
  Width = 754
  object FDConnection: TFDConnection
    Params.Strings = (
      'DriverID=DB2')
    LoginPrompt = False
    Left = 24
    Top = 16
  end
  object FDPhysDB2DriverLink1: TFDPhysDB2DriverLink
    Left = 240
    Top = 16
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 128
    Top = 16
  end
  object FDQuery_Clients: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT clientID FROM tclient')
    Left = 376
    Top = 200
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 496
    Top = 16
  end
  object FDStanStorageBinLink1: TFDStanStorageBinLink
    Left = 360
    Top = 16
  end
  object FDQuery_Year: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      '/* This Year */'
      'SELECT NVL(SUM(hours),0) as hours, SUM(earnings) as earnings,'
      'SUM(paid) as paid, SUM(unpaid) as unpaid, MAX(year) as year'
      'FROM'
      '(SELECT SUM(hrs) as hours,'
      'SUM(hrs*rate) as earnings,'
      'SUM(hrs) as paid,'
      '0 as unpaid,'
      'MAX(YEAR(tx_date)) as year'
      'FROM ttime'
      'WHERE YEAR(tx_date) in (:Year)'
      'AND rate > 0'
      ''
      'UNION'
      ''
      'SELECT SUM(hrs) as hours,'
      '0 as earnings,'
      '0 as paid,'
      'SUM(hrs) as unpaid,'
      'MAX(YEAR(tx_date)) as year'
      'FROM ttime'
      'WHERE YEAR(tx_date) in (:Year)'
      'AND rate = 0)'
      ''
      'UNION'
      ''
      '/* Last Year */'
      'SELECT NVL(SUM(hours),0) as hours, SUM(earnings) as earnings,'
      'SUM(paid) as paid, SUM(unpaid) as unpaid, MAX(year) as year'
      'FROM'
      '(SELECT SUM(hrs) as hours,'
      'SUM(hrs*rate) as earnings,'
      'SUM(hrs) as paid,'
      '0 as unpaid,'
      'MAX(YEAR(tx_date)) as year'
      'FROM ttime'
      'WHERE YEAR(tx_date) in (:Year-1)'
      'AND rate > 0'
      ''
      'UNION'
      ''
      'SELECT SUM(hrs) as hours,'
      '0 as earnings,'
      '0 as paid,'
      'SUM(hrs) as unpaid,'
      'MAX(YEAR(tx_date)) as year'
      'FROM ttime'
      'WHERE YEAR(tx_date) in (:Year-1)'
      'AND rate = 0)'
      ''
      'ORDER BY year DESC')
    Left = 640
    Top = 128
    ParamData = <
      item
        Name = 'YEAR'
        DataType = ftWord
        ParamType = ptInput
      end>
  end
  object FDQuery_Day: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      
        'SELECT time_id, client_id, tx_date, tx_from, tx_to, hrs, rate, q' +
        'ty, amt, inv, tx_comment'
      'FROM allanwa.ttime'
      'WHERE DATE(tx_date) = :date')
    Left = 24
    Top = 104
    ParamData = <
      item
        Name = 'DATE'
        DataType = ftWideString
        ParamType = ptInput
      end>
  end
  object FDQuery_Add: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT time_id FROM NEW TABLE('
      'INSERT INTO ttime '
      '(client_id, tx_date, tx_from, tx_to,'
      ' hrs, rate, qty, amt, tx_comment, inv, tx_user)'
      'VALUES'
      '(:client_id, :tx_date, :tx_from, :tx_to,'
      ' :hrs, :rate, :qty, :amt, :tx_comment, :inv, :tx_user))')
    Left = 24
    Top = 200
    ParamData = <
      item
        Name = 'CLIENT_ID'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'TX_DATE'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'TX_FROM'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'TX_TO'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'HRS'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'RATE'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'QTY'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'AMT'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'TX_COMMENT'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'INV'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'TX_USER'
        DataType = ftWideString
        ParamType = ptInput
      end>
  end
  object FDQuery_Rate: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT rate FROM tclient'
      'WHERE clientid = :clientid')
    Left = 104
    Top = 200
    ParamData = <
      item
        Name = 'CLIENTID'
        DataType = ftWideString
        ParamType = ptInput
      end>
  end
  object FDQuery_Edit: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'UPDATE ttime'
      'SET client_id = :client_id, tx_date = :tx_date,'
      'tx_from = :tx_from, tx_to = :tx_to, hrs = :hrs,'
      'rate = :rate, qty = :qty, amt = :amt,'
      'tx_comment = :tx_comment, inv = :inv,'
      'tx_user = :tx_user '
      'WHERE time_id = :time_id')
    Left = 184
    Top = 200
    ParamData = <
      item
        Name = 'CLIENT_ID'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'TX_DATE'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'TX_FROM'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'TX_TO'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'HRS'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'RATE'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'QTY'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'AMT'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'TX_COMMENT'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'INV'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'TX_USER'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'TIME_ID'
        DataType = ftWideString
        ParamType = ptInput
      end>
  end
  object FDQuery_Week: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT client_id, hrs, hrs*rate as earnings FROM ttime'
      'WHERE DATE(tx_date) = :date')
    Left = 104
    Top = 104
    ParamData = <
      item
        Name = 'DATE'
        DataType = ftWideString
        ParamType = ptInput
      end>
  end
  object FDQuery_LastTime: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT MAX(tx_to) as last FROM ttime'
      'where DATE(tx_date) = :date')
    Left = 280
    Top = 200
    ParamData = <
      item
        Name = 'DATE'
        DataType = ftWideString
        ParamType = ptInput
      end>
  end
  object FDQuery_Month: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      '/* This Year */'
      'SELECT NVL(SUM(hours),0) AS hours, SUM(earnings) AS earnings, '
      'SUM(paid) AS paid, SUM(unpaid) AS unpaid, MAX(year) as year'
      'FROM'
      ''
      '(SELECT SUM(p.hrs) AS hours,'
      'SUM(p.hrs*p.rate) AS earnings, '
      'SUM(p.hrs) AS paid, '
      '0 AS unpaid,'
      'MAX(YEAR(tx_date)) as year'
      'FROM ttime p'
      'WHERE YEAR(p.tx_date) = :Year '
      'AND MONTH(p.tx_date) = :Month'
      'AND p.rate > 0'
      ''
      'UNION'
      ''
      'SELECT SUM(u.hrs) AS hours,'
      '0 AS earnings, '
      '0 AS paid, '
      'SUM(u.hrs) AS unpaid,'
      'MAX(YEAR(tx_date)) as year'
      'FROM ttime u'
      'WHERE YEAR(u.tx_date) = :Year '
      'AND MONTH(u.tx_date) = :Month'
      'AND u.rate = 0)'
      ''
      'UNION'
      ''
      '/* Last Year */'
      'SELECT NVL(SUM(hours),0) AS hours, SUM(earnings) AS earnings, '
      'SUM(paid) AS paid, SUM(unpaid) AS unpaid, MAX(year) as year'
      'FROM'
      ''
      '(SELECT SUM(p.hrs) AS hours,'
      'SUM(p.hrs*p.rate) AS earnings, '
      'SUM(p.hrs) AS paid, '
      '0 AS unpaid,'
      'MAX(YEAR(tx_date)) as year'
      'FROM ttime p'
      'WHERE YEAR(p.tx_date) = :Year-1'
      'AND MONTH(p.tx_date) = :Month'
      'AND p.rate > 0'
      ''
      'UNION'
      ''
      'SELECT SUM(u.hrs) AS hours,'
      '0 AS earnings, '
      '0 AS paid, '
      'SUM(u.hrs) AS unpaid,'
      'MAX(YEAR(tx_date)) as year'
      'FROM ttime u'
      'WHERE YEAR(u.tx_date) = :Year-1'
      'AND MONTH(u.tx_date) = :Month'
      'AND u.rate = 0)'
      ''
      'ORDER BY year DESC')
    Left = 640
    Top = 200
    ParamData = <
      item
        Name = 'YEAR'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'MONTH'
        DataType = ftWideString
        ParamType = ptInput
      end>
  end
  object FDQuery_Delete: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'DELETE FROM ttime '
      'WHERE time_id = :Time_ID')
    Left = 64
    Top = 256
    ParamData = <
      item
        Name = 'TIME_ID'
        ParamType = ptInput
      end>
  end
end
