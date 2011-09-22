{***************************************************************************}
{                                                                           }
{           Spring Framework for Delphi                                     }
{                                                                           }
{           Copyright (C) 2009-2011 DevJET                                  }
{                                                                           }
{           http://www.spring4d.org                                           }
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

 unit Spring.Configuration.Node experimental;

{$I Spring.inc}

interface

uses
  Classes,
  SysUtils,
  Rtti,
  Spring,
  Spring.Collections,
  Spring.Configuration;

type
  TConfigurationBase = class abstract(TInterfacedObject, IConfiguration)
  strict private
    fChildren: IList<IConfiguration>;
    fAttributes: IDictionary<string, TValue>;
    function GetChildren: IList<IConfiguration>;
    function GetAttributes: IDictionary<string, TValue>;
  protected
    function GetName: string; virtual; abstract;
    procedure DoSetChildren(const value: IList<IConfiguration>); virtual; abstract;
    procedure DoSetAttributes(const value: IDictionary<string, TValue>); virtual; abstract;
  public
    function TryGetAttribute(const name: string; out value: TValue): Boolean;
    function GetConfiguratioinSection(const nodeName: string): IConfiguration;
    property Name: string read GetName;
    property Attributes: IDictionary<string, TValue> read GetAttributes;
    property Children: IList<IConfiguration> read GetChildren;
  end;

  EConfigurationException = class(Exception);

implementation

uses
  Generics.Collections;

{$REGION 'TConfigurationBase'}

function TConfigurationBase.TryGetAttribute(const name: string;
  out value: TValue): Boolean;
begin
  Result := Attributes.TryGetValue(name, value);
end;

function TConfigurationBase.GetConfiguratioinSection(
  const nodeName: string): IConfiguration;
begin
  Result := Children.FirstOrDefault(
    function(const node: IConfiguration): Boolean
    begin
      Result := SameText(node.Name, nodeName);
    end
  );
end;

function TConfigurationBase.GetAttributes: IDictionary<string, TValue>;
begin
  if fAttributes = nil then
  begin
    fAttributes := TCollections.CreateDictionary<string, TValue>;
    DoSetAttributes(fAttributes);
  end;
  Result := fAttributes;
end;

function TConfigurationBase.GetChildren: IList<IConfiguration>;
begin
  if fChildren = nil then
  begin
    fChildren := TCollections.CreateList<IConfiguration>;
    DoSetChildren(fChildren);
  end;
  Result := fChildren;
end;

{$ENDREGION}

end.

