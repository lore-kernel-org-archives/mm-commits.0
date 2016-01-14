From: akpm@linux-foundation.org
Subject: [folded-merged] mm-add-tracepoint-for-scanning-pages-fix.patch
 removed from -mm tree
Date: Thu, 14 Jan 2016 14:30:49 -0800
Message-ID: <56982199.l55Sxk9PIAUNmte4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbcANWau (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:30:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, ebru.akagunduz@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: add a missing tab
has been removed from the -mm tree.  Its filename was
     mm-add-tracepoint-for-scanning-pages-fix.patch

This patch was dropped because it was folded into mm-add-tracepoint-for-scanning-pages.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mm/huge_memory: add a missing tab

This line should be indented one more tab.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-add-tracepoint-for-scanning-pages-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-add-tracepoint-for-scanning-pages-fix
+++ a/mm/huge_memory.c
@@ -2769,7 +2769,7 @@ static int khugepaged_scan_pmd(struct mm
 		khugepaged_node_load[node]++;
 		VM_BUG_ON_PAGE(PageCompound(page), page);
 		if (!PageLRU(page)) {
-		result = SCAN_SCAN_ABORT;
+			result = SCAN_SCAN_ABORT;
 			goto out_unmap;
 		}
 		if (PageLocked(page)) {
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

mm-add-tracepoint-for-scanning-pages.patch

