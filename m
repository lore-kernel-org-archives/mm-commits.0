From: akpm@osdl.org
Subject: + voyager-remove-smp_tune_scheduling-fixme.patch added to -mm tree
Date: Thu, 11 Jan 2007 13:17:34 -0800
Message-ID: <200701112117.l0BLHYaH003273@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35760 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108AbXAKVUv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 16:20:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, James.Bottomley@steeleye.com


The patch titled
     Voyager: remove smp_tune_scheduling() FIXME
has been added to the -mm tree.  Its filename is
     voyager-remove-smp_tune_scheduling-fixme.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Voyager: remove smp_tune_scheduling() FIXME
From: Adrian Bunk <bunk@stusta.de>

smp_tune_scheduling() does no longer do anything that might be required for
Voyager.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/mach-voyager/voyager_smp.c |    4 ----
 1 files changed, 4 deletions(-)

diff -puN arch/i386/mach-voyager/voyager_smp.c~voyager-remove-smp_tune_scheduling-fixme arch/i386/mach-voyager/voyager_smp.c
--- a/arch/i386/mach-voyager/voyager_smp.c~voyager-remove-smp_tune_scheduling-fixme
+++ a/arch/i386/mach-voyager/voyager_smp.c
@@ -709,10 +709,6 @@ smp_boot_cpus(void)
 	 * schedule at the moment */
 	//global_irq_holder = boot_cpu_id;
 
-	/* FIXME: Need to do something about this but currently only works
-	 * on CPUs with a tsc which none of mine have. 
-	smp_tune_scheduling();
-	 */
 	smp_store_cpu_info(boot_cpu_id);
 	printk("CPU%d: ", boot_cpu_id);
 	print_cpu_info(&cpu_data[boot_cpu_id]);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-alsa.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-libata-all.patch
git-mtd.patch
drivers-mtd-ubi-vtblc-make-2-functions-static.patch
git-netdev-all.patch
net-irda-proper-prototypes.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
make-isa_bridge-alpha-only.patch
git-scsi-rc-fixes.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
x86_64-re-add-a-newline-to-restore_context.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
make-hdlc_setup-static-again.patch
voyager-remove-smp_tune_scheduling-fixme.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
net-wanrouter-wanmainc-cleanups.patch
more-ftape-removal.patch
cleanup-linux-byteorder-swabbh.patch
mips-remove-smp_tune_scheduling.patch
