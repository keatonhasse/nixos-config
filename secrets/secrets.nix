let
  keaton = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ+JwLQ/WiwLGo7oD7NSkJ7RXbDa62TiEZuEsPB/z8AP keaton@anton";
  anton = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOlPxeRecTmwrBwRws64H2v2ikLb4Ng9M9eAdIy/xwE/ root@nixos";
in
{
  "proton.age".publicKeys = [ keaton anton ];
  "airvpn.age".publicKeys = [ keaton anton ];
  "admin.age".publicKeys = [ keaton anton ];
  "tsnsrv.age".publicKeys = [ keaton anton ];
  "radarr-api-key.age".publicKeys = [ keaton anton ];
  "sonarr-api-key.age".publicKeys = [ keaton anton ];
  "miniflux.age".publicKeys = [ keaton anton ];
  "paperless.age".publicKeys = [ keaton anton ];
  "mailserver.age".publicKeys = [ keaton anton ];
}
