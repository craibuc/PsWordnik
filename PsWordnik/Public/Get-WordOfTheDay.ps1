<#
.LINK
https://developer.wordnik.com/docs#!/words/getWordOfTheDay
#>
function Get-WordOfTheDay {
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter()]
        [datetime]$Day = (Get-Date)
    )

    $Q = @{
        api_key=$ApiKey
        date=$Day.ToString('yyyy-MM-dd')
    }
    
    $Query = ($q.keys | ForEach-Object { "{0}={1}" -f $_, $q[$_] }) -join '&'

    $BaseUri = 'https://api.wordnik.com/v4/words.json'

    $Uri = "{0}/wordOfTheDay?{1}" -f $BaseUri, $Query
    Write-Debug "Uri: $Uri"

    try {
        $Response = Invoke-WebRequest -Uri $Uri -Method Get
        $Content = $Response | ConvertFrom-Json
        $Content            
    }
    catch {
        Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    }

}
