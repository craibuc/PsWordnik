Import-Module PsWordnik

$ApiKey='669xx3q5v53o4lhy3ublsdslndtwgdlxvaail2csieivystx2'

Get-RandomWord -ApiKey $ApiKey

Get-WordOfTheDay -ApiKey $ApiKey

Get-Word -ApiKey $ApiKey -word 'orthogonal'

# $Prompt = @'
# Choose the correct definition for 'orthogonal':
# A) unrelated
# B) lorem ipsum
# C) ipsum lorem

# '@

# $Answer = Read-Host -Prompt $Prompt

# if ($Answer -eq 'A') {'correct'} else {'incorrect'}