# To remove duplicate picture and video files from a given directory

# Input the full file path of the root directory
$rootpath = "D:\Pictures"

# Collect only directories one level under the root path
$subdirectories = Get-ChildItem -Path $rootpath -Directory

# Creates a Duplicates directory under each subdirectory of the root path provided, locates all
# files that contain a "(" symbol, and move them to the Duplicates directory
foreach ($dir in $subdirectories.FullName) {
    $dupespath = New-Item -Path $dir -Name "Duplicates" -ItemType Directory -Confirm:$false
    $items = Get-ChildItem -Path $dir
    $dupes = $items | Where-Object {$_.Name -like "*(*"}
    $dupes | Move-Item -Destination $dupespath -Confirm:$false -Verbose -ErrorAction SilentlyContinue
}
