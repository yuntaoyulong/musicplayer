# Maintainer: Your Name <you@example.com>
pkgname=mistplayer
pkgver=0.1.0
pkgrel=2
pkgdesc="Hyprland-friendly local media player with fog-white translucent UI"
arch=('x86_64')
url="https://example.com/mistplayer"
license=('MIT')
depends=('qt6-base' 'qt6-declarative' 'qt6-multimedia')
makedepends=('cmake' 'ninja' 'gcc' 'git')
source=("${pkgname}-${pkgver}::git+file://${startdir}")
sha256sums=('SKIP')

build() {
  cmake -S "$srcdir/${pkgname}-${pkgver}" -B "$srcdir/build" -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr
  cmake --build "$srcdir/build"
}

package() {
  DESTDIR="$pkgdir" cmake --install "$srcdir/build"
}
