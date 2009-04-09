From: akpm@linux-foundation.org
Subject: [merged] befs-fix-build-on-parisc.patch removed from -mm tree
Date: Thu, 09 Apr 2009 11:46:39 -0700
Message-ID: <200904091846.n39IkdLK031053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbZDISsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 14:48:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.beregalov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     befs: fix build on parisc
has been removed from the -mm tree.  Its filename was
     befs-fix-build-on-parisc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: befs: fix build on parisc
From: Alexander Beregalov <a.beregalov@gmail.com>

fs/befs/super.c:85: error: 'PAGE_SIZE' undeclared

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/super.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/befs/super.c~befs-fix-build-on-parisc fs/befs/super.c
--- a/fs/befs/super.c~befs-fix-build-on-parisc
+++ a/fs/befs/super.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/fs.h>
+#include <asm/page.h> /* for PAGE_SIZE */
 
 #include "befs.h"
 #include "super.h"
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

origin.patch
linux-next.patch

