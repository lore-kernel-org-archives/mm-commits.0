From: akpm@linux-foundation.org
Subject: [to-be-updated]
 cma-page_isolation-check-buddy-before-access-it-fix.patch removed from -mm
 tree
Date: Fri, 08 May 2015 15:51:01 -0700
Message-ID: <554d3dd5.gYwT1vPm33bLX5Sa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbbEHWvC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 May 2015 18:51:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, zhuhui@xiaomi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cma-page_isolation-check-buddy-before-access-it-fix
has been removed from the -mm tree.  Its filename was
     cma-page_isolation-check-buddy-before-access-it-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: cma-page_isolation-check-buddy-before-access-it-fix

use conventional coding style

Cc: Hui Zhu <zhuhui@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_isolation.c~cma-page_isolation-check-buddy-before-access-it-fix mm/page_isolation.c
--- a/mm/page_isolation.c~cma-page_isolation-check-buddy-before-access-it-fix
+++ a/mm/page_isolation.c
@@ -101,8 +101,8 @@ void unset_migratetype_isolate(struct pa
 			buddy_idx = __find_buddy_index(page_idx, order);
 			buddy = page + (buddy_idx - page_idx);
 
-			if (!pfn_valid_within(page_to_pfn(buddy))
-			    || !is_migrate_isolate_page(buddy)) {
+			if (!pfn_valid_within(page_to_pfn(buddy)) ||
+			    !is_migrate_isolate_page(buddy)) {
 				__isolate_free_page(page, order);
 				kernel_map_pages(page, (1 << order), 1);
 				set_page_refcounted(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-rtc-rtc-armada38xc-remove-unused-local-flags.patch
gfp-add-__gfp_noaccount-v2-fix.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
linux-next.patch
linux-next-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

