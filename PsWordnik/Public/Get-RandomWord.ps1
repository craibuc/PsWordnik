<#
.LINK
https://developer.wordnik.com/docs#!/words/getRandomWords
#>
function Get-RandomWord {
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter()]
        [int]$Limit = 10
    )

    $Q = @{
        api_key=$ApiKey
        limit=$Limit
        # hasDictionaryDef=true
        # maxCorpusCount=-1
        # minDictionaryCount=1
        # maxDictionaryCount=-1
        # minLength=5
        # maxLength=-1
    }
    
    $Query = ($q.keys | ForEach-Object { "{0}={1}" -f $_, $q[$_] }) -join '&'

    $BaseUri = 'https://api.wordnik.com/v4/words.json'

    $Uri = "{0}/randomWords?{1}" -f $BaseUri, $Query    
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
