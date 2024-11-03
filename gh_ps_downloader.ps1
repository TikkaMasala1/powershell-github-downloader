# GitHub Personal Access Token (replace "YOUR_PERSONAL_ACCESS_TOKEN" with your actual token)
$githubToken = "YOUR_PERSONAL_ACCESS_TOKEN"

# Headers with authentication
$headers = @{
    'User-Agent' = 'Mozilla/5.0'
    'Authorization' = "token $githubToken"
}

# List of repositories to download the latest release from
# Format: "owner/repository"
$repositories_normal = @(
    # Example entries (replace with actual repositories you need):
    # "owner1/repo1",
    # "owner2/repo2",
)

# List of repositories to download a specific tagged release from
# Format: "owner/repository/tag"
$repositories_misc = @(
    # Example entry (replace with actual repository and tag you need):
    # "owner/repo/tag",
)

# Directory to save downloaded files (default: script's directory)
$outputDirectory = Split-Path -Parent -Path $MyInvocation.MyCommand.Path

# Download the latest release for each repository in $repositories_normal
foreach ($repo in $repositories_normal) {
    try {
        Write-Host "Processing $repo..."

        # Split the repo string to get owner and repository
        $parts = $repo -split '/'
        $owner = $parts[0]
        $repository = $parts[1]

        # Get the latest release information from GitHub API
        $releaseUrl = "https://api.github.com/repos/$repo/releases/latest"
        $releaseInfo = Invoke-RestMethod -Uri $releaseUrl -Headers $headers

        # Example of specific filtering logic for certain repositories
        if ("$owner/$repository" -eq "VR-25/acc") {
            # Filter for assets with names matching "acc_v*.zip"
            $asset = $releaseInfo.assets | Where-Object { $_.name -match '^acc_v.*\.zip$' } | Select-Object -First 1
        } 
        
        else {
            # Default: pick the first available asset if no specific filtering is needed
            $asset = $releaseInfo.assets | Select-Object -First 1
        }

        # If no matching asset found, skip to the next repository
        if (!$asset) {
            Write-Host "No matching asset found for $repo release." -ForegroundColor Yellow
            continue
        }

        # Define the output file path with only the tag and file extension
        $extension = [System.IO.Path]::GetExtension($asset.name)
        $fileName = "$outputDirectory\$repository$extension"

        # Download the asset file
        Write-Host "Downloading $($asset.browser_download_url) to $fileName..."
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $fileName -Headers $headers

        Write-Host "Downloaded latest release of $repo successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to download ${repo}: $_" -ForegroundColor Red
    }
}

# Download specific tagged releases for each repository in $repositories_misc
foreach ($repo in $repositories_misc) {
    try {
        Write-Host "Processing $repo..."

        # Split the repo string to get owner, repository, and tag
        $parts = $repo -split '/'
        $owner = $parts[0]
        $repository = $parts[1]
        $tag = $parts[2]

        # Get the specific release information from GitHub API
        $releaseUrl = "https://api.github.com/repos/$owner/$repository/releases/tags/$tag"
        $releaseInfo = Invoke-RestMethod -Uri $releaseUrl -Headers $headers

        # Select the first available asset
        $asset = $releaseInfo.assets | Select-Object -First 1
        if (!$asset) {
            Write-Host "No assets found for $repo release." -ForegroundColor Yellow
            continue
        }

        # Define the output file path using only the tag and file extension
        $extension = [System.IO.Path]::GetExtension($asset.name)
        $fileName = "$outputDirectory\$repository_$tag$extension"

        # Download the asset file
        Write-Host "Downloading $($asset.browser_download_url) to $fileName..."
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $fileName -Headers $headers

        Write-Host "Downloaded specific release of $repo successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to download ${repo}: $_" -ForegroundColor Red
    }
}

Write-Host "Download process completed."
