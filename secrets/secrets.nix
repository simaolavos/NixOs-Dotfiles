let 
	nix-rnl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOlDX6Z/6GI4Gi0nPjGwETQvHTmdJntP91cc9/X+hLBR"
	hosts = [ rnl-simaolavos ];
in {
	"secret1.age".publicKeys = hosts;
}
