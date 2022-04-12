BeforeAll {

    # /PsWordnik
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # /PsWordnik/PsWordnik/Public
    $PublicPath = Join-Path $ProjectDirectory "/PsWordnik/Public/"

    # /PsWordnik/Tests/Fixtures/
    # $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # New-BambooHrEmployeeTableRow.ps1
    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    . (Join-Path $PublicPath $SUT)

}

Describe "Get-Word" -Tag 'unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'Get-Word'
        } 

        $Parameters = @(
            @{ParameterName='ApiKey';Type=[string]; Mandatory=$true}
            @{ParameterName='Word';Type=[string]; Mandatory=$true}
            @{ParameterName='Property';Type=[string]; Mandatory=$false}
        )

        Context "Type" {
            It '<ParameterName> mandatory is a <Type>' -TestCases $Parameters {
                param($ParameterName, $Type)
                $Command | Should -HaveParameter $ParameterName -Type $Type
            }    
        }

        Context "Mandatory" {
            it '<ParameterName> mandatory is <Mandatory>' -TestCases $Parameters {
                param($ParameterName, $Type, $Mandatory)
              
                if ($Mandatory) { $Command | Should -HaveParameter $ParameterName -Mandatory }
                else { $Command | Should -HaveParameter $ParameterName -Not -Mandatory }
            }    
        }

        Context 'Property parameter' {
            It 'has a ValidateSet' {
                $Expected = 'audio','definitions','etymologies','examples','frequency','hypenation','phrases','pronunciations','relatedWords','scrabbleScore','topExample'
                $Actual = $Command.Parameters['Property'].Attributes.ValidValues
                $Actual | Should -BeExactly $Expected
            }
        }

    } # /Context

    Context "Usage" {
        Context "When mandatory parameters are supplied" {
            
            BeforeEach {
                # arrange
                Mock Invoke-WebRequest
                $Expected = @{
                    ApiKey='abc123'
                    Word='Word'
                }
                # act
                Get-Word @Expected
            }
            
            It "uses a GET request" {
                # assert
                Should -Invoke Invoke-WebRequest -ParameterFilter { 
                    $Method -eq 'Get'
                }
            }

            It "includes the Word in the URI" {
                # assert
                Should -Invoke Invoke-WebRequest -ParameterFilter { 
                    $Uri -like "*/$( $Expected.Word )/*"
                }
            }

            It "includes the ApiKey in the URI" {
                # assert
                Should -Invoke Invoke-WebRequest -ParameterFilter { 
                    $Uri -like "*api_key=$( $Expected.ApiKey )*"
                }
            }

            It "includes the Definition in the URI" {
                # assert
                Should -Invoke Invoke-WebRequest -ParameterFilter { 
                    $Uri -like "*/definitions?*"
                }
            }

        }

        Context "When Property is supplied" {
            
            BeforeEach {
                # arrange
                Mock Invoke-WebRequest
                $Expected = @{
                    ApiKey='abc123'
                    Word='Word'
                    Property='etymologies'
                }
                # act
                Get-Word @Expected
            }
            
            It "includes the Property in the URI" {
                # assert
                Should -Invoke Invoke-WebRequest -ParameterFilter { 
                    $Uri -like "*/$( $Expected.Property )?*"
                }
            }
        }

    }

} # /Describe
