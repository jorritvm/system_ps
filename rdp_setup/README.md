# RDP without warnings
## Storing Credentials on the windows client

To avoid repeated credential prompts and warnings when connecting via Remote Desktop Protocol (RDP), it is best to store your credentials securely on the client machine using Windows Credential Manager. This is especially important when connecting to servers running the Terminal Services (termserv) role, as these often require explicit credential storage for seamless logins.

**How to add a credential for the server user:**
1. Open **Credential Manager** (search for it in the Start menu).
2. Select **Windows Credentials**.
3. Click **Add a Windows credential**.
4. For the network address, you must enter it in the format `TERMSRV/server.lan` (replace `server.lan` with the actual DNS name of your server). For example, if your machine is called SERVER and its DNS name is `server.lan`, enter `TERMSRV/server.lan`.
5. For the username, enter the server user in the format `SERVER\jorrit` (replace with your actual server and username).
6. Enter the password for the user.
7. Click **OK** to save.

This will allow Windows to automatically use these credentials when connecting to the specified server.

## RDP File Settings

When using an `.rdp` file to connect, ensure the following:

1. Open the `.rdp` file in a text editor or via the Remote Desktop client.
2. Uncheck **"Always ask for credentials"** in the RDP options (under the Experience or Advanced tab, depending on your version).
3. After making changes, **do not forget to SAVE the `.rdp` file**.

This ensures that the stored credentials are used and you are not prompted every time you connect.

## Problems with RDP files

Recent Windows 11 builds display warnings when you open .rdp files that are unsigned or downloaded from the internet.  
This is a security feature to help prevent malicious remote desktop connections. Unsigned .rdp files may trigger a warning dialog about the file's origin or authenticity. 

## Options That Are Not Desired

Several approaches to suppressing RDP warnings are not recommended or effective:

- **Moving the server certificate to the client:** This approach did not work in practice.
- **Self-signing the .rdp file as admin:** This is possible but requires significant effort and is not practical for most users.
- **Modifying the NLA policy on the server:** Changing Network Level Authentication (NLA) settings does not affect this warning behavior.
- **Checking 'connect without warning' in the RDP file config:** This setting does not resolve the warning in recent Windows 11 builds.

## Workaround: PowerShell Script

As a workaround, you can start an RDP session directly from a PowerShell prompt using the following command:

	mstsc /v:server.lan /w:1920 /h:1080

This will launch a Remote Desktop session to `server.lan` with a window size of 1920x1080. The session will use the default credentials stored in Windows Credential Manager for the specified server, if available.

This repository contains a PowerShell script to make this process easier and more repeatable.

## Required: Modify Execution Policy

To run the provided PowerShell script, you must allow script execution for your user account. Run the following command in a PowerShell prompt:

	Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

This enables running local scripts that you have written or downloaded.
