:reference-section: Tools & Settings

Air Code: work from your computer
=================================

Air Code lets you edit a project on your computer while it runs on your iPad or iPhone. Use Visual Studio Code for code completion, reference information, and debugging.

Open Air Code in Codea
-----------------------

.. codea-media:: images/using_codea/air-code.png
   :type: image
   :alt: The Air Code toolbar menu with server status and Air Code, AI Agent, and MCP help
   :caption: The Air Code menu shows the server address, connection tools, and setup guides for your computer.

Open **Settings > Air Code** and turn on **Enable Air Code**. Use **Copy Address** to copy the server address, or **Setup Guide** for help. The main-screen **Air Code** menu also shows the address and help links. Air Code requires Codea Pro.

Connect Visual Studio Code
--------------------------

1. Put the computer and device on the same reachable network and keep Codea open.
2. In VS Code, install the **Codea Air Code** extension.
3. Open the Command Palette and run **Codea: Connect to Host…**.
4. Select your device or enter the address and port shown by Codea. The default port is 18513.
5. Open a project from the connected file explorer, edit its Lua files, and run or restart it on the device.

Use the Codea sidebar in VS Code to browse the reference and adjust project parameters. Attach the debugger to set breakpoints and inspect variables. Your edits update the project on the device.

If a device does not appear, check that Air Code is enabled and use the displayed address directly. The **Setup Guide** also covers USB connections when the network is unsuitable.

Command-line and agent tools
----------------------------

The Air Code settings also include **Install Codea CLI**, **Install Agent Skill**, and **MCP Server** setup. The install buttons copy commands to run on your computer. Use these tools to transfer projects, run them, read logs, and capture screenshots from your terminal or coding agent.

Further reading
---------------

* `Air Code setup and usage <https://twolivesleft.github.io/codea-air-code/>`_ — the VS Code extension's official documentation.
* `Codea CLI on GitHub <https://github.com/twolivesleft/codea-cli>`_ — installation, connection, project-transfer, and automation workflows.
