From: akpm@linux-foundation.org
Subject: + gfs2-add-newline-to-printk-message.patch added to -mm tree
Date: Wed, 21 Feb 2007 12:33:29 -0800
Message-ID: <200702212033.l1LKXTI6025025@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42934 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423099AbXBUUdi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:33:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richardfearn@gmail.com, swhiteho@redhat.com


The patch titled
     gfs2: add newline to printk message
has been added to the -mm tree.  Its filename is
     gfs2-add-newline-to-printk-message.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: gfs2: add newline to printk message
From: Richard Fearn <richardfearn@gmail.com>

Add a missing newline to one of the printk messages in
fs/gfs2/ops_fstype.c.

Signed-off-by: Richard Fearn <richardfearn@gmail.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/ops_fstype.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/gfs2/ops_fstype.c~gfs2-add-newline-to-printk-message fs/gfs2/ops_fstype.c
--- a/fs/gfs2/ops_fstype.c~gfs2-add-newline-to-printk-message
+++ a/fs/gfs2/ops_fstype.c
@@ -840,7 +840,7 @@ static struct super_block* get_gfs2_sb(c
 	}
 
 	printk(KERN_WARNING "GFS2: Unrecognized block device or "
-	       "mount point %s", dev_name);
+	       "mount point %s\n", dev_name);
 
 free_nd:
 	path_release(&nd);
_

Patches currently in -mm which might be from richardfearn@gmail.com are

gfs2-add-newline-to-printk-message.patch
