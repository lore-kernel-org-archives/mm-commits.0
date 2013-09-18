From: akpm@linux-foundation.org
Subject: [merged]
 drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch
 removed from -mm tree
Date: Wed, 18 Sep 2013 13:02:23 -0700
Message-ID: <523a06cf.9wH0JuPAryXdokhQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab3IRUCZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 16:02:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tao.peng@emc.com, gregkh@linuxfoundation.org, andreas.dilger@intel.com, akpm@linux-foundation.org

Subject: [merged] drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch removed from -mm tree
To: akpm@linux-foundation.org,andreas.dilger@intel.com,gregkh@linuxfoundation.org,tao.peng@emc.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 13:02:23 -0700


The patch titled
     Subject: drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c: rename PTRS_PER_PAGE
has been removed from the -mm tree.  Its filename was
     drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c: rename PTRS_PER_PAGE

It duplicates the definition in arch/alpha/include/asm/pgtable.h and emits
warnings.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c~drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c~drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page
+++ a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
@@ -59,8 +59,8 @@
  ****************************************/
 
 
-#define PTRS_PER_PAGE   (PAGE_CACHE_SIZE / sizeof(void *))
-#define PAGES_PER_POOL  (PTRS_PER_PAGE)
+#define POINTERS_PER_PAGE	(PAGE_CACHE_SIZE / sizeof(void *))
+#define PAGES_PER_POOL		(POINTERS_PER_PAGE)
 
 #define IDLE_IDX_MAX	    (100)
 #define IDLE_IDX_WEIGHT	 (3)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

