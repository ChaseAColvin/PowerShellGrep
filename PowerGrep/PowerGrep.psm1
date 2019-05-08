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
    
    $HashArguments = @{
        Pattern = $pattern
        SimpleMatch = !$e
        CaseSensitive = !$i
        NotMatch = $v
    }

    if ($in)
    {
        foreach ($item in $in)
        {
            $files = Get-ChildItem $item

            foreach ($file in $files)
            {
                $content = Get-Content $file

                $contentMatches = @($content | Out-String -Stream | Select-String @HashArguments)
                
                if ($c)
                {
                    if ($files.Count -gt 1)
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
                        if ($files.Count -gt 1)
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
        }
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
        }   

    }
    else
    {
        Throw "No input argument supplied."
        Return 1
    }
}

Set-Alias -Name grep -Value Search-ObjectAsString