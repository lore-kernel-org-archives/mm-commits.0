From: akpm@linux-foundation.org
Subject: + cgroup-remove-dead-code-in-cgroup_get_rootdir.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:32:46 -0800
Message-ID: <200802230733.m1N7XZ28018235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943AbYBWHyE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroup: remove dead code in cgroup_get_rootdir()
has been added to the -mm tree.  Its filename is
     cgroup-remove-dead-code-in-cgroup_get_rootdir.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

cgroup-fix-and-update-documentation.patch
cgroup-fix-comments.patch
cgroup-clean-up-cgrouph.patch
cgroup-fix-memory-leak-in-cgroup_get_sb.patch
cgroup-fix-subsys-bitops.patch
cgroup-remove-duplicate-code-in-find_css_set.patch
cgroup-remove-dead-code-in-cgroup_get_rootdir.patch
memcgroup-fix-and-update-documentation.patch
memcgroup-remove-a-useless-vm_bug_on.patch
memcgroup-return-negative-error-code-in-mem_cgroup_create.patch
