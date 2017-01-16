# It is called to show prompt.
function Prompt
{
  # save [int] $LASTEXITCODE, [boolean] $?.
  $orig_last_exit_code = $LASTEXITCODE
  $orig_last_success = $?

  # Check if it is adminisrative shell or not.
  $isAdmin = '%'
  if(([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole] "Administrator"))
  {
    $isAdmin = '#'
  }

  $hostline = $env:username + '@' + $(hostname) + ':'
  $cwdline = shorten-path (pwd).Path

  # Detect terminal type.
  if ( $Host.Name -eq "ConsoleHost" )
  {
    Write-Host ($hostline) -nonewline -foregroundcolor Blue
    Write-Host ($cwdline) -nonewline
    Write-VcsStatus
    Write-Host ("`r`n") -nonewline
    if ($orig_last_success)
    {
      Write-Host ($isAdmin + '>') -nonewline
    }
    else
    {
      # On error, show the prompt in red.
      Write-Host ($isAdmin + '>') -nonewline -foregroundcolor Black -backgroundcolor Red
    }

    # Set window title.
    $Host.UI.RawUI.WindowTitle = (shorten-path (pwd).Path) + $isAdmin + ">"
  }
  else
  {
    Write-Host ($hostline) -nonewline
    Write-Host ($cwdline) -nonewline
    Write-VcsStatus
    Write-Host ("`r`n") -nonewline
    Write-Host ($isAdmin + '>') -nonewline
  }
  # restore $LASTEXITCODE.
  # TODO: why assignment to $? leads to error?
  $LASTEXITCODE = $orig_last_exit_code
  return " "
}

# Replace $HOME with ~ and remove UNC prefixes.
function shorten-path([string] $path)
{
  $loc = $path.Replace($HOME, '~')
  $loc = $loc -replace '^[^:]+::', ''
  return $loc
}

# Just a shorthand for get-command.
function which([string] $cmd)
{
  $(get-command $cmd).Definition
}

# Add myconfig to module path.
$env:PSModulePath += ';' + (get-item $MyInvocation.MyCommand.Path).DirectoryName + '\posh.d'

Import-Module posh-git

# Just a shorthand; it is convenient when working in a large repository.
function disable-file-status
{
  $GitPromptSettings.EnableFileStatus = $false
}

# Use bash-like completion behavior.
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# Go home when cd is invoked with no argument.
rm Alias:cd
function cd
{
  if ($args.Length -gt 0)
  {
    Set-Location $args[0]
  }
  else
  {
    Set-Location $env:HOME
  }
}
