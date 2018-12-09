# Docker Workshop by Michał Wójtowicz

## Initial steps

1. [Create your Docker ID](#create-your-docker-id)
2. [Download Docker to your development machine](#download-docker-to-your-development-machine)
3. [Hyper-V and Virtualbox warning](#hyper-v-and-virtualbox-warning)
4. [Verification](#verification)

### Create your Docker ID

1. Visit page https://store.docker.com/signup, follow all steps
   required to create an account.
2. Verify login on page https://hub.docker.com/

### Download Docker to your development machine

This instruction covers Windows only. To download Docker on other platforms
follow steps described on https://www.docker.com/community-edition#/download

1. Visit page https://store.docker.com/editions/community/docker-ce-desktop-windows
   (you have to be logged in)
2. Click `Get Docker` button
3. Install Docker for Windows with default settings (follow any suggested restart)
4. Open Docker for Windows from Start menu - you should be able to see whale icon
   in systray. Click on it.
5. In popup window you have to use your Docker credentials.
   It's necessary to use Docker hub images.

### Hyper-V and Virtualbox warning

Docker for Windows requires Hyper-V enabled. Docker installer enables it during
installation process.
That makes any other hypervisor (Virtualbox, VMware, etc) not able to work.
You can't use Virtualbox and Hyper-V machines at the same time.

However there is a way to run Docker **or** Virtualbox machines.
Open command prompt with administrator rights and run this command to turn off Hyper-V:
```
bcdedit /set hypervisorlaunchtype off
```
Next - restart your PC. Now you'll be able to use Virtualbox machines.

If you would like to use Docker for Windows again, run command (and restart PC):

```
bcdedit /set hypervisorlaunchtype auto
```

If you need to run Virtualbox machines with Docker simultaneously,
I recommend to create a new VM in Virtualbox which would manage your Docker stuff.
Follow installation instructions [from Docker guide](https://www.docker.com/community-edition#/download)
depending on platform of your choice.

### Verification

> Note
>
> If you're Windows user, I suggest to use Git-Bash as a terminal during these exercises.
Git-Bash is part of standard Git package delivered for Windows system.
If you're using git, I'm almost sure you have it. Otherwise visit git-scm.com to download full package.

Open command line and type command: `docker --version`.
You should be able to see something like this:

```
Docker version 18.03.0-ce, build 0520e24
```

Try also to run a container: `docker run hello-world`
It should pull image from Docker hub. The last line of the output should say:

> Hello from Docker!
This message shows that your installation appears to be working correctly.

Please also run script `verification.sh` from this repository.
It will check if you meet requirements, also it prepares your workstation before workshop time.

### Troubleshooting

If you're Windows user, you are probably going to have some issues related to file sharing.
Verification script will point it as `File sharing verification - failed`.
You may need to click `Reset credentials` on `Shared Drives` tab in Docker settings (see the image below)

![https://msdnshared.blob.core.windows.net/media/2016/06/d4w-shared-drives.png](https://msdnshared.blob.core.windows.net/media/2016/06/d4w-shared-drives.png)

You may also need to create a special Docker user if you work in multiple domains.
Please read & follow steps described in this article to solve the issue:
https://blogs.msdn.microsoft.com/stevelasker/2016/06/14/configuring-docker-for-windows-volumes/

Sometimes also your firewall may block file sharing.
Docker will point it out as a popup message, with a link to documentation describing how to solve it.
