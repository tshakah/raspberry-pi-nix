{ rpicam-apps-src, lib, pkgs, stdenv }:

stdenv.mkDerivation {
  pname = "libcamera-apps";
  version = "v1.5.0";

  src = rpicam-apps-src;

  nativeBuildInputs = with pkgs; [ meson pkg-config makeWrapper ];
  buildInputs = with pkgs; [ libjpeg libtiff libcamera libepoxy boost libexif libpng ffmpeg libdrm ninja ];
  mesonFlags = [
    "-Denable_qt=disabled"
    "-Denable_opencv=disabled"
    "-Denable_tflite=disabled"
    "-Denable_egl=disabled"
    "-Denable_hailo=disabled"
    "-Denable_drm=enabled"
  ];
  # Meson is no longer able to pick up Boost automatically.
  # https://github.com/NixOS/nixpkgs/issues/86131
  BOOST_INCLUDEDIR = "${lib.getDev pkgs.boost}/include";
  BOOST_LIBRARYDIR = "${lib.getLib pkgs.boost}/lib";

  postFixup = ''
    wrapProgram $out/bin/rpicam-hello \
      --set LIBCAMERA_IPA_PROXY_PATH ${pkgs.libcamera}/libexec/libcamera

    wrapProgram $out/bin/rpicam-raw \
      --set LIBCAMERA_IPA_PROXY_PATH ${pkgs.libcamera}/libexec/libcamera

    wrapProgram $out/bin/rpicam-vid \
      --set LIBCAMERA_IPA_PROXY_PATH ${pkgs.libcamera}/libexec/libcamera

    wrapProgram $out/bin/rpicam-jpeg \
      --set LIBCAMERA_IPA_PROXY_PATH ${pkgs.libcamera}/libexec/libcamera

    wrapProgram $out/bin/rpicam-still \
      --set LIBCAMERA_IPA_PROXY_PATH ${pkgs.libcamera}/libexec/libcamera
  '';

  meta = with lib; {
    description = "Userland tools interfacing with Raspberry Pi cameras";
    homepage = "https://github.com/raspberrypi/libcamera-apps";
    license = licenses.bsd2;
    platforms = [ "aarch64-linux" ];
  };
}
