From: akpm@linux-foundation.org
Subject: - memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 20 Oct 2008 17:19:24 -0700
Message-ID: <200810210019.m9L0JOrW019680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134AbYJUATb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 20:19:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch

This patch was dropped because it was folded into memrlimit-add-memrlimit-controller-accounting-and-control.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: need consistent spacing around '<<' (ctx:WxV)
#47: FILE: mm/memrlimitcgroup.c:225:
+				mm->total_vm <<PAGE_SHIFT);
 				             ^

total: 1 errors, 0 warnings, 29 lines checked

./patches/memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com> and
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memrlimitcgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memrlimitcgroup.c~memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes mm/memrlimitcgroup.c
--- a/mm/memrlimitcgroup.c~memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes
+++ a/mm/memrlimitcgroup.c
@@ -222,7 +222,7 @@ static void memrlimit_cgroup_mm_owner_ch
 	if (old_cgrp) {
 		old_memrcg = memrlimit_cgroup_from_cgrp(old_cgrp);
 		res_counter_uncharge(&old_memrcg->as_res,
-				mm->total_vm <<PAGE_SHIFT);
+				mm->total_vm << PAGE_SHIFT);
 	}
 out:
 	mmput(mm);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-git-rejects.patch
git-tests-git-rejects.patch
revert-i7300_idle-driver-v155.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
init-properly-placing-noinline-keyword.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
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

