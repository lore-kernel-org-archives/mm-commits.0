From: akpm@linux-foundation.org
Subject: [merged] mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix.patch removed from -mm tree
Date: Mon, 20 Apr 2009 11:35:35 -0700
Message-ID: <200904201835.n3KIZZxq012409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754170AbZDTSr3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Apr 2009 14:47:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, den@openvz.org, dwmw2@infradead.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix
has been removed from the -mm tree.  Its filename was
     mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Denis V. Lunev <den@openvz.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/mtdcore.c~mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix
+++ a/drivers/mtd/mtdcore.c
@@ -48,7 +48,7 @@ static LIST_HEAD(mtd_notifiers);
  */
 static void mtd_release(struct device *dev)
 {
-	dev_t index = MTD_DEVT(dev_to_mtd(dev));
+	dev_t index = MTD_DEVT(dev_to_mtd(dev)->index);
 
 	/* remove /dev/mtdXro node if needed */
 	if (index)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix.patch
clocksource-pass-clocksource-to-read-callback.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

