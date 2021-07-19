object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 246
  Width = 427
  object ADOConnSatu: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;User ID=sa;Initial Catalog=siskeudes_sragen;Data Source' +
      '=.'
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
    Left = 232
    Top = 120
  end
end
