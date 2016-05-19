From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch removed from -mm tree
Date: Thu, 19 May 2016 16:56:17 -0700
Message-ID: <573e52a1.qRP3+iCQqslUFSQP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbcESX4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:56:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch

This patch was dropped because it was folded into mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix

Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix
+++ a/mm/page_alloc.c
@@ -3417,7 +3417,7 @@ retry_cpuset:
 	/* The preferred zone is used for statistics later */
 	ac.preferred_zoneref = first_zones_zonelist(ac.zonelist,
 					ac.high_zoneidx, ac.nodemask);
-	if (!ac.preferred_zone) {
+	if (!ac.preferred_zoneref) {
 		page = NULL;
 		goto no_zone;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-nodemaskh-create-next_node_in-helper.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch

