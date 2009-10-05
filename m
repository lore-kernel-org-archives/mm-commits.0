From: akpm@linux-foundation.org
Subject: [merged] afs-remove-cacheh.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:39:32 -0700
Message-ID: <200910051839.n95IdWvc019350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754319AbZJESk1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:40:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     afs: remove cache.h
has been removed from the -mm tree.  Its filename was
     afs-remove-cacheh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: afs: remove cache.h
From: Christoph Hellwig <hch@lst.de>

It's just a wrapper for <linux/fscache.h>, so remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/cache.h    |   12 ------------
 fs/afs/internal.h |    2 +-
 2 files changed, 1 insertion(+), 13 deletions(-)

diff -puN fs/afs/cache.h~afs-remove-cacheh /dev/null
--- a/fs/afs/cache.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* AFS local cache management interface
- *
- * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#include <linux/fscache.h>
diff -puN fs/afs/internal.h~afs-remove-cacheh fs/afs/internal.h
--- a/fs/afs/internal.h~afs-remove-cacheh
+++ a/fs/afs/internal.h
@@ -18,10 +18,10 @@
 #include <linux/key.h>
 #include <linux/workqueue.h>
 #include <linux/sched.h>
+#include <linux/fscache.h>
 
 #include "afs.h"
 #include "afs_vl.h"
-#include "cache.h"
 
 #define AFS_CELL_MAX_ADDRS 15
 
_

Patches currently in -mm which might be from hch@lst.de are

linux-next.patch
avr32-convert-to-asm-generic-hardirqh.patch
sparc32-convert-to-asm-generic-hardirqh.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
xtensa-convert-to-asm-generic-hardirqh.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics.patch
elf-kill-use_elf_core_dump.patch

