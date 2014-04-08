From: akpm@linux-foundation.org
Subject: [merged] fs-ufs-superc-add-__init-to-init_inodecache.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:53:05 -0700
Message-ID: <53446fc1.j2zFiJtEHX5LlpJ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800AbaDHVxF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:53:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dushistov@mail.ru, fabf@skynet.be

Subject: [merged] fs-ufs-superc-add-__init-to-init_inodecache.patch removed from -mm tree
To: fabf@skynet.be,dushistov@mail.ru,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:53:05 -0700


The patch titled
     Subject: fs/ufs/super.c: add __init to init_inodecache()
has been removed from the -mm tree.  Its filename was
     fs-ufs-superc-add-__init-to-init_inodecache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ufs/super.c: add __init to init_inodecache()

init_inodecache is only called by __init init_ufs_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ufs/super.c~fs-ufs-superc-add-__init-to-init_inodecache fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-superc-add-__init-to-init_inodecache
+++ a/fs/ufs/super.c
@@ -1454,7 +1454,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	ufs_inode_cachep = kmem_cache_create("ufs_inode_cache",
 					     sizeof(struct ufs_inode_info),
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
ufs-sb-mutex-merge-mutex_destroy.patch
ufs-sb-mutex-merge-mutex_destroy-fix.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch

