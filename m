From: akpm@linux-foundation.org
Subject: + for_each_online_pgdat-kerneldoc-fix.patch added to -mm tree
Date: Wed, 21 May 2008 23:31:13 -0700
Message-ID: <200805220631.m4M6VD6h021152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754987AbYEVGbq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 02:31:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp


The patch titled
     for_each_online_pgdat(): kerneldoc fix
has been added to the -mm tree.  Its filename is
     for_each_online_pgdat-kerneldoc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: for_each_online_pgdat(): kerneldoc fix
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

for_each_pgdat() was renamed to for_each_online_pgdat() and kerneldoc
comments should be updated accordingly.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~for_each_online_pgdat-kerneldoc-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~for_each_online_pgdat-kerneldoc-fix
+++ a/include/linux/mmzone.h
@@ -703,7 +703,7 @@ extern struct pglist_data *next_online_p
 extern struct zone *next_zone(struct zone *zone);
 
 /**
- * for_each_pgdat - helper macro to iterate over all nodes
+ * for_each_online_pgdat - helper macro to iterate over all online nodes
  * @pgdat - pointer to a pg_data_t variable
  */
 #define for_each_online_pgdat(pgdat)			\
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

for_each_online_pgdat-kerneldoc-fix.patch
linux-next.patch

