{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModule.common-cpu-intel
    inputs.hardware.nixosModule.common-gpu-intel
    inputs.hardware.nixosModule.common-pc
    inputs.harwarde.nixosModule.common-pc-ssd
    ./hardware-configuration.nix
    ./configuration.nix
  ];

  system.stateVersion = "24.05";
}
