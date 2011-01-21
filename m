From: akpm@linux-foundation.org
Subject: [merged] mm-vmscanc-remove-duplicate-include-of-compactionh.patch removed from -mm tree
Date: Fri, 21 Jan 2011 12:31:29 -0800
Message-ID: <201101212031.p0LKVTem031609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817Ab1AUUcC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 15:32:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jj@chaosbits.net, mm-commits@vger.kernel.org


The patch titled
     mm/vmscan.c: remove duplicate include of compaction.h
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-remove-duplicate-include-of-compactionh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/vmscan.c: remove duplicate include of compaction.h
From: Jesper Juhl <jj@chaosbits.net>

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscanc-remove-duplicate-include-of-compactionh mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscanc-remove-duplicate-include-of-compactionh
+++ a/mm/vmscan.c
@@ -41,7 +41,6 @@
 #include <linux/memcontrol.h>
 #include <linux/delayacct.h>
 #include <linux/sysctl.h>
-#include <linux/compaction.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
_

Patches currently in -mm which might be from jj@chaosbits.net are

origin.patch
linux-next.patch
x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch
audit-always-follow-va_copy-with-va_end.patch

