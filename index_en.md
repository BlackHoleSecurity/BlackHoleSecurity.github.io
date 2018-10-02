## BlackHoleSecurity Repository

### Read on
 * [Id](https://blackholesecurity.github.io/)

### Description
Thanks already visited [this site](https://blackholesecurity.github.io/) , this is Official repository from BlackHoleSecurity.

This repo focuses on creating tools/packages for [Termux](https://termux.net) but does not rule out some tools/packages can be used on other deb-based systems.

### Install/Enable
How to install/enabling repo has been made easy, first make sure the *curl* is installed, skip this step if *curl* already installed.


```bash
apt install curl 
```

If you have, go to the next step is to download the installer repo file by typing the command:

```bash
curl -L "https://blackholesecurity.github.io/bhs-repo" -o "${PREFIX}/bin/bhs-repo"
```

Make sure the installer script has executable

```bash
chmod +x "${PREFIX}/bin/bhs-repo"
```

Next to the install stage by typing the command:

```bash
bhs-repo enable
```


### Uninstall/Disable

If at any time want to uninstall repo, can type command:

```bash
bhs-repo disable
```

### Contributor


* [Amsit aka Dezavue302](https://amsitlab.github.io/)

* [Are you do?](https://blackholesecurity.github.io/contribute_en)



