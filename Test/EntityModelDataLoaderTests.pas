unit EntityModelDataLoaderTests;

interface

uses
  TestFramework
  ,Mapping.CodeGenerator.DB
  ,Mapping.CodeGenerator.Abstract
  ,Generics.Collections
  ,SysUtils
  ;

type
  TEntityModelDataLoaderTests = class(TTestCase)
  private
    FLoader: TEntityModelDataLoader;

    function FindEntity(const AEntityName: string; AList: TObjectList<TEntityModelData>): TEntityModelData;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure LoadTables();
  end;

implementation



{ TEntityModelDataLoaderTests }

function TEntityModelDataLoaderTests.FindEntity(const AEntityName: string; AList: TObjectList<TEntityModelData>): TEntityModelData;
begin
  for Result in AList do
  begin
    if SameText(Result.TableName, AEntityName) then
    begin
      Exit;
    end;
  end;
  Result := nil;
end;

procedure TEntityModelDataLoaderTests.LoadTables;
var
  LEntity: TEntityModelData;
begin
  FLoader.ConnectionString := 'Provider=MSDataShape;Data Source=audimas;Password=master;Persist Security Info=True;User ID=VIKARINA';
  FLoader.DefaultSchemaName := 'Vikarina';

  CheckTrue(FLoader.Connect);

  FLoader.LoadTables;
  CheckTrue(FLoader.Entities.Count > 0);

  LEntity := FindEntity('EXTMAPPINGS', FLoader.Entities);
  CheckTrue(Assigned(LEntity));
  CheckEquals(6, LEntity.Columns.Count);
end;

procedure TEntityModelDataLoaderTests.Setup;
begin
  inherited;
  FLoader := TEntityModelDataLoader.Create;
end;

procedure TEntityModelDataLoaderTests.TearDown;
begin
  inherited;
  FLoader.Free;
end;

initialization
  RegisterTest(TEntityModelDataLoaderTests.Suite);

end.
