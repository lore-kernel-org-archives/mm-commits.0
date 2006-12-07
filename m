From: akpm@osdl.org
Subject: - make-mm-thrashcglobal_faults-static.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:57:29 -0800
Message-ID: <200612072257.kB7MvTcL029282@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51265 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163711AbWLGXAm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     make mm/thrash.c:global_faults static
has been removed from the -mm tree.  Its filename was
     make-mm-thrashcglobal_faults-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make mm/thrash.c:global_faults static
From: Adrian Bunk <bunk@stusta.de>

This patch makes the needlessly global "global_faults" static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/thrash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/thrash.c~make-mm-thrashcglobal_faults-static mm/thrash.c
--- a/mm/thrash.c~make-mm-thrashcglobal_faults-static
+++ a/mm/thrash.c
@@ -24,7 +24,7 @@
 
 static DEFINE_SPINLOCK(swap_token_lock);
 struct mm_struct *swap_token_mm;
-unsigned int global_faults;
+static unsigned int global_faults;
 
 void grab_swap_token(void)
 {
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
git-alsa.patch
git-dvb.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-mtd-jffs2-userh.patch
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
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
make-ext2_get_blocks-static.patch
generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh.patch
fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh.patch
i4l-remove-the-broken-hisax_amd7930-option.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
make-drivers-md-dm-snapcksnapd-static.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slab-cache-shrinker-statistics.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

