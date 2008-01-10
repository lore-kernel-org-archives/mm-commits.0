From: akpm@linux-foundation.org
Subject: + acpi-its-a-directory-not-a-folder.patch added to -mm tree
Date: Wed, 09 Jan 2008 22:27:52 -0800
Message-ID: <200801100627.m0A6RWIs008831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48916 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919AbYAJG2e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 01:28:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, lenb@kernel.org


The patch titled
     acpi: it's a directory not a folder
has been added to the -mm tree.  Its filename is
     acpi-its-a-directory-not-a-folder.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: it's a directory not a folder
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Noticed this while fixing some other stuff.  The kernel help consistently
uses 'directory', except for ACPI.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/Kconfig |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/acpi/Kconfig~acpi-its-a-directory-not-a-folder drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~acpi-its-a-directory-not-a-folder
+++ a/drivers/acpi/Kconfig
@@ -68,20 +68,20 @@ config ACPI_PROCFS
 
 	  Say N to delete /proc/acpi/ files that have moved to /sys/
 config ACPI_PROCFS_POWER
-	bool "Deprecated power /proc/acpi folders"
+	bool "Deprecated power /proc/acpi directories"
 	depends on PROC_FS
 	default y
 	---help---
 	  For backwards compatibility, this option allows
-          deprecated power /proc/acpi/ folders to exist, even when
+          deprecated power /proc/acpi/ directories to exist, even when
           they have been replaced by functions in /sys.
-          The deprecated folders (and their replacements) include:
+          The deprecated directories (and their replacements) include:
 	  /proc/acpi/battery/* (/sys/class/power_supply/*)
 	  /proc/acpi/ac_adapter/* (sys/class/power_supply/*)
-	  This option has no effect on /proc/acpi/ folders
+	  This option has no effect on /proc/acpi/ directories
 	  and functions, which do not yet exist in /sys
 
-	  Say N to delete power /proc/acpi/ folders that have moved to /sys/
+	  Say N to delete power /proc/acpi/ directories that have moved to /sys/
 config ACPI_SYSFS_POWER
 	bool "Future power /sys interface"
 	select POWER_SUPPLY
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

pl2303-fix-mode-switching-regression.patch
pl2303-fix-mode-switching-regression-fix.patch
acpi-its-a-directory-not-a-folder.patch
git-arm.patch
git-libata-all.patch
git-libata-all-fix-pata_winbond-borkage.patch
git-libata-all-wtf.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
pata_pdc202xx_old-further-fixups.patch
pata_legacy-resychronize-with-upstream-changes-and-resubmit.patch
git-netdev-all.patch
bluetooth-rfcomm-tty_close-before-destruct.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250c-support-specifying-dw-apb-uarts-in-device-platform_data.patch
avoid-waking-up-closed-serial-ports-on-resume.patch
serial-avoid-stalling-suspend-if-serial-port-wont-drain.patch
serial-speed-setup-failure-reporting.patch
serial-coding-style.patch
ti_usb-termios-cleanups.patch
mos7720-clean-up-termios.patch
io_ti-clean-up-termios-handling.patch
wdt-fix-locking.patch
wdt-fix-locking-checkpatch-fixes.patch
libata-sff-pci-irq-handling-fix.patch
libata-correct-handling-of-tss-dvd.patch
keyspan-fix-oops.patch
geode-lists-are-subscriber-only.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
documentation-about-unaligned-memory-access.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
moxa-first-pass-at-termios-reporting.patch
n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch.patch
rocket-first-pass-at-termios-reporting.patch
rocket-dont-let-random-users-reset-the-controller.patch
tty_audit-fix-checkpatch-complaint.patch
tty_io-drag-screaming-into-coding-style-compliance.patch
tty_ioctl-drag-screaming-into-compliance-with-the-coding.patch
8250_early-coding-style.patch
8250_gsc-coding-style.patch
8250_hp300-coding-style.patch
8250_hub6-codding-style.patch
8250_pci-coding-style.patch
serial8250-coding-style.patch
8250-enable-rate-reporting-via-termios.patch
serial_core-bring-mostly-into-line-with-coding-style.patch
