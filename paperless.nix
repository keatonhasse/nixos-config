{ config, ... }:

{
  age.secrets.paperless.file = ./secrets/paperless.age;

  services.paperless = {
    enable = false;
    address = "0.0.0.0";
    passwordFile = config.age.secrets.paperless.path;
    settings = {
      PAPERLESS_URL = "https://paperless.tailc0593.ts.net";
      PAPERLESS_ADMIN_USER = "keaton";
    };
  };
}
