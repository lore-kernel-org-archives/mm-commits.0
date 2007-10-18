From: akpm@linux-foundation.org
Subject: - clean-up-duplicate-includes-in-fs-ecryptfs.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:44 -0700
Message-ID: <200710180653.l9I6riHe030464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51586 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761737AbXJRHtp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:49:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mahalcro@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Clean up duplicate includes in fs/ecryptfs/
has been removed from the -mm tree.  Its filename was
     clean-up-duplicate-includes-in-fs-ecryptfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up duplicate includes in fs/ecryptfs/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	fs/ecryptfs/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Michael A Halcrow <mahalcro@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/main.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ecryptfs/main.c~clean-up-duplicate-includes-in-fs-ecryptfs fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~clean-up-duplicate-includes-in-fs-ecryptfs
+++ a/fs/ecryptfs/main.c
@@ -32,7 +32,6 @@
 #include <linux/crypto.h>
 #include <linux/netlink.h>
 #include <linux/mount.h>
-#include <linux/dcache.h>
 #include <linux/pagemap.h>
 #include <linux/key.h>
 #include <linux/parser.h>
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
