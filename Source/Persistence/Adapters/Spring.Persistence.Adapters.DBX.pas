{***************************************************************************}
{                                                                           }
{           Spring Framework for Delphi                                     }
{                                                                           }
{           Copyright (c) 2009-2015 Spring4D Team                           }
{                                                                           }
{           http://www.spring4d.org                                         }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  Licensed under the Apache License, Version 2.0 (the "License");          }
{  you may not use this file except in compliance with the License.         }
{  You may obtain a copy of the License at                                  }
{                                                                           }
{      http://www.apache.org/licenses/LICENSE-2.0                           }
{                                                                           }
{  Unless required by applicable law or agreed to in writing, software      }
{  distributed under the License is distributed on an "AS IS" BASIS,        }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{  See the License for the specific language governing permissions and      }
{  limitations under the License.                                           }
{                                                                           }
{***************************************************************************}

{$I Spring.inc}

unit Spring.Persistence.Adapters.DBX;

interface

uses
  DBXCommon,
  SqlExpr,
  SysUtils,
  Spring.Collections,
  Spring.Persistence.Adapters.FieldCache,
  Spring.Persistence.Core.Base,
  Spring.Persistence.Core.Exceptions,
  Spring.Persistence.Core.Interfaces,
  Spring.Persistence.SQL.Params;

type
  EDBXAdapterException = class(EORMAdapterException);

  /// <summary>
  ///   Represents DBX resultset.
  /// </summary>
  TDBXResultSetAdapter = class(TDriverResultSetAdapter<TSQLQuery>)
  private
    fFieldCache: IFieldCache;
  public
    constructor Create(const dataSet: TSQLQuery;
      const exceptionHandler: IORMExceptionHandler); override;
    destructor Destroy; override;

    function IsEmpty: Boolean; override;
    function Next: Boolean; override;
    function FieldExists(const fieldName: string): Boolean; override;
    function GetFieldValue(index: Integer): Variant; overload; override;
    function GetFieldValue(const fieldname: string): Variant; overload; override;
    function GetFieldCount: Integer; override;
    function GetFieldName(index: Integer): string; override;
  end;

  /// <summary>
  ///   Represents DBX statement.
  /// </summary>
  TDBXStatementAdapter = class(TDriverStatementAdapter<TSQLQuery>)
  public
    destructor Destroy; override;
    procedure SetSQLCommand(const commandText: string); override;
    procedure SetParam(const param: TDBParam); virtual;
    procedure SetParams(const params: IEnumerable<TDBParam>); overload; override;
    function Execute: NativeUInt; override;
    function ExecuteQuery(serverSideCursor: Boolean = True): IDBResultSet; override;
  end;

  /// <summary>
  ///   Represents DBX connection.
  /// </summary>
  TDBXConnectionAdapter = class(TDriverConnectionAdapter<TSQLConnection>)
  protected
    constructor Create(const connection: TSQLConnection;
      const exceptionHandler: IORMExceptionHandler); overload; override;
  public
    constructor Create(const connection: TSQLConnection); overload; override;

    procedure Connect; override;
    procedure Disconnect; override;
    function IsConnected: Boolean; override;
    function CreateStatement: IDBStatement; override;
    function BeginTransaction: IDBTransaction; override;
  end;

  /// <summary>
  ///   Represents DBX transaction.
  /// </summary>
  TDBXTransactionAdapter = class(TDriverTransactionAdapter<TDBXTransaction>)
  protected
    function InTransaction: Boolean; override;
  public
    procedure Commit; override;
    procedure Rollback; override;
  end;

  TDBXExceptionHandler = class(TORMExceptionHandler)
  protected
    function GetAdapterException(const exc: Exception;
      const defaultMsg: string): Exception; override;
    function GetDriverException(const exc: TDBXError;
      const defaultMsg: string): Exception; virtual;
  end;

implementation

uses
  DB,
  SysConst,
  Spring.Persistence.Core.ConnectionFactory,
  Spring.Persistence.Core.Consts;


{$REGION 'TDBXResultSetAdapter'}

constructor TDBXResultSetAdapter.Create(const dataSet: TSQLQuery;
  const exceptionHandler: IORMExceptionHandler);
begin
  inherited Create(DataSet, exceptionHandler);
  DataSet.DisableControls;
 // DataSet.CursorLocation := clUseServer;
 // DataSet.CursorType := ctOpenForwardOnly;
  fFieldCache := TFieldCache.Create(dataSet);
end;

destructor TDBXResultSetAdapter.Destroy;
begin
  DataSet.Free;
  inherited Destroy;
end;

function TDBXResultSetAdapter.FieldExists(const fieldName: string): Boolean;
begin
  Result := fFieldCache.FieldExists(fieldName);
end;

function TDBXResultSetAdapter.GetFieldCount: Integer;
begin
  Result := DataSet.FieldCount;
end;

function TDBXResultSetAdapter.GetFieldName(index: Integer): string;
begin
  Result := DataSet.Fields[index].FieldName;
end;

function TDBXResultSetAdapter.GetFieldValue(index: Integer): Variant;
begin
  Result := DataSet.Fields[index].Value;
end;

function TDBXResultSetAdapter.GetFieldValue(const fieldname: string): Variant;
begin
  Result := fFieldCache.GetFieldValue(fieldname);
end;

function TDBXResultSetAdapter.IsEmpty: Boolean;
begin
  Result := DataSet.Eof;
end;

function TDBXResultSetAdapter.Next: Boolean;
begin
  DataSet.Next;
  Result := not DataSet.Eof;
end;

{$ENDREGION}


{$REGION 'TDBXStatementAdapter'}

destructor TDBXStatementAdapter.Destroy;
begin
  Statement.Free;
  inherited Destroy;
end;

function TDBXStatementAdapter.Execute: NativeUInt;
begin
  inherited;
  try
    Result := Statement.ExecSQL;
  except
    raise HandleException;
  end;
end;

function TDBXStatementAdapter.ExecuteQuery(serverSideCursor: Boolean): IDBResultSet;
var
  query: TSQLQuery;
begin
  inherited;
  query := TSQLQuery.Create(nil);
  query.SQLConnection := Statement.SQLConnection;
  query.SQL.Text := Statement.SQL.Text;
  query.Params.AssignValues(query.Params);
  query.DisableControls;
  try
    query.Open;
    Result := TDBXResultSetAdapter.Create(query, ExceptionHandler);
  except
    on E: Exception do
    begin
      Result := TDBXResultSetAdapter.Create(query, ExceptionHandler);
      raise HandleException(Format(EXCEPTION_CANNOT_OPEN_QUERY, [E.Message]));
    end;
  end;
end;

procedure TDBXStatementAdapter.SetParam(const param: TDBParam);
var
  paramName: string;
  parameter: TParam;
begin
  paramName := param.GetNormalizedParamName;
  parameter := Statement.ParamByName(paramName);
  parameter.Value := param.ToVariant;
  if parameter.IsNull then
    parameter.DataType := param.ParamType;
end;

procedure TDBXStatementAdapter.SetParams(const params: IEnumerable<TDBParam>);
begin
  inherited;
  params.ForEach(SetParam);
end;

procedure TDBXStatementAdapter.SetSQLCommand(const commandText: string);
begin
  inherited;
  Statement.SQL.Text := commandText;
end;

{$ENDREGION}


{$REGION 'TDBXConnectionAdapter'}

function TDBXConnectionAdapter.BeginTransaction: IDBTransaction;
begin
  if Assigned(Connection) then
  try
    Connection.Connected := True;
    Result := TDBXTransactionAdapter.Create(Connection.BeginTransaction,
      ExceptionHandler);
  except
    raise HandleException;
  end
  else
    Result := nil;
end;

procedure TDBXConnectionAdapter.Connect;
begin
  if Assigned(Connection) then
  try
    Connection.Connected := True;
  except
    raise HandleException;
  end;
end;

constructor TDBXConnectionAdapter.Create(const connection: TSQLConnection);
begin
  Create(connection, TDBXExceptionHandler.Create);
end;

constructor TDBXConnectionAdapter.Create(const connection: TSQLConnection;
  const exceptionHandler: IORMExceptionHandler);
begin
  inherited Create(connection, exceptionHandler);
  Connection.LoginPrompt := False;
end;

function TDBXConnectionAdapter.CreateStatement: IDBStatement;
var
  statement: TSQLQuery;
  adapter: TDBXStatementAdapter;
begin
  if Assigned(Connection) then
  begin
    statement := TSQLQuery.Create(nil);
    statement.SQLConnection := Connection;

    adapter := TDBXStatementAdapter.Create(statement, ExceptionHandler);
    adapter.ExecutionListeners := ExecutionListeners;
    Result := adapter;
  end
  else
    Result := nil;
end;

procedure TDBXConnectionAdapter.Disconnect;
begin
  if Assigned(Connection) then
  try
    Connection.Connected := False;
  except
    raise HandleException;
  end;
end;

function TDBXConnectionAdapter.IsConnected: Boolean;
begin
  if Assigned(Connection) then
    Result := Connection.Connected
  else
    Result := False;
end;

{$ENDREGION}


{$REGION 'TDBXTransactionAdapter'}

procedure TDBXTransactionAdapter.Commit;
begin
  if Assigned(Transaction) then
  try
    Transaction.Connection.CommitFreeAndNil(fTransaction);
  except
    raise HandleException;
  end;
end;

function TDBXTransactionAdapter.InTransaction: Boolean;
begin
  Result := Assigned(Transaction);
end;

procedure TDBXTransactionAdapter.Rollback;
begin
  if Assigned(Transaction) then
  try
    Transaction.Connection.RollbackFreeAndNil(fTransaction);
  except
    raise HandleException;
  end;
end;

{$ENDREGION}


{$REGION 'TDBXExceptionHandler'}

function TDBXExceptionHandler.GetAdapterException(const exc: Exception;
  const defaultMsg: string): Exception;
begin
  if exc is TDBXError then
  begin
    Result := GetDriverException(TDBXError(exc), defaultMsg);
    if not Assigned(Result) then
      Result := EDBXAdapterException.Create(defaultMsg,
        TDBXError(exc).ErrorCode);
  end
  else if exc is EDatabaseError then
    Result := EDBXAdapterException.Create(defaultMsg)
  else
    Result := nil;
end;

function TDBXExceptionHandler.GetDriverException(const exc: TDBXError;
  const defaultMsg: string): Exception;
begin
  Result := nil;
end;

{$ENDREGION}


initialization
  TConnectionFactory.RegisterConnection<TDBXConnectionAdapter>(dtDBX);

end.
