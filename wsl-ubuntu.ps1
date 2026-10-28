$workVhd = "C:\tkwsl\work-btrfs.vhdx"
$distro  = "Ubuntu-24.04"

# Btrfs VHDX を WSL に接続
#wsl.exe --mount --vhd "$workVhd" --bare *> $null

# WSL を起動
wsl.exe -d $distro -u root -- /bin/true *> $null

# Btrfs を /work にマウント
# すでにマウント済みなら何もしない
wsl.exe -d $distro -u root -- sh -c `
    "mkdir -p /work; mountpoint -q /work || mount -t btrfs LABEL=work /work"

# usbipd attach中にUbuntuが終了しないよう、
# 数秒間だけWSLプロセスを維持する
$keepAlive = Start-Process `
    -FilePath "wsl.exe" `
    -ArgumentList "-d", $distro, "--", "sleep", "10" `
    -WindowStyle Hidden `
    -PassThru

Start-Sleep -Milliseconds 500

# USBコントローラーをWSLへ接続
usbipd attach --wsl --busid 1-9 *> $null

# 通常ユーザーでホームディレクトリから起動
#wsl.exe -d $distro --cd ~

# 既存Terminalに新しいタブ
#wt.exe new-tab wsl.exe -d Ubuntu-24.04 --cd ~

# 新しい Windows Terminal ウィンドウで Ubuntu を開く
Start-Process wt.exe -ArgumentList '-w', 'new', 'wsl.exe', '-d', $distro, '--cd', '~'