From: akpm@osdl.org
Subject: + arch-i386-kernel-e820c-should-include-asm-setuph.patch added to -mm tree
Date: Thu, 14 Dec 2006 16:55:24 -0800
Message-ID: <200612150055.kBF0tO26002068@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47326 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932592AbWLOA5C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 19:57:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     arch/i386/kernel/e820.c should #include <asm/setup.h
has been added to the -mm tree.  Its filename is
     arch-i386-kernel-e820c-should-include-asm-setuph.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arch/i386/kernel/e820.c should #include <asm/setup.h
From: Adrian Bunk <bunk@stusta.de>

Every file should #include the headers containing the prototypes for
its global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/e820.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/i386/kernel/e820.c~arch-i386-kernel-e820c-should-include-asm-setuph arch/i386/kernel/e820.c
--- a/arch/i386/kernel/e820.c~arch-i386-kernel-e820c-should-include-asm-setuph
+++ a/arch/i386/kernel/e820.c
@@ -14,6 +14,7 @@
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/e820.h>
+#include <asm/setup.h>
 
 #ifdef CONFIG_EFI
 int efi_enabled = 0;
_

Patches currently in -mm which might be from bunk@stusta.de are

make-kernel-printkcignore_loglevel_setup-static.patch
fs-sysv-proper-prototypes-for-2-functions.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
acpi-make-code-static.patch
git-alsa.patch
proper-prototype-for-drivers-base-initcdriver_init.patch
usbvision-possible-cleanups.patch
git-gfs2-nmw.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-the-broken-skmc-driver.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
arch-i386-kernel-e820c-should-include-asm-setuph.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
remove-include-linux-byteorder-pdp_endianh.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
remove-broken-video-drivers-v4.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

