From: akpm@linux-foundation.org
Subject: - cx88-videoc-remove-struct-radionorms.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:51:31 -0800
Message-ID: <200702071951.l17JpVkA025163@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33822 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161373AbXBGTyu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:54:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     cx88-video.c: remove struct radionorms
has been removed from the -mm tree.  Its filename was
     cx88-videoc-remove-struct-radionorms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cx88-video.c: remove struct radionorms
From: Adrian Bunk <bunk@stusta.de>

This patch removes the unused struct radionorms.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx88/cx88-video.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/media/video/cx88/cx88-video.c~cx88-videoc-remove-struct-radionorms drivers/media/video/cx88/cx88-video.c
--- a/drivers/media/video/cx88/cx88-video.c~cx88-videoc-remove-struct-radionorms
+++ a/drivers/media/video/cx88/cx88-video.c
@@ -86,8 +86,6 @@ static LIST_HEAD(cx8800_devlist);
 /* ------------------------------------------------------------------- */
 /* static data                                                         */
 
-v4l2_std_id radionorms[] = { 0 };
-
 static struct cx8800_fmt formats[] = {
 	{
 		.name     = "8 bpp, gray",
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
v9fs_vfs_mkdir-fix-a-double-free.patch
git-acpi.patch
ifdef-acpi_future_usage-acpi_os_readable.patch
git-alsa.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
git-powerpc.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
git-dvb.patch
git-ieee1394.patch
git-libata-all.patch
mips-remove-smp_tune_scheduling.patch
mtd_ck804xrom-must-depend-on-pci.patch
git-ubi.patch
git-netdev-all.patch
net-wanrouter-wanmainc-cleanups.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
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
cleanup-x86_64-mm-vmi-timer.patch
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
