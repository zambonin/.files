# Maintainer: Gustavo Zambonin <gzmbnn at gmail dot com>
# Contributor:

pkgname=("dotfiles")
pkgver=1
pkgrel=1
pkgdesc="system configurations"
url="https://github.com/zambonin/.files"
license=("GPL")
install="dotfiles.install"

source=(
  ".Xresources"
  ".aliases"
  ".asoundrc"
  ".bash_profile"
  ".bashrc"
  ".gitconfig"
  ".gitignore_global"
  ".inputrc"
  ".makepkg.conf"
  ".tmux.conf"
  ".toprc"
  ".vimrc"
  ".wmconfig"
  "10-journald-custom.conf"
  "backup.service"
  "backup.timer"
  "redshift.conf"
  "suspend@.service"
  "vconsole.conf"
  "changes-galileo.patch"
  "changes-hubble.patch"
  "changes-kepler.patch"
)
sha256sums=('9321c2c84a30306119fd54592c5a508c2a4d4db7a4c6cb7b1416699e7036c3e7'
            'c67c51210216df32ef1a27c6a72c3b087eee5813d37186508ff72dee4c3a7c92'
            '60a406c15fba24e29be64c9f2ba56bb569534c7485b2ee34d2621f8949cf7ae3'
            'd9c00a931a42498deeb9b65c44d968b75c1282b2d8589067ed07861b053ede09'
            '9916e00a28a31ea26af3de2023b037ba64b65f5bea0c27c31d1102f475053cfb'
            '45153e7df00c45ecb7f819b642fc4d2d0f5df6d4dd7ea016f86fab159cb59c2b'
            '34e314dc168394cbcf61d9c19ab764645c129e002e9d1ae6270b464e3fa68724'
            '83cd8a2fc41a05acb62e20f2d9af4a80d6dda9b90ae87bef7dfb52c6af210688'
            '3d94835f03b22ed89927a50f1ed79a75285bb23f3822faebc3ee31675917c9a8'
            '603faaac102da0f7dea9cc92f525a8e991769dab5353682a3fd8d6f9ea034617'
            'e7b69917113583b09059551778894fcb4bab18b95c0d5aaec1ea77bf001f5769'
            'd89a8d3fdb043d37e3361d4b2148894e83dbb8bb24b28f1fa5e74f32a42cb621'
            '63c9b1627f57799796cf4394b2948ed933eac6cf7644d2d2d835cd5ba2db6915'
            'fb5052e2f847484640d2030a1f3a30ab6a7dc29d0ff2aba9531547b175dcbbd8'
            '4025d6e12b1c61d2bfc2d94f411c5348090634c925f86f790ee41c535c2fb97e'
            'caa881a458a8ea94fe69dd1bf5ad6bae8ad3cc2a75d696a9101b84a6f0653db6'
            '0e740a3617248b6433bff349a99b663d978d0016c9614eff2f271344070840aa'
            'b700834629f7b7d3f79f6e29905ab24cf0bd94ff5ca38901770763e981091aee'
            '8e90b5b82930ad5c6f69664d195e68c76d2cb4c1e44f3927d88bccc054d22039'
            'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
            '25fc903eb625555ef7504a299d7865bb93196301e7a070921736ff32e7e7803c'
            '26e53416e1d6fab092dc77acc1da682101aed28dfa765d6890cb9533831aa642')
arch=("any")
optdepends=(
  "ntp" "ntfs-3g" "alsa-utils" "efibootmgr" "gptfdisk" "intel-ucode"
  "rxvt-unicode" "tmux" "gvim" "git" "parallel" "openssh" "scrot" "imagemagick"
  "unzip" "unrar" "p7zip" "atool" "rsync" "samba" "lesspipe" "udevil"
  "clang" "clang-tools-extra" "valgrind" "gdb" "qemu" "ovmf" "openmp" "perf"
  "python" "python-pip" "python-pylint" "tk" "feh" "xorg-server" "xorg-xinit"
  "rofi" "sway" "transmission-cli" "xorg-xrdb" "firefox" "zathura-pdf-poppler"
  "mpv" "texlive-core" "texlive-latexextra" "texlive-pictures" "freerdp"
  "redshift-wayland-git" "shellcheck-static" "steamcmd" "pacman-contrib"
  "vim-badwolf-git" "vim-gitgutter-git" "vim-lightline-git"
)

prepare() {
  patch --follow-symlinks < "changes-$(hostname).patch"
}

package() {
  install -dm700 "${pkgdir}$HOME"
  install -dm700 "${pkgdir}$HOME/.config"

  install -Dm644 "redshift.conf" "${pkgdir}$HOME/.config/redshift.conf"
  curl -s -N "https://ipinfo.io/geo"                                          \
    | awk -F\" '/loc/ {split($4, x, ","); print "lat=" x[1] "\nlon=" x[2]}'   \
    >> "${pkgdir}$HOME/.config/redshift.conf"

  find "$HOME/.files" -maxdepth 1 -type f -iname ".*"                         \
    -exec install -Dm644 {} "${pkgdir}$HOME" \;
  find "${srcdir}" -maxdepth 1 -type f -iname ".*"                            \
    -exec install -Dm644 {} "${pkgdir}$HOME" \;

  install -Dm644 "backup.timer"                                               \
    "${pkgdir}/usr/lib/systemd/system/backup.timer"
  install -Dm644 "backup.service"                                             \
    "${pkgdir}/usr/lib/systemd/system/backup.service"
  install -Dm644 "suspend@.service"                                           \
    "${pkgdir}/usr/lib/systemd/system/suspend@.service"
  install -Dm644 "10-journald-custom.conf"                                    \
    "${pkgdir}/usr/lib/systemd/journald.conf.d/10-custom-rules.conf"
  install -Dm644 "vconsole.conf"                                              \
    "${pkgdir}/etc/vconsole.conf"
}
