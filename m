From: akpm@linux-foundation.org
Subject: - backlight-catch-invalid-input-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 01 Dec 2008 14:25:05 -0800
Message-ID: <200812012225.mB1MP6gp015446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756AbYLAWZT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 17:25:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, pavel@suse.cz, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     backlight-catch-invalid-input-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     backlight-catch-invalid-input-checkpatch-fixes.patch

This patch was dropped because it was folded into backlight-catch-invalid-input.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight-catch-invalid-input-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#56: FILE: drivers/video/backlight/backlight.c:122:
+ ^Irc = strict_strtoul(buf, 0, &brightness);$

total: 1 errors, 0 warnings, 57 lines checked

./patches/backlight-catch-invalid-input.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Pavel Machek <pavel@suse.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/backlight.c~backlight-catch-invalid-input-checkpatch-fixes drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-catch-invalid-input-checkpatch-fixes
+++ a/drivers/video/backlight/backlight.c
@@ -119,7 +119,7 @@ static ssize_t backlight_store_brightnes
 	struct backlight_device *bd = to_backlight_device(dev);
 	unsigned long brightness;
 
- 	rc = strict_strtoul(buf, 0, &brightness);
+	rc = strict_strtoul(buf, 0, &brightness);
 	if (rc)
 		return rc;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
epoll-introduce-resource-usage-limits.patch
ntfs-dont-fool-kernel-doc.patch
drivers-gpu-drm-i915-i915_irqc-fix-warning.patch
ksym_symbol_len-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
make-linx-next-apply.patch
linux-next.patch
next-remove-localversion.patch
drivers-hwmon-f71882fgc-make-dev_attr_name-static.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
netdev-smc911x-fix-for-driver-resume-cleanup.patch
backlight-catch-invalid-input.patch
backlight-catch-invalid-input-checkpatch-fixes.patch
backlight-catch-invalid-input-fix.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch
bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
linuxpps-core-support-drivers-pps-sysfsc-make-dev_attr_name-static.patch
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
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

