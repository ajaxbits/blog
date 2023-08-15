+++
title = "Gitops"
date = 2023-05-17
draft = false

[taxonomies]
categories = ["Features"]
tags = ["config"]
+++

# GitOps Homelab Deploys with NixOS and Tailscale
> Or: Bringing the buzzword salad home to roost

Look, architectures are hard. Sometimes a girlie just wants to bump the [Audiobookshelf](https://audiobookshelf.org) image on his homelab without having to open an x86 box ok?

I’m starting to run a lot more services off of my homelab these days. I’m set up with deploy-rams and nixos. 

This means that with something like:

```nix
{
  inputs.deploy-rs.url = “github:serokell/deploy-rs”;

  outputs = { self, nixpkgs, deploy-rs }: {
    # define my homelab configuration
    nixosConfigurations.agamemnon = nixpkgs.lib.nixosSystem {
      system = “x86_64-linux”;
      services.paperless-ngx.enable = true;
    };

    # define deployment parameters
    deploy.nodes.agamemnon.profiles.system = {
        hostname = “192.168.0.3”;
        user = “root”;
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.some-random-system;
    };
  };
}
```

I can run `deploy`on my Linux laptop to spin up a paperless-ngx server on my homelab. 

[Determinate systems](https://determinate.systems)has done a lot of great work making convenient GitHub actions to run Nix. 

## Things you need
* Tailscale-connected NixOS machine

## Making it happen
* Get an example deploy-rs config going

## Exploring further
* Hook this up with Colmena or another deployment technique to see what things are different
* It’s kind of slow on free tier. Could be faster if you have the coin. 


[Nixos autoconnect](https://tailscale.com/kb/1096/nixos-minecraft/) module
