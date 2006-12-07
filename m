From: akpm@osdl.org
Subject: - documentation-remount_fs-needs-lock_kernel.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:04:26 -0800
Message-ID: <200612072304.kB7N4QDX030045@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52300 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163878AbWLGXFE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:05:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vvs@sw.ru, mm-commits@vger.kernel.org


The patch titled
     Documentation: remount_fs() needs lock_kernel
has been removed from the -mm tree.  Its filename was
     documentation-remount_fs-needs-lock_kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Documentation: remount_fs() needs lock_kernel
From: Vasily Averin <vvs@sw.ru>

Fixed long-lived typo: remount_fs() needs BKL

Signed-off-by: Vasily Averin <vvs@sw.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/filesystems/Locking |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/filesystems/Locking~documentation-remount_fs-needs-lock_kernel Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~documentation-remount_fs-needs-lock_kernel
+++ a/Documentation/filesystems/Locking
@@ -124,7 +124,7 @@ sync_fs:		no	no	read
 write_super_lockfs:	?
 unlockfs:		?
 statfs:			no	no	no
-remount_fs:		no	yes	maybe		(see below)
+remount_fs:		yes	yes	maybe		(see below)
 clear_inode:		no
 umount_begin:		yes	no	no
 show_options:		no				(vfsmount->sem)
_

Patches currently in -mm which might be from vvs@sw.ru are

origin.patch

