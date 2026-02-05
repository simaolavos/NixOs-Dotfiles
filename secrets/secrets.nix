let 
	rnl-simaolavos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA3jJ34aDHRG8KLbSU/4mhfUblVte4vjBPpcOocWKEkE root@RNL-SimaoLavos";
	hosts = [ rnl-simaolavos ];
in {
	"secret1.age".publicKeys = hosts;
}
