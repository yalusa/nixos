{ lib
, stdenv
, makeWrapper
, python3
, tcl
, tk
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [
    requests
    feedparser
    matplotlib
    pandas
    yfinance
    tkinter
  ]);
in
stdenv.mkDerivation {
  pname   = "market-dashboard";
  version = "1.6.38";

  src = lib.cleanSource /mnt/data/GDrive/AI/market;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs       = [ pythonEnv tcl tk ];

  dontBuild = true;
  passthru = { inherit pythonEnv; };

  installPhase = ''
    runHook preInstall

    install -Dm 644 market_dashboard.py \
      $out/share/market-dashboard/market_dashboard.py

    makeWrapper ${pythonEnv}/bin/python3 $out/bin/market-dashboard \
      --add-flags "$out/share/market-dashboard/market_dashboard.py" \
      --set PYTHONPATH "${pythonEnv}/${python3.sitePackages}" \
      --set TCL_LIBRARY "${tcl}/lib/tcl${tcl.version}" \
      --set TK_LIBRARY  "${tk}/lib/tk${tk.version}"

    install -Dm 644 icons/hicolor/market-dashboard.svg \
      $out/share/icons/hicolor/scalable/apps/market-dashboard.svg

    install -Dm 644 /dev/stdin \
      $out/share/applications/market-dashboard.desktop << 'EOF'
[Desktop Entry]
Name=Market Dashboard
Comment=Financial Market Dashboard — live prices, news, economic calendar
Exec=market-dashboard
Icon=market-dashboard
Terminal=false
Type=Application
Categories=Office;Finance;
StartupWMClass=tk
EOF

    runHook postInstall
  '';

  meta = with lib; {
    description = "Financial Market Dashboard";
    longDescription = ''
      Full-screen Tkinter dashboard displaying live currency, commodity,
      index and equity prices alongside financial/sports news feeds and
      an economic calendar for US and South Africa.
    '';
    license     = licenses.mit;
    platforms   = platforms.linux;
    mainProgram = "market-dashboard";
  };
}
