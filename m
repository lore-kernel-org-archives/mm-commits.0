From: akpm@linux-foundation.org
Subject: [merged] fs-bfs-inodec-add-__init-to-init_inodecache.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:30:09 -0700
Message-ID: <53446a61.OzISsdo0r6w1e5++%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598AbaDHVaJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:30:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: [merged] fs-bfs-inodec-add-__init-to-init_inodecache.patch removed from -mm tree
To: fabf@skynet.be,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:30:09 -0700


The patch titled
     Subject: fs/bfs/inode.c: add __init to init_inodecache()
has been removed from the -mm tree.  Its filename was
     fs-bfs-inodec-add-__init-to-init_inodecache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/bfs/inode.c: add __init to init_inodecache()

init_inodecache is only called by __init init_bfs_fs

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/bfs/inode.c~fs-bfs-inodec-add-__init-to-init_inodecache fs/bfs/inode.c
--- a/fs/bfs/inode.c~fs-bfs-inodec-add-__init-to-init_inodecache
+++ a/fs/bfs/inode.c
@@ -266,7 +266,7 @@ static void init_once(void *foo)
 	inode_init_once(&bi->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	bfs_inode_cachep = kmem_cache_create("bfs_inode_cache",
 					     sizeof(struct bfs_inode_info),
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
ufs-sb-mutex-merge-mutex_destroy.patch
ufs-sb-mutex-merge-mutex_destroy-fix.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch

