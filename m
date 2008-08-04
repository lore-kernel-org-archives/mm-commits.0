From: akpm@linux-foundation.org
Subject: + drivers-media-video-gspca-zc3xxc-fix-oops-checkpatch-fixes.patch added to -mm tree
Date: Mon, 04 Aug 2008 16:12:45 -0700
Message-ID: <200808042312.m74NCj9j004706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755416AbYHDXNF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 19:13:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mchehab@infradead.org, parag.warudkar@gmail.com


The patch titled
     drivers-media-video-gspca-zc3xxc-fix-oops-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     drivers-media-video-gspca-zc3xxc-fix-oops-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-media-video-gspca-zc3xxc-fix-oops-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space required before the open parenthesis '('
#61: FILE: drivers/media/video/gspca/zc3xx.c:6479:
+	if(!Tgamma)

total: 1 errors, 0 warnings, 25 lines checked

./patches/drivers-media-video-gspca-zc3xxc-fix-oops.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Parag Warudkar" <parag.warudkar@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Parag Warudkar <parag.warudkar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/gspca/zc3xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/gspca/zc3xx.c~drivers-media-video-gspca-zc3xxc-fix-oops-checkpatch-fixes drivers/media/video/gspca/zc3xx.c
--- a/drivers/media/video/gspca/zc3xx.c~drivers-media-video-gspca-zc3xxc-fix-oops-checkpatch-fixes
+++ a/drivers/media/video/gspca/zc3xx.c
@@ -6476,7 +6476,7 @@ static void setcontrast(struct gspca_dev
 	Tgamma = gamma_tb[sd->gamma];
 	Tgradient = gradient_tb[sd->gamma];
 
-	if(!Tgamma)
+	if (!Tgamma)
 		k = 0;
 	else
 		k = (sd->contrast - 128)		/* -128 / 128 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm_initc-avoid-ifdef-inside-macro-expansion.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
drivers-media-video-vinoc-needs-v4l2-ioctlh.patch
drivers-media-video-gspca-zc3xxc-fix-oops-checkpatch-fixes.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
sched-type-fix.patch
scsi-gdthc-use-unaligned-access-helpers.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
usb-hubc-fix-build-with-config_pm=n.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
hwmon-adc124s501-generic-driver.patch
drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
devpts-switch-to-ida-checkpatch-fixes.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

