From: akpm@linux-foundation.org
Subject: - cgroup-remove-dead-code-in-cgroup_get_rootdir.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:46:02 -0800
Message-ID: <200802250046.m1P0k2WI006309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293AbYBYAsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:48:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup: remove dead code in cgroup_get_rootdir()
has been removed from the -mm tree.  Its filename was
     cgroup-remove-dead-code-in-cgroup_get_rootdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: remove dead code in cgroup_get_rootdir()
From: Li Zefan <lizf@cn.fujitsu.com>

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-remove-dead-code-in-cgroup_get_rootdir kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-remove-dead-code-in-cgroup_get_rootdir
+++ a/kernel/cgroup.c
@@ -919,7 +919,6 @@ static int cgroup_get_rootdir(struct sup
 	if (!inode)
 		return -ENOMEM;
 
-	inode->i_op = &simple_dir_inode_operations;
 	inode->i_fop = &simple_dir_operations;
 	inode->i_op = &cgroup_dir_inode_operations;
 	/* directories start off with i_nlink == 2 (for "." entry) */
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are
