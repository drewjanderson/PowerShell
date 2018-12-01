# To remove duplicate picture and video files from a given directory

$rootpath = "D:\Pictures"

# Collect only directories one level under the root path
$subdirectories = Get-ChildItem -Path $rootpath -Directory

foreach ($dir in $subdirectories.FullName) {
    $dupespath = New-Item -Path $dir -Name "Duplicates" -ItemType Directory -Confirm:$false
    $items = Get-ChildItem -Path $dir
    $dupes = $items | Where-Object {$_.Name -like "*(*"}
    $dupes | Move-Item -Destination $dupespath -Confirm:$false
}
