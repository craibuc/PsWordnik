<#
.SYNOPSIS
Search the Wordnik API for a word.

.PARAMETER ApiKey
The API key.

.PARAMETER Word
The word to be searched.

.PARAMETER Property
The property to be searched.  Default = definitions

.EXAMPLE
Get-Word -ApiKey '669xx...' -Word 'orthogonal'

Get the word's definitions.

.EXAMPLE
Get-Word -ApiKey '669xx...' -Word 'orthogonal' -Property etymologies

Get the word's etymologies.

.LINK
https://developer.wordnik.com/docs#!/word/getAudio

.LINK
https://developer.wordnik.com/docs#!/word/getDefinitions

.LINK
https://developer.wordnik.com/docs#!/word/getEtymologies

.LINK
https://developer.wordnik.com/docs#!/word/getExamples

.LINK
https://developer.wordnik.com/docs#!/word/getWordFrequency

.LINK
https://developer.wordnik.com/docs#!/word/getHyphenation

.LINK
https://developer.wordnik.com/docs#!/word/getPhrases

.LINK
https://developer.wordnik.com/docs#!/word/getTextPronunciations

.LINK
https://developer.wordnik.com/docs#!/word/getRelatedWords

.LINK
https://developer.wordnik.com/docs#!/word/getScrabbleScore

.LINK
https://developer.wordnik.com/docs#!/word/getTopExample
#>
function Get-Word
{
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ApiKey,

        [Parameter(Mandatory)]
        [string]$Word,

        [Parameter()]
        [ValidateSet('audio','definitions','etymologies','examples','frequency','hypenation','phrases','pronunciations','relatedWords','scrabbleScore','topExample')]
        [string]$Property = 'definitions'
    )
    
    $Q = @{
        api_key=$ApiKey
        # limit=200
        # includeRelated=false
        # useCanonical=false
        # includeTags=false
    }

    $Query = ($q.keys | ForEach-Object { "{0}={1}" -f $_, $q[$_] }) -join '&'

    $BaseUri = 'https://api.wordnik.com/v4/word.json'

    $Uri = "{0}/{1}/{2}?{3}" -f $BaseUri, $Word, $Property, $Query
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
