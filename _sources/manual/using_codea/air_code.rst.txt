:reference-section: Tools & Settings

Air Code: work from your computer
=================================

Air Code connects your computer to Codea on your iPad or iPhone. Use Visual Studio Code to edit and debug a project while it runs on the device, with Codea-aware completion and reference information.

Open Air Code in Codea
-----------------------

.. codea-media:: images/using_codea/air-code.png
   :type: image
   :alt: The Air Code toolbar menu with server status and Air Code, AI Agent, and MCP help
   :caption: The main-screen Air Code menu shows connection status and setup help. This device shows the Codea Pro requirement.

Use the **Air Code** control on the project browser's main screen for connection status and help. To configure the server, open **Settings > Air Code**. Turn on **Enable Air Code** and note the **Server Address** and port. The pane has **Copy Address** and **Setup Guide** controls. Air Code requires Codea Pro.

Connect Visual Studio Code
--------------------------

1. Put the computer and device on the same reachable network and keep Codea open.
2. In VS Code, install the **Codea Air Code** extension.
3. Open the Command Palette and run **Codea: Connect to Host…**.
4. Select your device or enter the address and port shown by Codea. The default port is 18513.
5. Open a project from the connected file explorer, edit its Lua files, and run or restart it on the device.

Use the extension's Codea sidebar for reference information and live project parameters. Attach the debugger to inspect a running project, set breakpoints, and examine variables. Edits in this connected view work with the device's project; it is not a separate backup.

If a device does not appear, check that Air Code is enabled and use the displayed address directly. The **Setup Guide** also covers USB connections when the network is unsuitable.

Command-line and agent tools
----------------------------

The same settings pane includes **Install Codea CLI**, **Install Agent Skill**, and **MCP Server** setup controls. The install buttons copy commands to run on your computer. The CLI can discover Codea, transfer project files, run projects, inspect logs, and capture screenshots. Use the matching Setup Guide for your editor or agent.

Further reading
---------------

* `Air Code setup and usage <https://twolivesleft.github.io/codea-air-code/>`_ — the VS Code extension's official documentation.
* `Codea CLI on GitHub <https://github.com/twolivesleft/codea-cli>`_ — installation, connection, project-transfer, and automation workflows.
