object Dm: TDm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 246
  Width = 427
  object ADOConnSatu: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;User ID=sa;Initial Catalog=siskeudes_sragen;Data Source' +
      '=.'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    BeforeConnect = ADOConnSatuBeforeConnect
    Left = 136
    Top = 112
  end
  object ADOConnDua: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;User ID=sa;Initial Catalog=siskeudes_sragen;Data Source' +
      '=.'
    Provider = 'SQLOLEDB.1'
    BeforeConnect = ADOConnDuaBeforeConnect
    Left = 248
    Top = 112
  end
end
