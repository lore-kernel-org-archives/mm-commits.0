From: akpm@linux-foundation.org
Subject: [folded] page-types-add-feature-for-walking-process-address-space-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:27:50 -0700
Message-ID: <200909232227.n8NMRolT013963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397AbZIWW1s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:27:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     page-types-add-feature-for-walking-process-address-space-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     page-types-add-feature-for-walking-process-address-space-checkpatch-fixes.patch

This patch was dropped because it was folded into page-types-add-feature-for-walking-process-address-space.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-types-add-feature-for-walking-process-address-space-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: spaces required around that ':' (ctx:VxW)
#98: FILE: Documentation/vm/page-types.c:193:
+	__max1 > __max2 ? __max1: __max2; })
 	                        ^

total: 1 errors, 0 warnings, 309 lines checked

./patches/page-types-add-feature-for-walking-process-address-space.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page-types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/vm/page-types.c~page-types-add-feature-for-walking-process-address-space-checkpatch-fixes Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~page-types-add-feature-for-walking-process-address-space-checkpatch-fixes
+++ a/Documentation/vm/page-types.c
@@ -190,7 +190,7 @@ static uint64_t 	page_flags[HASH_SIZE];
 #define max_t(type, x, y) ({			\
 	type __max1 = (x);			\
 	type __max2 = (y);			\
-	__max1 > __max2 ? __max1: __max2; })
+	__max1 > __max2 ? __max1 : __max2; })
 
 static unsigned long pages2mb(unsigned long pages)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
page-types-add-feature-for-walking-process-address-space.patch
page-types-add-feature-for-walking-process-address-space-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch

