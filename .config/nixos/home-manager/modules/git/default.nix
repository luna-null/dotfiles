{ pkgs, ... }:

{
  programs = {
    git = {
      enable = true;
      userName = "luna-null";
      delta.enable = true;
      ignores = [
        ".idea"
        ".user"
      ];
    };

    gitui = {
      enable = true;
    };
  };

  home.packages = with pkgs; [
    git-secret
  ];

}
