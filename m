From: akpm@linux-foundation.org
Subject: - jbdh-hide-kernel-only-code.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:55 -0800
Message-ID: <200802070030.m170UaXH007405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933756AbYBGAle (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:41:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf@aepfle.de, mm-commits@vger.kernel.org


The patch titled
     jbd.h: hide kernel only code
has been removed from the -mm tree.  Its filename was
     jbdh-hide-kernel-only-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd.h: hide kernel only code
From: Olaf Hering <olaf@aepfle.de>

Move a few kernel-only things into __KERNEL__.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jbd.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/jbd.h~jbdh-hide-kernel-only-code include/linux/jbd.h
--- a/include/linux/jbd.h~jbdh-hide-kernel-only-code
+++ a/include/linux/jbd.h
@@ -33,7 +33,6 @@
 #include <linux/lockdep.h>
 
 #include <asm/semaphore.h>
-#endif
 
 #define journal_oom_retry 1
 
@@ -84,7 +83,6 @@ static inline void jbd_free(void *ptr, s
 
 #define JFS_MIN_JOURNAL_BLOCKS 1024
 
-#ifdef __KERNEL__
 
 /**
  * typedef handle_t - The handle_t type represents a single atomic update being performed by some process.
_

Patches currently in -mm which might be from olaf@aepfle.de are

origin.patch
keep-track-of-network-interface-renaming.patch
