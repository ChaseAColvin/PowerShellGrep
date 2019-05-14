function Search-ObjectAsString
{
    [cmdletbinding()]
    param(
    [Parameter(Position=0,
    Mandatory=$true)]
    [string]$pattern,
    [Parameter(
    Position=1,
    ValueFromRemainingArguments)]
    [array]$in,
    [Parameter(ValueFromPipeline)]
    $input,
    [switch]$e,
    [switch]$i,
    [switch]$v,
    [switch]$c,
    [switch]$n
    )

    $out = [System.Collections.ArrayList]@()
    $error = [System.Collections.ArrayList]@()

    $HashArguments = @{
        Pattern = $pattern
        SimpleMatch = !$e
        CaseSensitive = !$i
        NotMatch = $v
    }

    if ($in)
    {
        $files = [System.Collections.ArrayList]@()

        foreach ($item in $in)
        {
            if (Test-Path $item)
            {
                if ((Get-Item $item).Mode -notlike "d*")
                {
                    $files += Get-ChildItem $item | Where-Object {$_.Mode -notlike "d*"}
                }
                else
                {
                    $error += "grep: $($item): Is a directory"
                }
            }
            else
            {
                $error += "grep: $($item): No such file or directory"
            }
        }

        foreach ($file in ($files | Sort-Object -Unique))
        {
            $content = Get-Content $file.FullName

            $contentMatches = @($content | Out-String -Stream | Select-String @HashArguments)
                
            if ($c)
            {
                if ($in.Count -gt 1)
                {
                    $out += "$($file.Name):$($contentMatches.Count)"
                }
                else
                {
                    $out += "$($contentMatches.Count)"
                }
            }
            else
            {
                foreach ($contentMatch in $contentMatches)
                {
                    if ($in.Count -gt 1)
                    {
                        if ($n)
                        {
                            $out += "$($file.Name):$($contentMatch.LineNumber):$($contentMatch.Line)"
                        }
                        else
                        {
                            $out += "$($file.Name):$($contentMatch.Line)"
                        }
                    }
                    else
                    {
                        if ($n)
                        {
                            $out += "$($contentMatch.LineNumber):$($contentMatch.Line)"
                        }
                        else
                        {
                            $out += "$($contentMatch.Line)"
                        }
                    }
                }
            }
        }

        $out
        $error
    }
    elseif ($input)
    {
        $contentMatches = @($input | Out-String -Stream | Select-String @HashArguments)

        if ($c)
        {
            $contentMatches.Count
        }
        else
        {
            foreach ($contentMatch in $contentMatches)
            {
                if ($n)
                {
                    $out += "$($contentMatch.LineNumber):$($contentMatch.Line)"
                }
                else
                {
                    $out += "$($contentMatch.Line)"
                }
            }
            
            $out
        }   

    }
    else
    {
        Throw "No input argument supplied."
        Return 1
    }
}

Set-Alias -Name grep -Value Search-ObjectAsString