From: akpm@linux-foundation.org
Subject: [merged] nommu-ramfs-remove-unused-local-var.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:26:28 -0800
Message-ID: <200912182026.nBIKQSB3016460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755690AbZLRU0q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:26:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, dhowells@redhat.com, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     nommu: ramfs: remove unused local var
has been removed from the -mm tree.  Its filename was
     nommu-ramfs-remove-unused-local-var.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: ramfs: remove unused local var
From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: David Howells <dhowells@redhat.com>
Acked-by: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ramfs/file-nommu.c~nommu-ramfs-remove-unused-local-var fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~nommu-ramfs-remove-unused-local-var
+++ a/fs/ramfs/file-nommu.c
@@ -60,7 +60,7 @@ const struct inode_operations ramfs_file
  */
 int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 {
-	unsigned long npages, xpages, loop, limit;
+	unsigned long npages, xpages, loop;
 	struct page *pages;
 	unsigned order;
 	void *data;
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
serial-fit-blackfin-uart-over-sport-driver-into-common-uart-infrastructure.patch

