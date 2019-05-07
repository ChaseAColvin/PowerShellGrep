function grep
{
    [cmdletbinding()]

    Param (
    [string]$pattern=".*",
    [switch]$e,
    [switch]$i,
    [switch]$v,
    [switch]$c,
    [parameter(ValueFromPipeline)]
    [psobject[]]$input
    )

    $output = [System.Collections.ArrayList]@()

    if ($input.Count -eq 0)
    {
        $input = Get-ChildItem -Path @(Get-Location)
    }
    
    $HashArguments = @{
        Pattern = $pattern
        SimpleMatch = !$e
        CaseSensitive = !$i
        NotMatch = $v
    }

    $output += ($input | Out-String -Stream | Select-String @HashArguments)
    
    if ($c)
    {
        $output.Count
    }
    else
    {
        $output
    }
}