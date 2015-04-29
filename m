From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd-fix.patch removed from -mm tree
Date: Wed, 29 Apr 2015 13:36:52 -0700
Message-ID: <554140e4.V4kQZNM5kPtRJ9c3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbbD2Ugw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 16:36:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd-fix
has been removed from the -mm tree.  Its filename was
     mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd-fix

remove extraneous newline

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/page_alloc.c~mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd-fix
+++ a/mm/page_alloc.c
@@ -1061,7 +1061,6 @@ void __defermem_init deferred_init_memma
 {
 	unsigned long start = jiffies;
 	struct mminit_pfnnid_cache nid_init_state = { };
-
 	pg_data_t *pgdat = NODE_DATA(nid);
 	int zid;
 	unsigned long first_init_pfn = pgdat->first_deferred_pfn;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
maintainers-add-co-maintainer-for-led-subsystem.patch
revert-fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

