From: akpm@osdl.org
Subject: + cpu_freq_table-shouldnt-be-a-def_tristate.patch added to -mm tree
Date: Thu, 11 Jan 2007 13:17:28 -0800
Message-ID: <200701112117.l0BLHSh3003264@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35747 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066AbXAKVUq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 16:20:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, davej@codemonkey.org.uk


The patch titled
     CPU_FREQ_TABLE shouldn't be a def_tristate
has been added to the -mm tree.  Its filename is
     cpu_freq_table-shouldnt-be-a-def_tristate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CPU_FREQ_TABLE shouldn't be a def_tristate
From: Adrian Bunk <bunk@stusta.de>

CPU_FREQ_TABLE enables helper code and gets select'ed when it's required.

Building it as a module when it's not required doesn't seem to make much
sense.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/cpufreq/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpufreq/Kconfig~cpu_freq_table-shouldnt-be-a-def_tristate drivers/cpufreq/Kconfig
--- a/drivers/cpufreq/Kconfig~cpu_freq_table-shouldnt-be-a-def_tristate
+++ a/drivers/cpufreq/Kconfig
@@ -16,7 +16,7 @@ config CPU_FREQ
 if CPU_FREQ
 
 config CPU_FREQ_TABLE
-       def_tristate m
+       tristate
 
 config CPU_FREQ_DEBUG
 	bool "Enable CPUfreq debugging"
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
