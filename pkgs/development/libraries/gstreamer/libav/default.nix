{ stdenv, fetchurl, pkgconfig, python, yasm
, gst-plugins-base, orc, bzip2
, withSystemLibav ? true, libav ? null
}:

assert withSystemLibav -> libav != null;

stdenv.mkDerivation rec {
  name = "gst-libav-1.4.3";

  meta = {
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-libav/${name}.tar.xz";
    sha256 = "833229d2b1aad6549ad0297435516508cc3ac47b166d6393ecdffc34c31a01d3";
  };

  configureFlags = stdenv.lib.optionalString withSystemLibav
    "--with-system-libav";

  nativeBuildInputs = with stdenv.lib;
    [ pkgconfig python ]
    ++ optional (!withSystemLibav) yasm
    ;

  buildInputs = with stdenv.lib;
    [ gst-plugins-base orc bzip2 ]
    ++ optional withSystemLibav libav
    ;
}
