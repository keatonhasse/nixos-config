{ config, ...  }:

{
  age.secrets.miniflux.file = ./secrets/miniflux.age;

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.age.secrets.miniflux.path;
    config = {
      PORT = "8081";
    };
  };
}
