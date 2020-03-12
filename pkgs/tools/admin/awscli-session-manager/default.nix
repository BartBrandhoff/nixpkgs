{ stdenv, fetchurl, dpkg, unzip, python3, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "awscli-session-manager";
  version = "1.1.54.0";

  src =
    fetchurl rec {
      url = "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb";
      sha256 = "342602b05552268966bcac2ec7698447e1202eb8e3d2943066dd9954697604ef";
    };

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";
  sourceRoot = ".";

  nativeBuildInputs = [
      autoPatchelfHook # Automatically setup the loader, and do the magic
      dpkg
    ];

  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    mv $out/usr/local/sessionmanagerplugin/bin $out/bin
  '';

  meta = with stdenv.lib; {
    description = "AWS Systems Manager Session Manager";
    longDescription = ''
      Session Manager is a fully managed AWS Systems Manager capability that
      lets you manage your Amazon EC2 instances, on-premises instances,
      and virtual machines (VMs).
    '';
    license = licenses.bsd3;
  };
}
