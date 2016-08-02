From: akpm@linux-foundation.org
Subject: [merged] befs-fix-function-name-in-documentation.patch removed
 from -mm tree
Date: Mon, 01 Aug 2016 17:25:35 -0700
Message-ID: <579fe87f.rTXf1Pz816A91p6D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbcHBAZg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 20:25:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luisbg@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: befs: fix function name in documentation
has been removed from the -mm tree.  Its filename was
     befs-fix-function-name-in-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: befs: fix function name in documentation

Documentation of function befs_load_cb() lists it as load_befs_sb().  Fix
the misnomer.

Link: http://lkml.kernel.org/r/1465700235-22881-2-git-send-email-luisbg@osg.samsung.com
Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/befs/super.c~befs-fix-function-name-in-documentation fs/befs/super.c
--- a/fs/befs/super.c~befs-fix-function-name-in-documentation
+++ a/fs/befs/super.c
@@ -14,7 +14,7 @@
 #include "super.h"
 
 /**
- * load_befs_sb -- Read from disk and properly byteswap all the fields
+ * befs_load_sb -- Read from disk and properly byteswap all the fields
  * of the befs superblock
  *
  *
_

Patches currently in -mm which might be from luisbg@osg.samsung.com are

dynamic_debug-only-add-header-when-used.patch
dynamic_debug-only-add-header-when-used-fix.patch
maintainers-befs-add-new-maintainers.patch

