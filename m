From: akpm@linux-foundation.org
Subject: - drivers-char-drm-drm_mmc-remove-unused-exports.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:19:49 -0800
Message-ID: <200702100519.l1A5Josb004426@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36633 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbXBJFXU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:23:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drivers/char/drm/drm_mm.c: remove unused exports
has been removed from the -mm tree.  Its filename was
     drivers-char-drm-drm_mmc-remove-unused-exports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/char/drm/drm_mm.c: remove unused exports
From: Adrian Bunk <bunk@stusta.de>

This patch removes two unused exports.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/drm_mm.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/char/drm/drm_mm.c~drivers-char-drm-drm_mmc-remove-unused-exports drivers/char/drm/drm_mm.c
--- a/drivers/char/drm/drm_mm.c~drivers-char-drm-drm_mmc-remove-unused-exports
+++ a/drivers/char/drm/drm_mm.c
@@ -274,8 +274,6 @@ int drm_mm_init(drm_mm_t * mm, unsigned 
 	return drm_mm_create_tail_node(mm, start, size);
 }
 
-EXPORT_SYMBOL(drm_mm_init);
-
 void drm_mm_takedown(drm_mm_t * mm)
 {
 	struct list_head *bnode = mm->fl_entry.next;
@@ -294,5 +292,3 @@ void drm_mm_takedown(drm_mm_t * mm)
 
 	drm_free(entry, sizeof(*entry), DRM_MEM_MM);
 }
-
-EXPORT_SYMBOL(drm_mm_takedown);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
ifdef-acpi_future_usage-acpi_os_readable.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
git-libata-all.patch
mips-remove-smp_tune_scheduling.patch
git-mtd.patch
git-ubi.patch
net-uninline-skb_put-fix.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
git-unionfs.patch
usb_rtl8150-must-select-mii.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
cleanup-linux-byteorder-swabbh.patch
cleanup-include-linux-xattrh.patch
cleanup-include-linux-reiserfs_xattrh.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
debug-shared-irqs-kconfig-fix.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i383-drivers.patch
add-debugging-feature-proc-timer_stat-cleanup.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
drivers-isdn-sc-proper-prototypes.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
proper-prototype-for-tosh_smm.patch
remove-the-broken-fb_s3trio-driver.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
sysctl-reimplement-the-sysctl-proc-support-fix-3.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
