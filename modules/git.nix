{ pkgs, config, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      user.name = config.my.name;
      user.email = config.my.email;
      alias = {
        co = "checkout";
        ci = "commit";
        st = "status";
        gl = "log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
      };
      push.default = "simple";
      init.defaultBranch = "main";
    };
  };
}
