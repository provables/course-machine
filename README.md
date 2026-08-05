# Setting a machine for using in a AI/FM course

This flake will set up a Linux machine for use by VSCode as remote ssh target.

## Requirements

The requirements for the machine are:
- A [Nix](https://nixos.org) installation.
- A normal non-root user.
- `ssh` access for the non-root user.

## Running the tool

- Clone this repository locally.
- Edit the file `user.nix` to the desired values.
- Run the following:
  ```shell
  nix build
  sudo ./result/bin/setup
  ```
  (Note: `sudo` is necessary to change the shell of the user. The previous commands
  can be run as root or as any other user that has `sudo` privileges. The configuration
  will be created for the unprivileged user defined in the file `user.nix`, who 
  **will not** need `sudo` access.)

