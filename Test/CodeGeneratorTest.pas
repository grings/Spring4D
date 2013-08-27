unit CodeGeneratorTest;

interface

uses
  TestFramework
  ,Mapping.CodeGenerator
  ,Mapping.CodeGenerator.Abstract
  ;

type
  TCodeGeneratorTest = class(TTestCase)
  private
    FGenerator: TDelphiUnitCodeGenerator;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure GenerateSimpleEntity();
  end;

implementation

{ TCodeGeneratorTest }

procedure TCodeGeneratorTest.GenerateSimpleEntity;
var
  LGeneratedString: string;
  LEntityData: TEntityModelData;
  LColumn: TColumnData;
begin
  LEntityData := TEntityModelData.Create;
  try
    LEntityData.TableName := 'Customers';
    LEntityData.SchemaName := 'Vikarina';

    LColumn := TColumnData.Create;
    LColumn.ColumnName := 'CustName';
    LColumn.ColumnTypeName := 'string';
    LColumn.NotNull := True;
    LEntityData.Columns.Add(LColumn);

    LColumn := TColumnData.Create;
    LColumn.ColumnName := 'CustId';
    LColumn.IsAutogenerated := True;
    LColumn.IsPrimaryKey := True;
    LColumn.ColumnTypeName := 'Integer';
    LColumn.NotNull := True;
    LEntityData.Columns.Add(LColumn);


    LGeneratedString := FGenerator.Generate(LEntityData);
    CheckTrue(LGeneratedString <> '');
    CheckTrue(Pos('[Entity]', LGeneratedString) > 0);
    CheckTrue(Pos('[Column(''CustName''', LGeneratedString) > 0);
    Status(LGeneratedString);
  finally
    LEntityData.Free;
  end;
end;

procedure TCodeGeneratorTest.Setup;
begin
  inherited;
  FGenerator := TDelphiUnitCodeGenerator.Create;
end;

procedure TCodeGeneratorTest.TearDown;
begin
  inherited;
  FGenerator.Free;
end;

initialization
  RegisterTest(TCodeGeneratorTest.Suite);

end.
