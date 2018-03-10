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
  ".swayconfig"
  ".tmux.conf"
  ".toprc"
  ".vimrc"
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
sha256sums=(
  "9321c2c84a30306119fd54592c5a508c2a4d4db7a4c6cb7b1416699e7036c3e7"
  "c67c51210216df32ef1a27c6a72c3b087eee5813d37186508ff72dee4c3a7c92"
  "60a406c15fba24e29be64c9f2ba56bb569534c7485b2ee34d2621f8949cf7ae3"
  "2d5e36d80b802c9febe38aeef7392e037663604c38520909d4741a111904279f"
  "9916e00a28a31ea26af3de2023b037ba64b65f5bea0c27c31d1102f475053cfb"
  "45153e7df00c45ecb7f819b642fc4d2d0f5df6d4dd7ea016f86fab159cb59c2b"
  "95835fdfe645d21f09cdb06f01ac617e6573c32bc6397dc08b59281250e94963"
  "83cd8a2fc41a05acb62e20f2d9af4a80d6dda9b90ae87bef7dfb52c6af210688"
  "3d94835f03b22ed89927a50f1ed79a75285bb23f3822faebc3ee31675917c9a8"
  "38e291a9f5a8f93f553b849d7881a0c15d27efe2e876a17261b8c7d2ba71d8a5"
  "603faaac102da0f7dea9cc92f525a8e991769dab5353682a3fd8d6f9ea034617"
  "e7b69917113583b09059551778894fcb4bab18b95c0d5aaec1ea77bf001f5769"
  "7d35bf305e2af6c1fc1ae0e87823981ca9b237de577daf44b436db7edb61845c"
  "fb5052e2f847484640d2030a1f3a30ab6a7dc29d0ff2aba9531547b175dcbbd8"
  "5c8c6854efa23de30cdb73e86562f9c78ca75880415a3696be49e30041814d8a"
  "caa881a458a8ea94fe69dd1bf5ad6bae8ad3cc2a75d696a9101b84a6f0653db6"
  "0e740a3617248b6433bff349a99b663d978d0016c9614eff2f271344070840aa"
  "ef4926e421c5c4365c5747b1e7a80f79d91f27df4b5a47a1a916e838cb5f5818"
  "8e90b5b82930ad5c6f69664d195e68c76d2cb4c1e44f3927d88bccc054d22039"
  "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  "734553472c3c9cf2d2ddb8353df060f5c5e6826a920cc419d13b0ee1af618035"
  "cf8d7cc24c05e2065cce6c642a802c5675573a203490ed47058bbc0f1a06db20"
)
arch=("any")
depends=("")

prepare() {
  patch --follow-symlinks < "changes-$(hostname).patch"
}

package() {
  install -dm710 "${pkgdir}$HOME"
  install -dm700 "${pkgdir}$HOME/.config"

  install -Dm644 "redshift.conf" "${pkgdir}$HOME/.config/redshift.conf"
  curl -s -N "https://ipinfo.io/geo"                                          \
    | awk -F\" '/loc/ {split($4, x, ","); print "lat=" x[1] "\nlon=" x[2]}'   \
    >> "${pkgdir}$HOME/.config/redshift.conf"

  find $HOME/.files -maxdepth 1 -type f -iname ".*"                           \
    -exec ln -fs {} "${pkgdir}$HOME" \;
  install -Dm644 ".makepkg.conf" "${pkgdir}$HOME/.makepkg.conf"

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