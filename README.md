# Powershell Github Downloader
A simple Powershell script I made to download all the necessary modules/files I need after flashing custom roms on my phone.

Make sure to create a personal access token:
[GitHub Settings > Developer Settings > Personal Access Tokens.](https://github.com/settings/tokens/) 

And replace `YOUR_PERSONAL_ACCESS_TOKEN` with your token

### Example repository list:
```
# Format: "owner/repository"
$repositories_normal = @(
    "osm0sis/PlayIntegrityFork",
    "capntrips/KernelFlasher",
    "5ec1cff/TrickyStore",
    "chenxiaolong/BCR",
    "j-hc/zygisk-detach",
    "j-hc/zygisk-detach-app",
    "JingMatrix/LSPosed",
    "LSPosed/LSPosed.github.io",
    "Mahmud0808/Iconify",
    "Mahmud0808/ColorBlendr",
    "siavash79/PixelXpert",
    "topjohnwu/Magisk",
    "Dr-TSNG/ZygiskNext",
    "VR-25/acc",
    "tiann/KernelSU"
)


# Format: "owner/repository/tag"
$repositories_misc = @(
    "siavash79/PixelXpert/canary_builds"
)
```
