From: akpm@linux-foundation.org
Subject: - usb-remove-makefile-reference-to-obsolete-ohci_at91.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:33:43 -0700
Message-ID: <200707132233.l6DMXh1L025102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937339AbXGMWpF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:45:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     USB: remove Makefile reference to obsolete OHCI_AT91
has been removed from the -mm tree.  Its filename was
     usb-remove-makefile-reference-to-obsolete-ohci_at91.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: USB: remove Makefile reference to obsolete OHCI_AT91
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/Makefile |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/usb/Makefile~usb-remove-makefile-reference-to-obsolete-ohci_at91 drivers/usb/Makefile
--- a/drivers/usb/Makefile~usb-remove-makefile-reference-to-obsolete-ohci_at91
+++ a/drivers/usb/Makefile
@@ -15,7 +15,6 @@ obj-$(CONFIG_USB_OHCI_HCD)	+= host/
 obj-$(CONFIG_USB_UHCI_HCD)	+= host/
 obj-$(CONFIG_USB_SL811_HCD)	+= host/
 obj-$(CONFIG_USB_U132_HCD)	+= host/
-obj-$(CONFIG_USB_OHCI_AT91)	+= host/
 obj-$(CONFIG_USB_R8A66597_HCD)	+= host/
 
 obj-$(CONFIG_USB_ACM)		+= class/
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-powerpc.patch
git-dvb.patch
git-kbuild.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-sh.patch
git-scsi-misc.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
mm-make-needlessly-global-hugetlb_no_page-static.patch
frv-be-self-consistent-and-use-config_gdb_console-everywhere.patch
frv-remove-some-dead-code.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
remove-apparently-useless-commented-apm_get_battery_status.patch
cobalt-remove-all-references-to-cobalt-nvram.patch
remove-final-two-references-to-__obsolete_setup-macro.patch
cdrom-replace-hard-coded-constants-by-kernelh-macro.patch
nls-remove-obsolete-makefile-entries.patch
