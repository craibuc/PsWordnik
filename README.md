# PsWordnik
PowerShell wrapper of Wordnik API.

## Examples

```powershell
Import-Module PsWordnik

$ApiKey='aaabbb'

Get-RandomWord -ApiKey $ApiKey

Get-WordOfTheDay -ApiKey $ApiKey

Get-Word -ApiKey $ApiKey -word 'orthogonal'
```