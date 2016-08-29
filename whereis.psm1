Function Where-Is {

  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$True, Position=0 , ValueFromPipeline = $True)]
    [String[]]$Filter,

    [Parameter()]
    [Switch]$ExactMatch = $false
  )

  Begin {

  } Process {


    If ($ExactMatch) {

      $Filter = "$Filter.*"

    } Else {

      $Filter = "*$Filter*"

    } # end if we want extact match

    ( $ENV:Path ).Split( ';' ) | ForEach-Object {

      Write-Verbose "checking $_ ... "

      Try {

        Get-ChildItem $_ -Filter "$($Filter)" -ErrorAction Stop

      } Catch {

        If ( $($_.CategoryInfo.Reason) -eq 'ItemNotFoundException' ) {

          Write-Warning """$($_.CategoryInfo.TargetName)"" not found ~ consider removing it from your ""Path"" Enviroment variable"

        } Else {

          Write-Error $_

        } # end if the error is that the path doesnt exist

      } # end try catch

    } # end for each directory in $PATH

  } # end end

} # end function
