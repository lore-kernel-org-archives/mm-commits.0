From: akpm@linux-foundation.org
Subject: + cma-page_isolation-check-buddy-before-access-it-fix.patch added to -mm tree
Date: Wed, 06 May 2015 15:38:03 -0700
Message-ID: <554a97cb.MBNTbY3GoFtby1A5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbbEFWiE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 18:38:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, zhuhui@xiaomi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cma-page_isolation-check-buddy-before-access-it-fix
has been added to the -mm tree.  Its filename is
     cma-page_isolation-check-buddy-before-access-it-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cma-page_isolation-check-buddy-before-access-it-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cma-page_isolation-check-buddy-before-access-it-fix.patch

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
cma-page_isolation-check-buddy-before-access-it-fix.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

