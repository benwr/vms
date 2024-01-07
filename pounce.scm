(use-modules
  (gnu)
  (benwr packages tailscale)
  (benwr services tailscale)
  (benwr services pounce)
  )
(use-service-modules networking ssh)
(use-package-modules certs messaging ssh wget)

(operating-system
  (host-name "pounce")
  (timezone "America/Los_Angeles")
  (locale "en_US.utf8")

  ;; Boot in "legacy" BIOS mode, assuming /dev/sdX is the
  ;; target hard disk, and "my-root" is the label of the target
  ;; root file system.
  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets '("/dev/sdX"))))

  ;; This is used to support the equally bare bones ‘-nographic’
  ;; QEMU option, which also nicely sidesteps forcing QWERTY.
  (kernel-arguments (list "console=ttyS0,115200"))
  (file-systems (cons (file-system
                        (device (file-system-label "my-root"))
                        (mount-point "/")
                        (type "ext4"))
                      %base-file-systems))

  (users %base-user-accounts)

  (packages (cons* pounce tailscale nss-certs %base-packages))

  (services (append (list (service dhcp-client-service-type)
			  (service ntp-service-type)
                          (service openssh-service-type
				   (openssh-configuration
				     (openssh openssh-sans-x)
				     (port-number 2222)))
			  (service tailscaled-service-type (tailscaled-configuration (state-file "/var/lib/tailscale/tailscaled.state")))
			  (service pounce-service-type `("oftc" "libera" "tilde"))
			  )
                    %base-services)))
