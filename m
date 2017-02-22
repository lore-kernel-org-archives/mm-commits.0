From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 22 Feb 2017 15:29:08 -0800
Message-ID: <58ae1ec4.1QWzpQCJS/1H3Iru%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47424 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932906AbdBVX3J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:29:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch

This patch was dropped because it was folded into lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes

WARNING: line over 80 characters
#214: FILE: mm/page_alloc.c:4332:
+static bool show_mem_node_skip(unsigned int flags, int nid, nodemask_t *nodemask)

WARNING: line over 80 characters
#230: FILE: mm/page_alloc.c:4338:
+	 * no node mask - aka implicit memory numa policy. Do not bother with the

WARNING: line over 80 characters
#231: FILE: mm/page_alloc.c:4339:
+	 * synchronization - read_mems_allowed_begin - because we do not have to be

total: 0 errors, 3 warnings, 198 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -4280,9 +4280,9 @@ static bool show_mem_node_skip(unsigned
 		return false;
 
 	/*
-	 * no node mask - aka implicit memory numa policy. Do not bother with the
-	 * synchronization - read_mems_allowed_begin - because we do not have to be
-	 * precise here.
+	 * no node mask - aka implicit memory numa policy. Do not bother with
+	 * the synchronization - read_mems_allowed_begin - because we do not
+	 * have to be precise here.
 	 */
 	if (!nodemask)
 		nodemask = &cpuset_current_mems_allowed;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch

