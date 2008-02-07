From: akpm@linux-foundation.org
Subject: - geode-lists-are-subscriber-only.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:20:24 -0800
Message-ID: <200802070020.m170K52M006090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41767 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933909AbYBGAUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:20:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     geode lists are subscriber only
has been removed from the -mm tree.  Its filename was
     geode-lists-are-subscriber-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: geode lists are subscriber only
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This gave me bounces and moans when chasing CS5536 so document it.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~geode-lists-are-subscriber-only MAINTAINERS
--- a/MAINTAINERS~geode-lists-are-subscriber-only
+++ a/MAINTAINERS
@@ -338,13 +338,12 @@ S:	Maintained for 2.4; PCI support for 2
 AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
 P:	Thomas Dahlmann
 M:	thomas.dahlmann@amd.com
-L:	info-linux@geode.amd.com
+L:	info-linux@geode.amd.com	(subscribers-only)
 S:	Supported
 
 AMD GEODE PROCESSOR/CHIPSET SUPPORT
 P:	Jordan Crouse
-M:	info-linux@geode.amd.com
-L:	info-linux@geode.amd.com
+L:	info-linux@geode.amd.com	(subscribers-only)
 W:	http://www.amd.com/us-en/ConnectivitySolutions/TechnicalResources/0,,50_2334_2452_11363,00.html
 S:	Supported
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-acpi.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
git-watchdog.patch
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
char-mxser-ioctl-cleanup.patch
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
smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
irq_noprobe-helper-functions.patch
mips-mark-all-but-i8259-interrupts-as-no-probe.patch
