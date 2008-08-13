From: akpm@linux-foundation.org
Subject: - reiserfs-removed-duplicated-include.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:53:11 -0700
Message-ID: <200808130853.m7D8rBA7008301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752998AbYHMJC6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 05:02:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyi.huang@gmail.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     reiserfs: removed duplicated #include
has been removed from the -mm tree.  Its filename was
     reiserfs-removed-duplicated-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: removed duplicated #include
From: Huang Weiyi <weiyi.huang@gmail.com>

Removed duplicated #include <linux/quotaops.h> in
fs/reiserfs/super.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/reiserfs/super.c~reiserfs-removed-duplicated-include fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiserfs-removed-duplicated-include
+++ a/fs/reiserfs/super.c
@@ -27,7 +27,6 @@
 #include <linux/mnt_namespace.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
-#include <linux/quotaops.h>
 
 struct file_system_type reiserfs_fs_type;
 
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

linux-next.patch
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch

