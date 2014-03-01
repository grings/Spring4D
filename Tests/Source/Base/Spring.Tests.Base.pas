{***************************************************************************}
{                                                                           }
{           Spring Framework for Delphi                                     }
{                                                                           }
{           Copyright (c) 2009-2014 Spring4D Team                           }
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

unit Spring.Tests.Base;

{$I Spring.inc}

{$IFDEF MACOS}
  {$DEFINE LogConsole}
{$ENDIF MACOS}

interface

uses
  TypInfo,
  TestFramework,
  Spring.TestUtils,
  Spring,
  Spring.Events,
  Spring.Utils;

type
  TTestNullableInteger = class(TTestCase)
  private
    fInteger: Nullable<Integer>;
  published
    procedure TestInitialValue;
    procedure GetValueOrDefault;
    procedure TestAssignFive;
    procedure TestAssignNil;
    procedure TestException;
    procedure TestLocalVariable;
    procedure TestFromVariant;
    procedure TestEquals;
    procedure TestDefaultReturnsInitialValue;
  end;

  TTestNullableBoolean = class(TTestCase)
  private
    fBoolean: Nullable<Boolean>;
  published
    procedure TestIssue55;
  end;

  TTestGuard = class(TTestCase)
  published
    procedure TestIsNullReference;
    procedure TestCheckRange;
    procedure TestNotNull;
  end;

  TTestLazy = class(TTestCase)
  private
    fBalance: ILazy<Integer>;
  protected
    const
      CExpectedBalance = 100;
  published
    procedure TestByValueFactory;
    procedure TestByValue;
  end;

{$IFNDEF CPUARM}
  {$M+}
  TProc<T1, T2> = reference to procedure(arg1: T1; arg2: T2);
  {$M-}

  TTestMulticastEvent = class(TTestCase)
  strict private
    type
      TEventInt64 = procedure(const Value: Int64) of object;
      TEventSingle = procedure(const Value: Single) of object;
      TEventDouble = procedure(const Value: Double) of object;
      TEventExtended = procedure(const Value: Extended) of object;
    const
      CNumber = 5;
      CText = 'test';
  strict private
    fEvent: IMulticastNotifyEvent;
    fASender: TObject;
    fAInvoked: Boolean;
    fBSender: TObject;
    fBInvoked: Boolean;
    fHandlerInvokeCount: Integer;
    fProc: TProc<Integer, string>;
  strict protected
    procedure SetUp; override;
    procedure TearDown; override;
    procedure HandlerA(sender: TObject);
    procedure HandlerB(sender: TObject);

    procedure HandlerInt64(const value: Int64);
    procedure HandlerSingle(const value: Single);
    procedure HandlerDouble(const value: Double);
    procedure HandlerExtended(const value: Extended);
  published
    procedure TestEmpty;
    procedure TestInvoke;
    procedure TestOneHandler;
    procedure TestTwoHandlers;
    procedure TestRecordType;
    procedure TestIssue58;
    procedure TestDelegate;
    procedure TestIssue60();
  end;

type
  TTestMulticastEventStackSize = class(TTestCase)
  strict private
    type
      {TODO -o##jwp -cEnhance : Add more data types: all the int and float types, records, classes, interfaces, variants }
      TEventDouble = procedure(const Value: Double) of object;
      TEventExtended = procedure(const Value: Extended) of object;
      TEventGuid = procedure(const Value: TGUID) of object;
      TEventInt64 = procedure(const Value: Int64) of object;
      TEventSingle = procedure(const Value: Single) of object;
    const
      Integer42: Integer = 42;
      Float42 = 42.0;
      Double42: Double = 42.0;
      Extended42: Extended = 42.0;
      Int6442: Int64 = 42;
      Single42: Single = 42;
      GUID42: TGUID = '{CCD21A05-9527-411F-AB44-AAF44C0E0DAF}';
  strict private
    fHandlerInvokeCount: Integer;
  strict protected
    procedure SetUp; override;
    procedure TearDown; override;
    procedure HandlerDouble(const value: Double);
    procedure HandlerExtended(const value: Extended);
    procedure HandlerGuid(const value: TGUID);
    procedure HandlerInt64(const value: Int64);
    procedure HandlerSingle(const value: Single);
    procedure LogEnter(const expected: Integer; const MethodName: string); virtual;
    procedure LogLeave(const expected: Integer); virtual;
  published
    procedure TestIssue60Double();
    procedure TestIssue60DoubleAssignedConst();
    procedure TestIssue60Extended();
    procedure TestIssue60ExtendedAssignedConst();
    procedure TestIssue60GuidAssignedConst();
    procedure TestIssue60Int64();
    procedure TestIssue60Int64AssignedConst();
    procedure TestIssue60Single();
    procedure TestIssue60SingleAssignedConst();
  end;

{$ENDIF ~CPUARM}

type
  TTestSpringEventsMethods = class(TTestCase)
  strict private
    fEmptyValue: TValue;
    fRemainingTypeKinds: TTypeKinds;
    fTestedTypeKinds: TTypeKinds;
    const
      cNativePoiterSize = SizeOf(Pointer);
  strict protected
    procedure FailUnsupportedTypeForTypeInfo(const aTypeName: string); virtual;
    function MatchType(const aTypeInfo: PTypeInfo; const aExpectedTypeKind: TTypeKind; const aExpectedTypeSize: Integer):
        Integer; virtual;
    procedure SetUp; override;
    procedure TearDown; override;
    property RemainingTypeKinds: TTypeKinds read fRemainingTypeKinds;
    property TestedTypeKinds: TTypeKinds read fTestedTypeKinds;
  published
    /// <summary>
    ///   Make sure this method is named so it will be run last
    /// </summary>
    procedure Test_EnsureAllTTypeKindsCoveredByCallsTo_Test_GetTypeSize_();
    procedure Test_GetTypeSize_AnsiChar();
    procedure Test_GetTypeSize_AnsiString();
    procedure Test_GetTypeSize_Array();
    procedure Test_GetTypeSize_Boolean();
    procedure Test_GetTypeSize_Byte();
    procedure Test_GetTypeSize_ByteBool();
    procedure Test_GetTypeSize_Cardinal();
    procedure Test_GetTypeSize_Char();
    procedure Test_GetTypeSize_Class();
    procedure Test_GetTypeSize_ClassRef();
    procedure Test_GetTypeSize_Comp();
    procedure Test_GetTypeSize_Currency();
{
Test_EnsureAllTTypeKindsCoveredByCallsTo_Test_GetTypeSize_: ETestFailure
at  $00000000005D7EAF
fRemainingTypeKinds is not empty: tkUnknown,tkMethod,tkArray,tkInterface,tkDynArray,tkClassRef,tkProcedure, expected: <True> but was: <False>
{ System.pas: Delphi built-in types for .hpp/.obj support }
(*
{$NODEFINE    Extended80  } { not supported in C++ }
*)

    procedure Test_GetTypeSize_Double();
    procedure Test_GetTypeSize_DynamicArray();
    procedure Test_GetTypeSize_Extended();
    procedure Test_GetTypeSize_File();
    procedure Test_GetTypeSize_Guid();
    procedure Test_GetTypeSize_Interface();
    procedure Test_GetTypeSize_Int64();
    procedure Test_GetTypeSize_Integer();
    procedure Test_GetTypeSize_LongBool();
    procedure Test_GetTypeSize_LongInt();
    procedure Test_GetTypeSize_LongWord();
    procedure Test_GetTypeSize_Method();
    procedure Test_GetTypeSize_NativeInt();
    procedure Test_GetTypeSize_NativeUInt();
    procedure Test_GetTypeSize_OleVariant();
    procedure Test_GetTypeSize_OpenString();
    procedure Test_GetTypeSize_PAnsiChar();
    procedure Test_GetTypeSize_PChar();
    procedure Test_GetTypeSize_Pointer();
    procedure Test_GetTypeSize_Proc();
    procedure Test_GetTypeSize_Procedure();
    procedure Test_GetTypeSize_PWideChar();
    procedure Test_GetTypeSize_Real();
    procedure Test_GetTypeSize_Set();
//{$IFOPT REALCOMPATIBILITY}
//    procedure Test_GetTypeSize_Real48();
//{$ENDIF REALCOMPATIBILITY}
    procedure Test_GetTypeSize_ShortInt();
    procedure Test_GetTypeSize_ShortString();
    procedure Test_GetTypeSize_ShortString0();
    procedure Test_GetTypeSize_ShortString1();
    procedure Test_GetTypeSize_ShortString2();
    procedure Test_GetTypeSize_ShortString255();
    procedure Test_GetTypeSize_ShortString7();
    procedure Test_GetTypeSize_Single();
    procedure Test_GetTypeSize_SmallInt();
    procedure Test_GetTypeSize_string();
    procedure Test_GetTypeSize_Text();
    procedure Test_GetTypeSize_TextFile();
    procedure Test_GetTypeSize_UnicodeString();
    procedure Test_GetTypeSize_UnknownTValue();
    procedure Test_GetTypeSize_Variant();
    procedure Test_GetTypeSize_WideChar();
    procedure Test_GetTypeSize_WideString();
    procedure Test_GetTypeSize_Word();
    procedure Test_GetTypeSize_WordBool();
  end;

implementation

uses
  Classes,
  SysUtils,
  Variants,
  Rtti,
  StrUtils,
  Types;

{$REGION 'TTestNullableInteger'}

procedure TTestNullableInteger.TestInitialValue;
begin
  CheckFalse(fInteger.HasValue);
end;

procedure TTestNullableInteger.GetValueOrDefault;
begin
  CheckFalse(fInteger.HasValue);
  CheckEquals(Default(Integer), fInteger.GetValueOrDefault);
  CheckEquals(18, fInteger.GetValueOrDefault(18));
end;

procedure TTestNullableInteger.TestAssignFive;
begin
  fInteger := 5;
  Check(fInteger.HasValue);
  CheckEquals(5, fInteger.Value);
  Check(fInteger.Value = 5);
  Check(fInteger.Value <> 3);
end;

procedure TTestNullableInteger.TestAssignNil;
begin
  fInteger := 5;
  CheckTrue(fInteger.HasValue);
  fInteger := nil;
  CheckFalse(fInteger.HasValue);
end;

procedure TTestNullableInteger.TestDefaultReturnsInitialValue;
begin
  fInteger := Default(Nullable<Integer>);
  CheckFalse(fInteger.HasValue);
end;

procedure TTestNullableInteger.TestException;
begin
  ExpectedException := EInvalidOperationException;
  fInteger.Value;
end;

procedure TTestNullableInteger.TestLocalVariable;
var
  dirtyValue: Nullable<Integer>;  { lives in stack }
begin
  CheckFalse(dirtyValue.HasValue);
  dirtyValue := 5;
end;

procedure TTestNullableInteger.TestFromVariant;
var
  value: Variant;
const
  ExpectedInteger: Integer = 5;
begin
  value := Null;
  fInteger := Nullable<Integer>.Create(value);
  CheckFalse(fInteger.HasValue);

  fInteger := value;
  CheckFalse(fInteger.HasValue);

  value := ExpectedInteger;
  fInteger := Nullable<Integer>.Create(value);
  CheckTrue(fInteger.HasValue);
  CheckEquals(ExpectedInteger, fInteger.Value);
end;

procedure TTestNullableInteger.TestEquals;
var
  a, b: Nullable<Integer>;
begin
  CheckFalse(a.HasValue);
  CheckFalse(b.HasValue);

  CheckTrue(a.Equals(b));
  CheckTrue(b.Equals(a));

  a := 2;
  CheckFalse(a.Equals(b));
  CheckFalse(b.Equals(a));

  b := 2;
  CheckTrue(a.Equals(b));

  b := 3;
  CheckFalse(a.Equals(b));
end;

{$ENDREGION}


{$REGION 'TTestNullableBoolean'}

procedure TTestNullableBoolean.TestIssue55;
var
  v: Variant;
begin
  fBoolean := True;
  v := fBoolean;
  CheckTrue(v);
end;

{$ENDREGION}


{$REGION 'TTestMulticastEvent'}
{$IFNDEF CPUARM}

procedure TTestMulticastEvent.SetUp;
begin
  inherited;
  fEvent := TMulticastNotifyEvent.Create();
  fProc :=
    procedure(i: Integer; s: string)
    begin
      Inc(fHandlerInvokeCount, i);
      CheckEquals(CText, s);
    end;
end;

procedure TTestMulticastEvent.TearDown;
begin
  inherited;
  fEvent := nil;
  fASender := nil;
  fAInvoked := False;
  fBSender := nil;
  fBInvoked := False;
  fHandlerInvokeCount := 0;
end;

procedure TTestMulticastEvent.HandlerA(sender: TObject);
begin
  fASender := sender;
  fAInvoked := True;
end;

procedure TTestMulticastEvent.HandlerB(sender: TObject);
begin
  fBSender := sender;
  fBInvoked := True;
end;

procedure TTestMulticastEvent.HandlerDouble(const value: Double);
begin
  CheckEquals(42, value);
  Inc(fHandlerInvokeCount);
end;

procedure TTestMulticastEvent.HandlerExtended(const value: Extended);
begin
  CheckEquals(42, value);
  Inc(fHandlerInvokeCount);
end;

procedure TTestMulticastEvent.HandlerInt64(const value: Int64);
begin
  CheckEquals(42, value);
  Inc(fHandlerInvokeCount);
end;

procedure TTestMulticastEvent.HandlerSingle(const value: Single);
begin
  CheckEquals(42, value);
  Inc(fHandlerInvokeCount);
end;

procedure TTestMulticastEvent.TestDelegate;
var
  e: Event<TProc<Integer, string>>;
begin
  e.Add(fProc);
  CheckEquals(1, e.Count);
  e.Invoke(CNumber, CText);
  CheckEquals(CNumber, fHandlerInvokeCount);
  e.Remove(fProc);
  CheckEquals(0, e.Count);
  e.Invoke(CNumber, CText);
  CheckEquals(CNumber, fHandlerInvokeCount);
end;

procedure TTestMulticastEvent.TestEmpty;
begin
  CheckEquals(0, fEvent.Count);
  CheckTrue(fEvent.IsEmpty);
end;

procedure TTestMulticastEvent.TestInvoke;
begin
  fEvent.Invoke(Self);
  CheckFalse(fAInvoked);
  CheckFalse(fBInvoked);
end;

procedure TTestMulticastEvent.TestIssue58;
var
  e: Event<TNotifyEvent>;
  i: IEvent<TNotifyEvent>;
  t: TNotifyEvent;
begin
  i := e;
  t := e.Invoke;
  Check(Assigned(i));
end;

procedure TTestMulticastEvent.TestIssue60();
var
  eventInt64: Event<TEventInt64>;
  eventSingle: Event<TEventSingle>;
  eventDouble: Event<TEventDouble>;
  eventExtended: Event<TEventExtended>;
  expected: Integer;
begin
  expected := 0;

  eventInt64 := Event<TEventInt64>.Create();
  eventSingle := Event<TEventSingle>.Create();
  eventDouble := Event<TEventDouble>.Create();
  eventExtended := Event<TEventExtended>.Create();

  eventInt64.Add(HandlerInt64);
  eventSingle.Add(HandlerSingle);
  eventDouble.Add(HandlerDouble);
  eventExtended.Add(HandlerExtended);

  eventInt64.Invoke(42); Inc(expected);
  eventSingle.Invoke(42); Inc(expected);
  eventDouble.Invoke(42); Inc(expected);
  eventExtended.Invoke(42); Inc(expected);

  CheckEquals(expected, fHandlerInvokeCount);
end;

procedure TTestMulticastEvent.TestOneHandler;
begin
  fEvent.Add(HandlerA);
  CheckEquals(1, fEvent.Count);
  CheckFalse(fEvent.IsEmpty);

  fEvent.Invoke(Self);
  CheckTrue(fAInvoked);
  CheckSame(Self, fASender);
  CheckFalse(fBInvoked);
  CheckSame(nil, fBSender);

  fEvent.Remove(HandlerA);
  CheckEquals(0, fEvent.Count);
end;

procedure TTestMulticastEvent.TestRecordType;
var
  e: Event<TNotifyEvent>;
begin
  CheckTrue(e.Enabled);
  CheckTrue(e.IsEmpty);

  e.Add(HandlerA);
  e.Add(HandlerB);
  e.Invoke(nil);

  CheckFalse(e.IsEmpty);
  CheckEquals(2, e.Count);

  CheckTrue(fAInvoked);
  CheckSame(nil, fASender);
  CheckTrue(fBInvoked);
  CheckSame(nil, fBSender);

  e.Remove(HandlerA);
  CheckEquals(1, e.Count);

  e.Remove(HandlerB);
  CheckEquals(0, e.Count);
end;

procedure TTestMulticastEvent.TestTwoHandlers;
begin
  fEvent.Add(HandlerA);
  fEvent.Add(HandlerB);
  fEvent.Invoke(nil);

  CheckTrue(fAInvoked);
  CheckSame(nil, fASender);
  CheckTrue(fBInvoked);
  CheckSame(nil, fBSender);

  fEvent.Remove(HandlerA);
  CheckEquals(1, fEvent.Count);

  fEvent.Remove(HandlerB);
  CheckEquals(0, fEvent.Count);
end;

{$ENDIF ~CPUARM}
{$ENDREGION}


{$REGION 'TTestLazy'}

procedure TTestLazy.TestByValueFactory;
var
  factory: TFunc<Integer>;
begin
  factory :=
    function: Integer
    begin
      Result := CExpectedBalance;
    end;
  fBalance := TLazy<Integer>.Create(factory);

  CheckFalse(fBalance.IsValueCreated);

  CheckEquals(CExpectedBalance, fBalance.Value);
  CheckEquals(CExpectedBalance, (fBalance as ILazy).Value.AsInteger);

  CheckTrue(fBalance.IsValueCreated);
end;

procedure TTestLazy.TestByValue;
begin
  fBalance := TLazy<Integer>.CreateFrom(CExpectedBalance);

  CheckTrue(fBalance.IsValueCreated);

  CheckEquals(CExpectedBalance, fBalance.Value);
  CheckEquals(CExpectedBalance, (fBalance as ILazy).Value.AsInteger);

  CheckTrue(fBalance.IsValueCreated);
end;

{$ENDREGION}


{$REGION 'TTestGuard'}

procedure TTestGuard.TestCheckRange;
var
  dynArray: array of Byte;
const
  len = 4;
  idx = 1;
begin
  // check string (1-based)
  CheckException(EArgumentOutOfRangeException,
    procedure
    begin
      Guard.CheckRange('abcde', 0);
    end);
  Guard.CheckRange('abcde', 1);
  Guard.CheckRange('abcde', 5);
  CheckException(EArgumentOutOfRangeException,
    procedure
    begin
      Guard.CheckRange('abcde', 6);
    end);

  // check 0-based byte array
  SetLength(dynArray, 4);
  CheckException(EArgumentOutOfRangeException,
    procedure
    begin
      Guard.CheckRange(dynArray, -1);
    end);
  Guard.CheckRange(dynArray, 0);
  Guard.CheckRange(dynArray, 3);
  CheckException(EArgumentOutOfRangeException,
    procedure
    begin
      Guard.CheckRange(dynArray, 4);
    end);

  // check 1-based range
  CheckException(EArgumentOutOfRangeException,
    procedure
    begin
      Guard.CheckRange(len, 0, 0, idx);
    end);
  CheckException(EArgumentOutOfRangeException,
    procedure
    begin
      Guard.CheckRange(len, 0, 1, idx);
    end);
  CheckException(EArgumentOutOfRangeException,
    procedure
    begin
      Guard.CheckRange(len, 0, 5, idx);
    end);
  CheckException(EArgumentOutOfRangeException,
    procedure
    begin
      Guard.CheckRange(len, 1, -1, idx);
    end);
  Guard.CheckRange(len, 1, 0, idx);
  Guard.CheckRange(len, 1, 1, idx);
  CheckException(EArgumentOutOfRangeException,
    procedure
    begin
      Guard.CheckRange(len, 1, 5, idx);
    end);
  CheckException(EArgumentOutOfRangeException,
    procedure
    begin
      Guard.CheckRange(len, 5, 0, idx);
    end);
  CheckException(EArgumentOutOfRangeException,
    procedure
    begin
      Guard.CheckRange(len, 5, 1, idx);
    end);
  CheckException(EArgumentOutOfRangeException,
    procedure
    begin
      Guard.CheckRange(len, 5, 5, idx);
    end);
end;

procedure TTestGuard.TestIsNullReference;
var
  obj: TObject;
  intf: IInterface;
{$IFNDEF NEXTGEN}
  e: TNotifyEvent;
{$ENDIF}
begin
  obj := nil;
  CheckTrue(Guard.IsNullReference(obj, TypeInfo(TObject)));
  CheckTrue(Guard.IsNullReference(intf, TypeInfo(IInterface)));
{$IFNDEF NEXTGEN}
  e := nil;
  CheckTrue(Guard.IsNullReference(e, TypeInfo(TNotifyEvent)));
  TMethod(e).Data := Self;
  CheckFalse(Assigned(e));
  CheckFalse(Guard.IsNullReference(e, TypeInfo(TNotifyEvent)));
{$ELSE}
  {$MESSAGE WARN 'Delphi problem'}
{$ENDIF}
end;

procedure TTestGuard.TestNotNull;
var
  intf: IInterface;
begin
  StartExpectingException(EArgumentNullException);
  Guard.CheckNotNull(intf, 'intf');
  StopExpectingException();
end;

{$ENDREGION}


{$REGION 'TTestMulticastEventStackSize'}
{$IFNDEF CPUARM}

procedure TTestMulticastEventStackSize.SetUp;
begin
  inherited;
end;

procedure TTestMulticastEventStackSize.TearDown;
begin
  inherited;
  fHandlerInvokeCount := 0;
end;

procedure TTestMulticastEventStackSize.HandlerDouble(const value: Double);
begin
  CheckEquals(Double42, value);
  Inc(fHandlerInvokeCount);
end;

procedure TTestMulticastEventStackSize.HandlerExtended(const value: Extended);
begin
  CheckEquals(Extended42, value);
  Inc(fHandlerInvokeCount);
end;

procedure TTestMulticastEventStackSize.HandlerGuid(const value: TGUID);
begin
  CheckEquals(GUIDToString(GUID42), GUIDToString(value));
  Inc(fHandlerInvokeCount);
end;

procedure TTestMulticastEventStackSize.HandlerInt64(const value: Int64);
begin
  CheckEquals(Int6442, value);
  Inc(fHandlerInvokeCount);
end;

procedure TTestMulticastEventStackSize.HandlerSingle(const value: Single);
begin
  CheckEquals(Single42, value);
  Inc(fHandlerInvokeCount);
end;

procedure TTestMulticastEventStackSize.LogEnter(const expected: Integer; const MethodName: string);
begin
  Writeln(Format('%s.%s', [ClassName, MethodName]));
  Writeln(Format('Entry: Expected=%d, got fHandlerInvokeCount=%d', [expected, fHandlerInvokeCount]));
end;

procedure TTestMulticastEventStackSize.LogLeave(const expected: Integer);
begin
  Writeln(Format('Exit: Expected=%d, got fHandlerInvokeCount=%d', [expected, fHandlerInvokeCount]));
end;

procedure TTestMulticastEventStackSize.TestIssue60Double();
var
  eventDouble: Event<TEventDouble>;
  expected: Integer;
begin
  expected := 0;
{$IFDEF LogConsole}
  LogEnter(expected, 'TestIssue60Double');
{$ENDIF LogConsole}
  eventDouble := Event<TEventDouble>.Create();
  eventDouble.Add(HandlerDouble);
  eventDouble.Invoke(42); Inc(expected);
{$IFDEF LogConsole}
  LogLeave(expected);
{$ENDIF LogConsole}
  CheckEquals(expected, fHandlerInvokeCount);
end;

procedure TTestMulticastEventStackSize.TestIssue60DoubleAssignedConst();
var
  eventDouble: Event<TEventDouble>;
  expected: Integer;
begin
  expected := 0;
{$IFDEF LogConsole}
  LogEnter(expected, 'TestIssue60DoubleAssignedConst');
{$ENDIF LogConsole}
  eventDouble := Event<TEventDouble>.Create();
  eventDouble.Add(HandlerDouble);
  eventDouble.Invoke(Double42); Inc(expected);
{$IFDEF LogConsole}
  LogLeave(expected);
{$ENDIF LogConsole}
  CheckEquals(expected, fHandlerInvokeCount);
end;

procedure TTestMulticastEventStackSize.TestIssue60Extended();
var
  eventExtended: Event<TEventExtended>;
  expected: Integer;
begin
  expected := 0;
{$IFDEF LogConsole}
  LogEnter(expected, 'TestIssue60Extended');
{$ENDIF LogConsole}
  eventExtended := Event<TEventExtended>.Create();
  eventExtended.Add(HandlerExtended);
  eventExtended.Invoke(42); Inc(expected);
{$IFDEF LogConsole}
  LogLeave(expected);
{$ENDIF LogConsole}
  CheckEquals(expected, fHandlerInvokeCount);
end;

procedure TTestMulticastEventStackSize.TestIssue60ExtendedAssignedConst();
var
  eventExtended: Event<TEventExtended>;
  expected: Integer;
begin
  expected := 0;
{$IFDEF LogConsole}
  LogEnter(expected, 'TestIssue60ExtendedAssignedConst');
{$ENDIF LogConsole}
  eventExtended := Event<TEventExtended>.Create();
  eventExtended.Add(HandlerExtended);
  eventExtended.Invoke(Extended42); Inc(expected);
{$IFDEF LogConsole}
  LogLeave(expected);
{$ENDIF LogConsole}
  CheckEquals(expected, fHandlerInvokeCount);
end;

procedure TTestMulticastEventStackSize.TestIssue60GuidAssignedConst();
var
  eventExtended: Event<TEventGuid>;
  expected: Integer;
begin
  expected := 0;
{$IFDEF LogConsole}
  Writeln('TTestMulticastEventStackSize.TestIssue60GuidAssignedConst');
  Writeln(Format('Entry: Expected=%d, got fHandlerInvokeCount=%d', [expected, fHandlerInvokeCount]));
{$ENDIF LogConsole}
  eventExtended := Event<TEventGuid>.Create();
  eventExtended.Add(HandlerGuid);
  eventExtended.Invoke(GUID42); Inc(expected);
{$IFDEF LogConsole}
  LogLeave(expected);
{$ENDIF LogConsole}
  CheckEquals(expected, fHandlerInvokeCount);
end;

procedure TTestMulticastEventStackSize.TestIssue60Int64();
var
  eventInt64: Event<TEventInt64>;
  expected: Integer;
begin
  expected := 0;
{$IFDEF LogConsole}
  Writeln('TTestMulticastEventStackSize.TestIssue60Int64');
  Writeln(Format('Entry: Expected=%d, got fHandlerInvokeCount=%d', [expected, fHandlerInvokeCount]));
{$ENDIF LogConsole}
  eventInt64 := Event<TEventInt64>.Create();
  eventInt64.Add(HandlerInt64);
  eventInt64.Invoke(42); Inc(expected);
{$IFDEF LogConsole}
  LogLeave(expected);
{$ENDIF LogConsole}
  CheckEquals(expected, fHandlerInvokeCount);
end;

procedure TTestMulticastEventStackSize.TestIssue60Int64AssignedConst();
var
  eventInt64: Event<TEventInt64>;
  expected: Integer;
begin
  expected := 0;
{$IFDEF LogConsole}
  Writeln('TTestMulticastEventStackSize.TestIssue60Int64AssignedConst');
  Writeln(Format('Entry: Expected=%d, got fHandlerInvokeCount=%d', [expected, fHandlerInvokeCount]));
{$ENDIF LogConsole}
  eventInt64 := Event<TEventInt64>.Create();
  eventInt64.Add(HandlerInt64);
  eventInt64.Invoke(Int6442); Inc(expected);
{$IFDEF LogConsole}
  LogLeave(expected);
{$ENDIF LogConsole}
  CheckEquals(expected, fHandlerInvokeCount);
end;

procedure TTestMulticastEventStackSize.TestIssue60Single();
var
  eventSingle: Event<TEventSingle>;
  expected: Integer;
begin
  expected := 0;
{$IFDEF LogConsole}
  Writeln('TTestMulticastEventStackSize.TestIssue60Single');
  Writeln(Format('Entry: Expected=%d, got fHandlerInvokeCount=%d', [expected, fHandlerInvokeCount]));
{$ENDIF LogConsole}
  eventSingle := Event<TEventSingle>.Create();
  eventSingle.Add(HandlerSingle);
  eventSingle.Invoke(42); Inc(expected);
{$IFDEF LogConsole}
  LogLeave(expected);
{$ENDIF LogConsole}
  CheckEquals(expected, fHandlerInvokeCount);
end;

procedure TTestMulticastEventStackSize.TestIssue60SingleAssignedConst();
var
  eventSingle: Event<TEventSingle>;
  expected: Integer;
begin
  expected := 0;
{$IFDEF LogConsole}
  Writeln('TTestMulticastEventStackSize.TestIssue60SingleAssignedConst');
  Writeln(Format('Entry: Expected=%d, got fHandlerInvokeCount=%d', [expected, fHandlerInvokeCount]));
{$ENDIF LogConsole}
  eventSingle := Event<TEventSingle>.Create();
  eventSingle.Add(HandlerSingle);
  eventSingle.Invoke(Single42); Inc(expected);
{$IFDEF LogConsole}
  LogLeave(expected);
{$ENDIF LogConsole}
  CheckEquals(expected, fHandlerInvokeCount);
end;

{$ENDIF CPUARM}
{$ENDREGION}


{$REGION 'TTestSpringEventsMethods'}

type
  TShortString0 = String[0];
  TShortString1 = String[1];
  TShortString2 = String[2];
  TShortString255 = String[255];
  TShortString7 = String[7];

procedure TTestSpringEventsMethods.FailUnsupportedTypeForTypeInfo(const aTypeName: string);
begin
{$IFDEF FailUnsupportedTypeForTypeInfo}
  Fail(Format('%s is unsupported for TypeInfo', [aTypeName]));
{$ENDIF FailUnsupportedTypeForTypeInfo}
end;

function TTestSpringEventsMethods.MatchType(const aTypeInfo: PTypeInfo; const aExpectedTypeKind: TTypeKind; const
    aExpectedTypeSize: Integer): Integer;
var
  lActualTypeSize: Integer;
  lExpectedTypeKindName: string;
  lTypeInfoKind: TTypeKind;
  lTypeInfoKindName: string;
begin
  lTypeInfoKind := aTypeInfo^.Kind;

  Exclude(fRemainingTypeKinds, lTypeInfoKind);
  Include(fTestedTypeKinds, lTypeInfoKind);

  lTypeInfoKindName := TEnum.GetName(lTypeInfoKind);
  lExpectedTypeKindName := TEnum.GetName(aExpectedTypeKind);
  CheckTrue(aExpectedTypeKind = lTypeInfoKind, Format('aExpectedTypeKind "%s" does not match actual lTypeInfoKind "%s"', [lExpectedTypeKindName, lTypeInfoKindName]));

  lActualTypeSize := GetTypeSize(aTypeInfo);
  CheckEquals(aExpectedTypeSize, lActualTypeSize, Format('aExpectedTypeSize %d does not lActualTypeSize %d', [aExpectedTypeSize, lActualTypeSize]));
end;

procedure TTestSpringEventsMethods.SetUp;
begin
  inherited;
  fRemainingTypeKinds := tkAny - [tkUnknown]; // for now, skip tkUnknown until the TODO is fixed.
  fTestedTypeKinds := [];
end;

procedure TTestSpringEventsMethods.TearDown;
begin
  inherited;
end;

procedure TTestSpringEventsMethods.Test_EnsureAllTTypeKindsCoveredByCallsTo_Test_GetTypeSize_();
var
  fRemainingTypeKindNames: TStrings;
  fTestedTypeKindNames: TStrings;
  lAllTypeKinds: TTypeKinds;
  lContext: TRttiContext;
  lMethod: TRttiMethod;
  lMethods: TArray<TRttiMethod>;
  lNoTypeKinds: TTypeKinds;
  lParameters: TArray<TRttiParameter>;
  lType: TRttiType;
  lTypeKind: TTypeKind;
  lTypeKindName: string;
begin
  lAllTypeKinds := fRemainingTypeKinds;
  lNoTypeKinds := fTestedTypeKinds;

  lContext := TRttiContext.Create();
  try
    lType := lContext.GetType(Self.ClassInfo);
    lMethods := lType.GetMethods();

    for lMethod in lMethods do
    begin
      if lMethod.Visibility = mvPublished then
        if lMethod.MethodKind = mkProcedure then
          if StartsText('Test_GetTypeSize_', lMethod.Name) then
          begin
            lParameters := lMethod.GetParameters();
            if Length(lParameters) = 0 then
            try
              lMethod.Invoke(Self, []);
            except
              on ETestFailure do
                ; // kill exception
              on EAssertionFailed do
                ; // kill exception
            end;
          end;
    end;
  finally
    lContext.Free();
  end;

  fRemainingTypeKindNames := TStringList.Create();
  try
    fTestedTypeKindNames := TStringList.Create();
    try
      for lTypeKind := Low(TTypeKind) to High(TTypeKind) do
      begin
        lTypeKindName := TEnum.GetName(lTypeKind);
        if lTypeKind in fRemainingTypeKinds then
          fRemainingTypeKindNames.Add(lTypeKindName);
        if lTypeKind in fTestedTypeKinds then
          fTestedTypeKindNames.Add(lTypeKindName);
      end;
      CheckTrue(fRemainingTypeKinds = lNoTypeKinds, 'fRemainingTypeKinds is not empty: ' + fRemainingTypeKindNames.CommaText);
      CheckTrue(fTestedTypeKinds = lAllTypeKinds, 'fRemainingTypeKinds should contain all TTypeKinds: ' + fTestedTypeKindNames.CommaText);
    finally
      fTestedTypeKindNames.Free;
    end;
  finally
    fRemainingTypeKindNames.Free;
  end;
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Double();
begin
  MatchType(TypeInfo(Double), tkFloat, 8);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Extended();
begin
{$IFDEF WIN32}
  MatchType(TypeInfo(Extended), tkFloat, 10);
{$ELSE}
  {$IFDEF MACOS}
    MatchType(TypeInfo(Extended), tkFloat, 16); // See TTestMulticastEventStackSize.TestIssue60ExtendedAssignedConst to align stack at 16-byte boundaries on OSX.
  {$ELSE}
    MatchType(TypeInfo(Extended), tkFloat, 8);
  {$ENDIF MACOS}
{$ENDIF WIN32}
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Guid();
begin
  MatchType(TypeInfo(TGuid), tkRecord, 16);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_ShortInt();
begin
  MatchType(TypeInfo(ShortInt), tkInteger, 1);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Int64();
begin
  MatchType(TypeInfo(Int64), tkInt64, 8);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Integer();
begin
  MatchType(TypeInfo(Integer), tkInteger, 4);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_SmallInt();
begin
  MatchType(TypeInfo(SmallInt), tkInteger, 2);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_AnsiChar();
begin
  MatchType(TypeInfo(AnsiChar), tkChar, 1);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_AnsiString();
begin
  MatchType(TypeInfo(AnsiString), tkLString, cNativePoiterSize);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Array();
begin
  MatchType(TypeInfo(TTextBuf), tkArray, 128);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Boolean();
begin
  MatchType(TypeInfo(Byte), tkInteger, 1);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Byte();
begin
  MatchType(TypeInfo(Byte), tkInteger, 1);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_ByteBool();
begin
  MatchType(TypeInfo(ByteBool), tkEnumeration, 1); // not tkInteger !!
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Word();
begin
  MatchType(TypeInfo(Word), tkInteger, 2);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Cardinal();
begin
  MatchType(TypeInfo(Cardinal), tkInteger, 4);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Char();
begin
  MatchType(TypeInfo(Char), tkWChar, 2);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Class();
begin
  MatchType(TypeInfo(TTestSpringEventsMethods), tkClass, cNativePoiterSize);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_ClassRef();
begin
  MatchType(TypeInfo(TClass), tkClassRef, cNativePoiterSize);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Currency();
begin
  MatchType(TypeInfo(Currency), tkFloat, 8);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Comp();
begin
  MatchType(TypeInfo(Comp), tkFloat, 8);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_DynamicArray();
begin
  MatchType(TypeInfo(TIntegerDynArray), tkDynArray, cNativePoiterSize);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_LongBool();
begin
  MatchType(TypeInfo(LongBool), tkEnumeration, 4); // not tkInteger !!
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_LongInt();
begin
  MatchType(TypeInfo(LongInt), tkInteger, 4);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_LongWord();
begin
  MatchType(TypeInfo(LongWord), tkInteger, 4);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_NativeInt();
begin
{$IFDEF WIN32}
  MatchType(TypeInfo(NativeInt), tkInteger, 4);
{$ELSE}
  {$IFDEF MACOS}
    MatchType(TypeInfo(NativeInt), tkInteger, 4);
  {$ELSE}
    MatchType(TypeInfo(NativeInt), tkInt64, 8);
  {$ENDIF WIN32}
{$ENDIF WIN32}
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_NativeUInt();
begin
{$IFDEF WIN32}
  MatchType(TypeInfo(NativeUInt), tkInteger, 4);
{$ELSE}
  {$IFDEF MACOS}
    MatchType(TypeInfo(NativeUInt), tkInteger, 4);
  {$ELSE}
    MatchType(TypeInfo(NativeUInt), tkInt64, 8);
  {$ENDIF WIN32}
{$ENDIF WIN32}
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_OleVariant();
begin
  MatchType(TypeInfo(OleVariant), tkVariant, 16);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Pointer();
begin
  MatchType(TypeInfo(Pointer), tkPointer, cNativePoiterSize);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Real();
begin
{$IFDEF WIN32}
  MatchType(TypeInfo(Real), tkFloat, 8);
{$ELSE}
  MatchType(TypeInfo(Real), tkFloat, 8);
{$ENDIF WIN32}
end;

//{$IFOPT REALCOMPATIBILITY}
//procedure TTestSpringEventsMethods.Test_GetTypeSize_Real48();
//begin
//  MatchType(TypeInfo(Real48), tkFloat, 6);
//end;
//{$ENDIF REALCOMPATIBILITY}

procedure TTestSpringEventsMethods.Test_GetTypeSize_Set();
begin
  MatchType(TypeInfo(TTypeKinds), tkSet, 4);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Single();
begin
  MatchType(TypeInfo(Single), tkFloat, 4);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_ShortString();
begin
  MatchType(TypeInfo(ShortString), tkString, 256);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_ShortString0();
begin
  MatchType(TypeInfo(TShortString0), tkString, 1);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_ShortString1();
begin
  MatchType(TypeInfo(TShortString1), tkString, 2);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_ShortString2();
begin
  MatchType(TypeInfo(TShortString2), tkString, 3);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_File();
begin
//  MatchType(TypeInfo(File), tkFloat, 0);
  FailUnsupportedTypeForTypeInfo('File');
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Interface();
begin
  MatchType(TypeInfo(IInterface), tkInterface, cNativePoiterSize);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Method();
begin
  MatchType(TypeInfo(TNotifyEvent), tkMethod, 2*cNativePoiterSize);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_OpenString();
begin
// http://www.codexterity.com/delphistrings.htm
//  MatchType(TypeInfo(OpenString), tkInteger, 4);
  FailUnsupportedTypeForTypeInfo('OpenString');
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_PAnsiChar();
begin
  MatchType(TypeInfo(PAnsiChar), tkPointer, cNativePoiterSize);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_PChar();
begin
  MatchType(TypeInfo(PChar), tkPointer, cNativePoiterSize);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Proc();
begin
  MatchType(TypeInfo(TProc), tkInterface, cNativePoiterSize);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Procedure();
begin
  MatchType(TypeInfo(TProcedure), tkProcedure, cNativePoiterSize);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_PWideChar();
begin
  MatchType(TypeInfo(PWideChar), tkPointer, cNativePoiterSize);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_ShortString255();
begin
  MatchType(TypeInfo(TShortString255), tkString, 256);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_ShortString7();
begin
  MatchType(TypeInfo(TShortString7), tkString, 8);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_string();
begin
  MatchType(TypeInfo(string), tkUString, cNativePoiterSize);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Text();
begin
//  MatchType(TypeInfo(Text), tkFloat, 0);
  FailUnsupportedTypeForTypeInfo('Text');
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_TextFile();
begin
//  MatchType(TypeInfo(TextFile), tkFloat, 0);
  FailUnsupportedTypeForTypeInfo('TextFile');
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_UnicodeString();
begin
  MatchType(TypeInfo(UnicodeString), tkUString, cNativePoiterSize);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_UnknownTValue();
//var
//  lTypeInfo: PTypeInfo;
begin
{TODO -o##jwp -cEnhance : Research to see if RTTI with tkUnknown can be generated at all }
//  lTypeInfo := fEmptyValue.TypeInfo;
//  MatchType(lTypeInfo, tkUnknown, cNativePoiterSize);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_Variant();
begin
  MatchType(TypeInfo(Variant), tkVariant, 16);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_WideChar();
begin
  MatchType(TypeInfo(WideChar), tkWChar, 2);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_WideString();
begin
  MatchType(TypeInfo(WideString), tkWString, cNativePoiterSize);
end;

procedure TTestSpringEventsMethods.Test_GetTypeSize_WordBool();
begin
  MatchType(TypeInfo(WordBool), tkEnumeration, 2); // not tkInteger !!
end;

{$ENDREGION}

end.
