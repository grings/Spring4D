{***************************************************************************}
{                                                                           }
{           Delphi Spring Framework                                         }
{                                                                           }
{           Copyright (C) 2009-2010 Delphi Spring Framework                 }
{                                                                           }
{           http://delphi-spring-framework.googlecode.com                   }
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

{$IFNDEF SPRING_INC}
{$DEFINE SPRING_INC}

{.$I jedi.inc}                // Import JEDI Development environment directives

{$IF RTLVersion < 21.0}
  {$MESSAGE ERROR 'Delphi Spring Framework should be compiled in Delphi 2010 or later.'}
{$IFEND}

{$IFDEF DELPHI2006_UP}
  {$DEFINE SUPPORTS_REGION}  // Enable REGION Directive in Delphi 2006 or later.
{$ENDIF}

{.$SCOPEDENUMS ON}           // Enable Scoped Enumerations

{$WARN UNIT_PLATFORM OFF}    // Turn off UNIT_PLATFORM warning
{$WARN SYMBOL_PLATFORM OFF}  // Turn off SYMBOL_PLATFORM warning

{$ENDIF ~SPRING_INC}