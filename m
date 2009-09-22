From: akpm@linux-foundation.org
Subject: [folded] move-magic-numbers-into-magich-update.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:37:14 -0700
Message-ID: <200909222137.n8MLbEJf020765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752328AbZIVVhS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:37:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dank@qemfd.net, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     move-magic-numbers-into-magich-update
has been removed from the -mm tree.  Its filename was
     move-magic-numbers-into-magich-update.patch

This patch was dropped because it was folded into move-magic-numbers-into-magich.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: move-magic-numbers-into-magich-update
From: Nick Black <dank@qemfd.net>

Signed-off-by: Nick Black <dank@qemfd.net>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c  |    4 +---
 include/linux/magic.h |    1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/hugetlbfs/inode.c~move-magic-numbers-into-magich-update fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~move-magic-numbers-into-magich-update
+++ a/fs/hugetlbfs/inode.c
@@ -31,12 +31,10 @@
 #include <linux/statfs.h>
 #include <linux/security.h>
 #include <linux/ima.h>
+#include <linux/magic.h>
 
 #include <asm/uaccess.h>
 
-/* some random number */
-#define HUGETLBFS_MAGIC	0x958458f6
