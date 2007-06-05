From: akpm@linux-foundation.org
Subject: + update-feature-removal-scheduletxt-to-include-deprecated-functions.patch added to -mm tree
Date: Mon, 04 Jun 2007 20:39:21 -0700
Message-ID: <200706050339.l553dJkU028514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47523 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757657AbXFEDj7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 23:39:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     update feature-removal-schedule.txt to include deprecated functions
has been added to the -mm tree.  Its filename is
     update-feature-removal-scheduletxt-to-include-deprecated-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update feature-removal-schedule.txt to include deprecated functions
From: Andy Whitcroft <apw@shadowen.org>

Now that deprecated functions are detected out of
Documentation/feature-removal-schedule.txt update this to include
kernel_thread.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    1 +
 1 file changed, 1 insertion(+)

diff -puN Documentation/feature-removal-schedule.txt~update-feature-removal-scheduletxt-to-include-deprecated-functions Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~update-feature-removal-scheduletxt-to-include-deprecated-functions
+++ a/Documentation/feature-removal-schedule.txt
@@ -104,6 +104,7 @@ Who:	Dominik Brodowski <linux@brodo.de>
 What:	remove EXPORT_SYMBOL(kernel_thread)
 When:	August 2006
 Files:	arch/*/kernel/*_ksyms.c
+Funcs:	kernel_thread
 Why:	kernel_thread is a low-level implementation detail.  Drivers should
         use the <linux/kthread.h> API instead which shields them from
 	implementation details and provides a higherlevel interface that
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
update-checkpatchpl-to-version-003.patch
update-feature-removal-scheduletxt-to-include-deprecated-functions.patch
move-three-functions-that-are-only-needed-for.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
remove-alloc_zeroed_user_highpage.patch
create-the-zone_movable-zone.patch
handle-kernelcore=-generic.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
update-page-order-at-an-appropriate-time-when-tracking-page_owner.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
