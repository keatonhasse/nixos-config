{ config, ...  }:

{
  age.secrets.miniflux.file = ./secrets/miniflux.age;

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.age.secrets.miniflux.path;
    config = {
      LISTEN_ADDR = "localhost:8069";
    };
  };
}
