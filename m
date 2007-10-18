From: akpm@linux-foundation.org
Subject: - clean-up-duplicate-includes-in-documentation.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:11 -0700
Message-ID: <200710180704.l9I74BEY031529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46990 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763041AbXJRHQp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:16:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, balbir@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Clean up duplicate includes in Documentation/
has been removed from the -mm tree.  Its filename was
     clean-up-duplicate-includes-in-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up duplicate includes in Documentation/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	Documentation/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN Documentation/accounting/getdelays.c~clean-up-duplicate-includes-in-documentation Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~clean-up-duplicate-includes-in-documentation
+++ a/Documentation/accounting/getdelays.c
@@ -21,7 +21,6 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/socket.h>
-#include <sys/types.h>
 #include <signal.h>
 
 #include <linux/genetlink.h>
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
