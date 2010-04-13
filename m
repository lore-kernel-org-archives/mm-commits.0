From: akpm@linux-foundation.org
Subject: + readaheadc-fix-comment.patch added to -mm tree
Date: Tue, 13 Apr 2010 13:11:45 -0700
Message-ID: <201004132011.o3DKBjTU025433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753021Ab0DMULs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Apr 2010 16:11:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shijie8@gmail.com, fengguang.wu@intel.com


The patch titled
     readahead.c: fix comment
has been added to the -mm tree.  Its filename is
     readaheadc-fix-comment.patch

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
Subject: readahead.c: fix comment
From: Huang Shijie <shijie8@gmail.com>

Fix a wrong comment over page_cache_async_readahead().

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/readahead.c~readaheadc-fix-comment mm/readahead.c
--- a/mm/readahead.c~readaheadc-fix-comment
+++ a/mm/readahead.c
@@ -523,7 +523,7 @@ EXPORT_SYMBOL_GPL(page_cache_sync_readah
  * @req_size: hint: total size of the read which the caller is performing in
  *            pagecache pages
  *
- * page_cache_async_ondemand() should be called when a page is used which
+ * page_cache_async_readahead() should be called when a page is used which
  * has the PG_readahead flag; this is a marker to suggest that the application
  * has used up enough of the readahead window that we should start pulling in
  * more pages.
_

Patches currently in -mm which might be from shijie8@gmail.com are

linux-next.patch
shmem-remove-redundant-code.patch
readaheadc-fix-comment.patch

