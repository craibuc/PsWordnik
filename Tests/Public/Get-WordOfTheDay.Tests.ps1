BeforeAll {

    # /PsWordnik
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # /PsWordnik/PsWordnik/Public
    $PublicPath = Join-Path $ProjectDirectory "/PsWordnik/Public/"

    # /PsWordnik/Tests/Fixtures/
    # $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    . (Join-Path $PublicPath $SUT)

}

Describe "Get-WordOfTheDay" -Tag 'unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'Get-WordOfTheDay'
        } 

        $Parameters = @(
            @{ParameterName='ApiKey';Type=[string]; Mandatory=$true}
            @{ParameterName='Day';Type=[datetime]; Mandatory=$false}
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

    } # /Context

    Context "Usage" {
        Context "When mandatory parameters are supplied" {
            
            BeforeEach {
                # arrange
                Mock Invoke-WebRequest
                $Expected = @{
                    ApiKey='abc123'
                }
                # act
                Get-WordOfTheDay @Expected  -Debug
            }
            
            It "uses a GET request" {
                # assert
                Should -Invoke Invoke-WebRequest -ParameterFilter { 
                    $Method -eq 'Get'
                }
            }

            It "uses the expected URI" {
                # assert
                Should -Invoke Invoke-WebRequest -ParameterFilter { 
                    $Uri -like "*/wordOfTheDay?api_key=$( $Expected.ApiKey )*"
                }
            }

        }

        Context "When Day is supplied" {
            
            BeforeEach {
                # arrange
                Mock Invoke-WebRequest
                $Expected = @{
                    ApiKey='abc123'
                    Day=[datetime]'01/01/2022'
                }
                # act
                Get-WordOfTheDay @Expected -Debug
            }
            
            It "uses the expected URI" {
                # assert
                Should -Invoke Invoke-WebRequest -ParameterFilter { 
                    $Uri -like "*/wordOfTheDay?api_key=$( $Expected.ApiKey )&date=$( $Expected.Day.ToString('yyyy-MM-dd') )*"
                }
            }
        }

    }

} # /Describe
