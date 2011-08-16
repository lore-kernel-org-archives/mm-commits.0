From: akpm@linux-foundation.org
Subject: [merged] fs-dcachec-fix-new-kernel-doc-warning.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:50:35 -0700
Message-ID: <201108161847.p7GIlgxV015129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892Ab1HPSxz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:53:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs/dcache.c: fix new kernel-doc warning
has been removed from the -mm tree.  Its filename was
     fs-dcachec-fix-new-kernel-doc-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/dcache.c: fix new kernel-doc warning
From: Randy Dunlap <rdunlap@xenotime.net>

Fix new kernel-doc warning in fs/dcache.c:

Warning(fs/dcache.c:797): No description found for parameter 'sb'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/dcache.c~fs-dcachec-fix-new-kernel-doc-warning fs/dcache.c
--- a/fs/dcache.c~fs-dcachec-fix-new-kernel-doc-warning
+++ a/fs/dcache.c
@@ -795,6 +795,7 @@ relock:
 
 /**
  * prune_dcache_sb - shrink the dcache
+ * @sb: superblock
  * @nr_to_scan: number of entries to try to free
  *
  * Attempt to shrink the superblock dcache LRU by @nr_to_scan entries. This is
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
cross-memory-attach-update.patch
consolidate-config_debug_strict_user_copy_checks-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
init-add-root=partuuid=uuid-partnroff=%d-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

