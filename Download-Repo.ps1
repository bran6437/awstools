#Credit https://blog.sandro-pereira.com/2020/09/01/how-to-download-a-github-repository-using-powershell/
function DownloadGitHubRepository
{
    param(
       [Parameter()]
       [string]
       $Name,

       [Parameter()]
       [string]
       $Author,

       [Parameter()]
       [string] $Branch = "main",

       [Parameter()]
       [string] $Location = "$env:USERPROFILE\Documents"
    )
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Force to create a zip file
    $ZipFile = "$location\$Name.zip"
    New-Item $ZipFile -ItemType File -Force | Out-Null

    $RepositoryZipUrl = "https://api.github.com/repos/$Author/$Name/zipball/$Branch"

    # download the zip
    Write-Host 'Downloading the GitHub Repository'
    Invoke-RestMethod -Uri $RepositoryZipUrl -OutFile $ZipFile
    Write-Host 'Download finished'

    #Extract Zip File
    Write-Host 'Unzipping the GitHub Repository locally'
    $unzip = Expand-Archive -Path $ZipFile -DestinationPath $location -Force -PassThru -Verbose
    $newRepo = $unzip | Where-Object { $_.attributes -match 'Directory' -and $_.basename -match "$author-$name-" }
    Write-Host "Unzip finished. Enjoy.`n$($newRepo.FullName) "

    # remove the zip file
    Remove-Item -Path $ZipFile -Force -ErrorAction SilentlyContinue
}

DownloadGitHubRepository -Name awstools -Author bran6437 -Branch main -Location "$env:USERPROFILE\Documents"
