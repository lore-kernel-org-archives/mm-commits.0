From: akpm@linux-foundation.org
Subject: + bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch
 added to -mm tree
Date: Thu, 10 Aug 2017 13:53:55 -0700
Message-ID: <598cc7e3.VC4jdq1A62jACDlx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40118 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752890AbdHJUx4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 16:53:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix
has been added to the -mm tree.  Its filename is
     bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch

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
Subject: bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix

Cc: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/bitmap.h~bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix
+++ a/include/linux/bitmap.h
@@ -366,7 +366,7 @@ static inline int bitmap_parse(const cha
  * Linux bitmaps are internally arrays of unsigned longs, i.e. 32-bit
  * integers in 32-bit environment, and 64-bit integers in 64-bit one.
  *
- * There are four combinations of endianess and length of the word in linux
+ * There are four combinations of endianness and length of the word in linux
  * ABIs: LE64, BE64, LE32 and BE32.
  *
  * On 64-bit kernels 64-bit LE and BE numbers are naturally ordered in
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-make-tlb_flush_pending-global-fix.patch
mm-fix-list-corruptions-on-shmem-shrinklist-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
add-testcases-for-memset16-32-64-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

