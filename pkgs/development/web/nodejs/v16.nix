{ callPackage, fetchpatch, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.14.0";
    sha256 = "sha256-BetkGT45H6iiwVnA9gwXGCRxUWX4DGf8q528lE4wxiM=";
    patches = [
      ./disable-darwin-v8-system-instrumentation.patch
      # Fixes node incorrectly building vendored OpenSSL when we want system OpenSSL.
      # https://github.com/nodejs/node/pull/40965
      (fetchpatch {
        url = "https://github.com/nodejs/node/commit/65119a89586b94b0dd46b45f6d315c9d9f4c9261.patch";
        sha256 = "sha256-dihKYEdK68sQIsnfTRambJ2oZr0htROVbNZlFzSAL+I=";
      })
    ];
  }
