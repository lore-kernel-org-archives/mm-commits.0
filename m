From: akpm@linux-foundation.org
Subject: - epoll-introduce-resource-usage-limits-update-refix.patch removed from -mm tree
Date: Mon, 01 Dec 2008 13:09:53 -0800
Message-ID: <200812012125.mB1LPTut014236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbYLAVZm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 16:25:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davidel@xmailserver.org, gorcunov@gmail.com, mtk.manpages@gmail.com, stable@kernel.org, vegardno@ifi.uio.no, mm-commits@vger.kernel.org


The patch titled
     epoll-introduce-resource-usage-limits-update-refix
has been removed from the -mm tree.  Its filename was
     epoll-introduce-resource-usage-limits-update-refix.patch

This patch was dropped because it was folded into epoll-introduce-resource-usage-limits.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll-introduce-resource-usage-limits-update-refix
From: Andrew Morton <akpm@linux-foundation.org>

gargh.

Cc: <stable@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Vegard Nossum <vegardno@ifi.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/eventpoll.c~epoll-introduce-resource-usage-limits-update-refix fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-introduce-resource-usage-limits-update-refix
+++ a/fs/eventpoll.c
@@ -580,7 +580,7 @@ static int ep_alloc(struct eventpoll **p
 	struct user_struct *user;
 	struct eventpoll *ep;
 
-	user = get_uid(current->user);
+	user = get_current_user();
 	error = -EMFILE;
 	if (unlikely(atomic_read(&user->epoll_devs) >=
 			max_user_instances))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
epoll-introduce-resource-usage-limits.patch
epoll-introduce-resource-usage-limits-update-refix.patch
ksym_symbol_len-fixes-fix.patch
vfs-lseekfd-0-seek_cur-race-condition-fix.patch
ntfs-dont-fool-kernel-doc-checkpatch-fixes.patch
drivers-gpu-drm-i915-i915_irqc-fix-warning.patch
mm-remove-the-might_sleep-from-lock_page.patch
make-linx-next-apply.patch
linux-next.patch
next-remove-localversion.patch
drivers-hwmon-f71882fgc-make-dev_attr_name-static.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
input-ad7879-fix-workaroud-build-error-reported-by-andrew-morton.patch
backlight-catch-invalid-input-checkpatch-fixes.patch
backlight-catch-invalid-input-fix.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch
bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
netdev-smc911x-fix-for-driver-resume-cleanup.patch
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

