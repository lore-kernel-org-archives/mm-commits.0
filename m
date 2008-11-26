From: akpm@linux-foundation.org
Subject: - quota-support-64-bit-quota-format-fix-2.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:27:42 -0800
Message-ID: <200811262027.mAQKRg4Q000703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596AbYKZU2Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 15:28:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andrew.perepechko@sun.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota-support-64-bit-quota-format-fix-2
has been removed from the -mm tree.  Its filename was
     quota-support-64-bit-quota-format-fix-2.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota-support-64-bit-quota-format-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andrew Perepechko <andrew.perepechko@sun.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/quota_v2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/quota_v2.c~quota-support-64-bit-quota-format-fix-2 fs/quota_v2.c
--- a/fs/quota_v2.c~quota-support-64-bit-quota-format-fix-2
+++ a/fs/quota_v2.c
@@ -116,8 +116,8 @@ static int v2_read_file_info(struct supe
 		info->dqi_maxblimit = 0xffffffff;
 		info->dqi_maxilimit = 0xffffffff;
 	} else {
-		info->dqi_maxblimit = 0x7fffffffffffffffUL;
-		info->dqi_maxilimit = 0x7fffffffffffffffUL;
+		info->dqi_maxblimit = 0x7fffffffffffffffULL;
+		info->dqi_maxilimit = 0x7fffffffffffffffULL;
 	}
 	info->dqi_bgrace = le32_to_cpu(dinfo.dqi_bgrace);
 	info->dqi_igrace = le32_to_cpu(dinfo.dqi_igrace);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

epoll-introduce-resource-usage-limits.patch
epoll-introduce-resource-usage-limits-update-refix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
input-ad7879-fix-workaroud-build-error-reported-by-andrew-morton.patch
backlight-catch-invalid-input-checkpatch-fixes.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch
vfs-lseekfd-0-seek_cur-race-condition-fix.patch
ntfs-dont-fool-kernel-doc-checkpatch-fixes.patch
bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
netdev-smc911x-fix-for-driver-resume-cleanup.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
quota-cleanup-use-inode-i_blkbits-to-get-block-bits-fix.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
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

