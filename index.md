## BlackHoleSecurity Repository

### Read on
 * [English](https://blackholesecurity.github.io/index_en)

### Description
Terima kasih telah berkunjung ke [situs ini](https://blackholesecurity.github.io/) , Ini adalah Official repository dari BlackHoleSecurity.

Repo ini fokus membuat tools/package untuk [Termux](https://termux.net) namun tidak menutup kemungkinan beberapa tools/package dapat di gunakan pada system berbasis debian lainnya.

### Install/Enable
Cara install/enabling repo telah di permudah, pertama pastikan curl sudah terinstall, lewati step ini jika *curl* telah terinstall.

```bash
apt install curl 
```

Jika sudah, lanjut ke tahap berikutnya yaitu mengunduh file repo installer dengan mengetik command :

```bash
curl -L "https://blackholesecurity.github.io/bhs-repo" -o "${PREFIX}/bin/bhs-repo"
```

Pastikan script installer mampunyai hak execute.

```bash
chmod +x "${PREFIX}/bin/bhs-repo"
```

Next ke tahap meng-install dengan mengetik command:

```bash
bhs-repo enable
```


### Uninstall/Disable

Jika suatu saat ingin meng-uninstall repo, bisa mengetik command :

```bash
bhs-repo disable
```

### Contributor


* [Amsit aka Dezavue302](https://amsitlab.github.io/)

* [Are you do?](https://blackholesecurity.github.io/contribute)



