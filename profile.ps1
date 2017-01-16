function Prompt
{
  $last_success = $?
  $isAdmin = '%'
  if(([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole] "Administrator"))
  {
    $isAdmin = '#'
  }
  $hostline = $env:username + '@' + $(hostname) + ':'
  $cwdline = shorten-path (pwd).Path

  if ( $Host.Name -eq "ConsoleHost" )
  {
    $Host.UI.RawUI.WindowTitle = (shorten-path (pwd).Path) + $isAdmin + ">"
    Write-Host ($hostline) -nonewline -foregroundcolor Blue
    Write-Host ($cwdline) -nonewline
    Write-Host ("`r`n") -nonewline
    if ($last_success)
    {
      Write-Host ($isAdmin + '>') -nonewline
    }
    else
    {
      Write-Host ($isAdmin + '>') -nonewline -foregroundcolor Black -backgroundcolor Red
    }
  }
  else
  {
    Write-Host ($hostline) -nonewline
    Write-Host ($cwdline) -nonewline
    Write-Host ("`r`n") -nonewline
    Write-Host ($isAdmin + '>') -nonewline
  }
  return " "
}

function shorten-path([string] $path)
{
  $loc = $path.Replace($HOME, '~')
  # remove prefix for UNC paths
  $loc = $loc -replace '^[^:]+::', ''
  return $loc
}

function which([string] $cmd)
{
  $(get-command $cmd).Definition
}
