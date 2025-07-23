# TLDR (WIP)

## Create WinPE USB

- [download](https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install) and install the Windows ADK and PE add-on

  ![](images/adk_urls.png)

  you only need the `Deployment Tools` from the base package  
  ![](images/deployment_tools.png)

  ![](images/pe_addon.png)

- you may have to change the `adk_path` in `create_winpe.cmd` depending on your ADK version
- run `create_winpe.cmd` as admin in a folder you want the ISO to be created in
- use Rufus or Ventoy for a bootable USB

## App shortcuts

- run `%mousetester_v%` etc. in the command prompt to launch apps
- the `%screenshot%` command takes a target directory as argument, e.g., `%screenshot% C:\screenshot.png`, and has a 2-second delay
