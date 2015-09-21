From: akpm@linux-foundation.org
Subject: + mm-add-tracepoint-for-scanning-pages-fix.patch added to -mm
 tree
Date: Mon, 21 Sep 2015 14:19:00 -0700
Message-ID: <56007444.K5IXYqbJIMdekEb1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbbIUVTB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Sep 2015 17:19:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, ebru.akagunduz@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: add a missing tab
has been added to the -mm tree.  Its filename is
     mm-add-tracepoint-for-scanning-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-tracepoint-for-scanning-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-tracepoint-for-scanning-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2771,7 +2771,7 @@ static int khugepaged_scan_pmd(struct mm
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

mm-add-tracepoint-for-scanning-pages-fix.patch

