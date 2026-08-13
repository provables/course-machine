# Setting a machine for using in a AI/FM course

This flake will set up a Linux machine for use by VSCode as remote ssh target.

## Requirements

The requirements for the machine are:
- A normal non-root user.
- `ssh` access for the non-root user.

## Installing Nix

Install [Nix](https://nixos.org) with the following commands:

```bash
curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
# enable flakes
curl https://gist.githubusercontent.com/waltermoreira/d37daa2c915817e8eccf600fc9299a56/raw/enable-flakes.sh | sh -s
```

## Installing the tool

- Clone this repository locally.
- Edit the file `user.nix` to the desired values.
- Run the following:
  ```bash
  nix run
  ```
  *Note*: if the values in `user.nix` in the Git repository are correct for a machine,
  then one can simply run the following, without the need for cloning the repository:
  ```bash
  nix run github:provables/course-machine
  ```

## Updating the machine

The installation in the previous step provides a command `self-update`. Running this
command pulls the most recent version of the flake from Github and updates the system.

```
self-update
```

*Note*: this command runs automatically at installation time. A script or ansible
role **only** needs to perform the installation. The user is meant to run `self-update`
if necessary.
