import requests
import os

# GitHub Personal Access Token
github_token = "YOUR_PERSONAL_ACCESS_TOKEN"
headers = {
    "User-Agent": "Mozilla/5.0",
    "Authorization": f"token {github_token}"
}

# Define the repositories to fetch
repositories_normal = [
    # Example entries (replace with actual repositories you need):
    # "owner1/repo1",
    # "owner2/repo2",
]

repositories_misc = [
    # Example entry (replace with actual repository and tag you need):
    # "owner/repo/tag",
]

output_directory = os.getcwd()

def download_latest_release(repo):
    try:
        print(f"Processing {repo}...")

        # Split the repo string to get owner and repository name
        owner, repository = repo.split("/")[:2]

        # Get release information from GitHub API
        release_url = f"https://api.github.com/repos/{repo}/releases/latest"
        response = requests.get(release_url, headers=headers)
        release_info = response.json()

        if repo == "VR-25/acc":
            asset = next((a for a in release_info["assets"] if a["name"].startswith("acc_v") and a["name"].endswith(".zip")), None)
            if not asset:
                print("No matching asset found for VR-25/acc release.")
                return
        elif repo == "tiann/KernelSU":
            asset = next((a for a in release_info["assets"] if a["name"].endswith(".apk")), None)
            if not asset:
                print("No .apk asset found for tiann/KernelSU release.")
                return
        else:
            asset = release_info["assets"][0] if release_info["assets"] else None
            if not asset:
                print(f"No assets found for {repo} release.")
                return

        # Define the output file path
        extension = os.path.splitext(asset["name"])[1]
        file_name = f"{output_directory}/{repository}{extension}"

        # Download the asset file
        print(f"Downloading {asset['browser_download_url']} to {file_name}...")
        asset_response = requests.get(asset["browser_download_url"], headers=headers)
        with open(file_name, "wb") as f:
            f.write(asset_response.content)
        print(f"Downloaded specific release of {repo} successfully!")
    except Exception as e:
        print(f"Failed to download {repo}: {e}")

def download_specific_tag(repo):
    try:
        print(f"Processing {repo}...")

        # Split the repo string to get owner, repository, and tag
        owner, repository, tag = repo.split("/")

        # Get the specific release information from GitHub API
        release_url = f"https://api.github.com/repos/{owner}/{repository}/releases/tags/{tag}"
        response = requests.get(release_url, headers=headers)
        release_info = response.json()

        asset = release_info["assets"][0] if release_info["assets"] else None
        if not asset:
            print(f"No assets found for {repo} release.")
            return

        # Define the output file path
        extension = os.path.splitext(asset["name"])[1]
        file_name = f"{output_directory}/{repository}_{tag}{extension}"

        # Download the asset file
        print(f"Downloading {asset['browser_download_url']} to {file_name}...")
        asset_response = requests.get(asset["browser_download_url"], headers=headers)
        with open(file_name, "wb") as f:
            f.write(asset_response.content)
        print(f"Downloaded specific release of {repo} successfully!")
    except Exception as e:
        print(f"Failed to download {repo}: {e}")

# Download from repositories_normal
for repo in repositories_normal:
    download_latest_release(repo)

# Download from repositories_misc
for repo in repositories_misc:
    download_specific_tag(repo)

print("Download process completed.")
