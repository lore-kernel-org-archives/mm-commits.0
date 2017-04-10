From: akpm@linux-foundation.org
Subject: +
 mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages-fix.patch added to -mm tree
Date: Mon, 10 Apr 2017 15:51:04 -0700
Message-ID: <58ec0c58.EzO9q3Hzp5ZErjqF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35944 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751978AbdDJWvF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 18:51:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, jglisse@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages-fix
has been added to the -mm tree.  Its filename is
     mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages-fix.patch

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
Subject: mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages-fix

remove unused local `next', per Fengguang

Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages-fix mm/migrate.c
--- a/mm/migrate.c~mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages-fix
+++ a/mm/migrate.c
@@ -2101,7 +2101,7 @@ static int migrate_vma_collect_hole(unsi
 				    struct mm_walk *walk)
 {
 	struct migrate_vma *migrate = walk->private;
-	unsigned long addr, next;
+	unsigned long addr;
 
 	for (addr = start & PAGE_MASK; addr < end; addr += PAGE_SIZE) {
 		migrate->dst[migrate->npages] = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-page_alloc-re-enable-softirq-use-of-per-cpu-page-allocator-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
docs-vm-transhuge-fix-few-trivial-typos-fix.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

