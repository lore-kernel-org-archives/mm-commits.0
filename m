From: akpm@linux-foundation.org
Subject: + page_alloc-fix-kernel-doc-warning.patch added to -mm tree
Date: Mon, 29 Jun 2009 15:19:05 -0700
Message-ID: <200906292219.n5TMJ5Sj029481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbZF2WTI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 18:19:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     page_alloc: fix kernel-doc warning
has been added to the -mm tree.  Its filename is
     page_alloc-fix-kernel-doc-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page_alloc: fix kernel-doc warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Ummark function as having kernel-doc notation, fixing the kernel-doc
warning.

Warning(mm/page_alloc.c:4519): No description found for parameter 'zone'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~page_alloc-fix-kernel-doc-warning mm/page_alloc.c
--- a/mm/page_alloc.c~page_alloc-fix-kernel-doc-warning
+++ a/mm/page_alloc.c
@@ -4532,7 +4532,7 @@ void setup_per_zone_wmarks(void)
 	calculate_totalreserve_pages();
 }
 
-/**
+/*
  * The inactive anon list should be small enough that the VM never has to
  * do too much work, but large enough that each inactive page has a chance
  * to be referenced again before it is swapped out.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
reiser4-export-remove_from_page_cache-fix.patch
page_alloc-fix-kernel-doc-warning.patch

