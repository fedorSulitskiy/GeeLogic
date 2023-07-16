{ pkgs }: {
  deps = [
    pkgs.flutter
    pkgs.nodePackages.vscode-langservers-extracted
    pkgs.nodePackages.typescript-language-server  
  ];
}