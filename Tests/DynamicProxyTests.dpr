program DynamicProxyTests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Windows,
  DUnitTestRunner,
  Freezable in 'Source\Freezable.pas',
  FreezableTests in 'Source\FreezableTests.pas',
  Pet in 'Source\Pet.pas',
  Spring.Interception in '..\Source\Core\Interception\Spring.Interception.pas',
  Spring.Patches.QC98671 in '..\Source\Base\Patches\Spring.Patches.QC98671.pas',
  CallLoggingInterceptor in 'Source\CallLoggingInterceptor.pas',
  HasCount in 'Source\HasCount.pas',
  Interfaces in 'Source\Interfaces.pas',
  DelegateWrapper in 'Source\DelegateWrapper.pas',
  MethodInterceptor in 'MethodInterceptor.pas',
  ProxyTests in 'Source\ProxyTests.pas',
  DelegateSelector in 'DelegateSelector.pas';

begin
  RunRegisteredTests;
  ReportMemoryLeaksOnShutdown := True;
end.
