From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch removed from -mm tree
Date: Wed, 31 Jul 2013 13:47:51 -0700
Message-ID: <51f977f7.J43/psOp2dqOAcBy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760672Ab3GaUrx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jul 2013 16:47:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, guz.fnst@cn.fujitsu.com, akpm@linux-foundation.org

Subject: [folded-merged] ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,guz.fnst@cn.fujitsu.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 31 Jul 2013 13:47:51 -0700


The patch titled
     Subject: ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch

This patch was dropped because it was folded into ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix

fix layout, per Joel

Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/refcounttree.c~ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix
+++ a/fs/ocfs2/refcounttree.c
@@ -2970,6 +2970,7 @@ int ocfs2_duplicate_clusters_by_page(han
 			mlog_errno(ret);
 			break;
 		}
+
 		/*
 		 * In case PAGE_CACHE_SIZE <= CLUSTER_SIZE, This page
 		 * can't be dirtied before we CoW it out.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page.patch
arch-x86-platform-ce4100-ce4100c-include-rebooth.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined-checkpatch-fixes.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
memcg-trivial-cleanups.patch
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

