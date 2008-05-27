From: akpm@linux-foundation.org
Subject: - for_each_online_pgdat-kerneldoc-fix.patch removed from -mm tree
Date: Tue, 27 May 2008 00:28:15 -0700
Message-ID: <200805270728.m4R7SFY9014908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755693AbYE0H2q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:28:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     for_each_online_pgdat(): kerneldoc fix
has been removed from the -mm tree.  Its filename was
     for_each_online_pgdat-kerneldoc-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

