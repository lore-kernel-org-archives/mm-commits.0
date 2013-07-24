From: akpm@linux-foundation.org
Subject: + swap-make-swap-discard-async-checkpatch-fixes.patch added to
 -mm tree
Date: Wed, 24 Jul 2013 14:37:49 -0700
Message-ID: <51f0492d.Zyssg73YRhD3WJGt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3GXVhu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 17:37:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shli@kernel.org, akpm@linux-foundation.org

Subject: + swap-make-swap-discard-async-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,shli@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 14:37:49 -0700


The patch titled
     Subject: swap-make-swap-discard-async-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     swap-make-swap-discard-async-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swap-make-swap-discard-async-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swap-make-swap-discard-async-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: swap-make-swap-discard-async-checkpatch-fixes

WARNING: line over 80 characters
#81: FILE: include/linux/swap.h:243:
+	struct swap_cluster_info discard_cluster_head; /* list head of discard clusters */

WARNING: line over 80 characters
#82: FILE: include/linux/swap.h:244:
+	struct swap_cluster_info discard_cluster_tail; /* list tail of discard clusters */

ERROR: space prohibited before that '--' (ctx:WxO)
#255: FILE: mm/swapfile.c:449:
+				si->cluster_nr --;
 				               ^

total: 1 errors, 2 warnings, 310 lines checked

./patches/swap-make-swap-discard-async.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swapfile.c~swap-make-swap-discard-async-checkpatch-fixes mm/swapfile.c
--- a/mm/swapfile.c~swap-make-swap-discard-async-checkpatch-fixes
+++ a/mm/swapfile.c
@@ -446,7 +446,7 @@ check_cluster:
 				scan_base = offset = si->cluster_next;
 				if (!si->cluster_nr)
 					goto check_cluster;
-				si->cluster_nr --;
+				si->cluster_nr--;
 				goto checks;
 			}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch
arch-x86-platform-ce4100-ce4100c-include-rebooth.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined-checkpatch-fixes.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

