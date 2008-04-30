From: akpm@linux-foundation.org
Subject: - afs-use-the-shorter-list_head-for-brevity.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:50 -0700
Message-ID: <200804300548.m3U5moGV029918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755820AbYD3GJ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:09:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     afs: use the shorter LIST_HEAD for brevity
has been removed from the -mm tree.  Its filename was
     afs-use-the-shorter-list_head-for-brevity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: afs: use the shorter LIST_HEAD for brevity
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/cell.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/afs/cell.c~afs-use-the-shorter-list_head-for-brevity fs/afs/cell.c
--- a/fs/afs/cell.c~afs-use-the-shorter-list_head-for-brevity
+++ a/fs/afs/cell.c
@@ -20,7 +20,7 @@
 DECLARE_RWSEM(afs_proc_cells_sem);
 LIST_HEAD(afs_proc_cells);
 
-static struct list_head afs_cells = LIST_HEAD_INIT(afs_cells);
+static LIST_HEAD(afs_cells);
 static DEFINE_RWLOCK(afs_cells_lock);
 static DECLARE_RWSEM(afs_cells_sem); /* add/remove serialisation */
 static DECLARE_WAIT_QUEUE_HEAD(afs_cells_freeable_wq);
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-dvb.patch
git-mtd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

