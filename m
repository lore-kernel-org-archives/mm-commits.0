From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-align-block-comments-of-nilfs_sufile_truncate_range-at.patch removed
 from -mm tree
Date: Mon, 20 Nov 2017 13:25:31 -0800
Message-ID: <20171120212531.44A003Lit%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40748 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752973AbdKTVZd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:25:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: align block comments of nilfs_sufile_truncate_range() at *
has been removed from the -mm tree.  Its filename was
     nilfs2-align-block-comments-of-nilfs_sufile_truncate_range-at.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: align block comments of nilfs_sufile_truncate_range() at *

Fix the following checkpatch warning:

 WARNING: Block comments should align the * on each line
 #633: FILE: sufile.c:633:
 +/**
 +  * nilfs_sufile_truncate_range - truncate range of segment array

Link: http://lkml.kernel.org/r/1509367935-3086-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN fs/nilfs2/sufile.c~nilfs2-align-block-comments-of-nilfs_sufile_truncate_range-at fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-align-block-comments-of-nilfs_sufile_truncate_range-at
+++ a/fs/nilfs2/sufile.c
@@ -630,22 +630,22 @@ void nilfs_sufile_do_set_error(struct in
 }
 
 /**
-  * nilfs_sufile_truncate_range - truncate range of segment array
-  * @sufile: inode of segment usage file
-  * @start: start segment number (inclusive)
-  * @end: end segment number (inclusive)
-  *
-  * Return Value: On success, 0 is returned.  On error, one of the
-  * following negative error codes is returned.
-  *
-  * %-EIO - I/O error.
-  *
-  * %-ENOMEM - Insufficient amount of memory available.
-  *
-  * %-EINVAL - Invalid number of segments specified
-  *
-  * %-EBUSY - Dirty or active segments are present in the range
-  */
+ * nilfs_sufile_truncate_range - truncate range of segment array
+ * @sufile: inode of segment usage file
+ * @start: start segment number (inclusive)
+ * @end: end segment number (inclusive)
+ *
+ * Return Value: On success, 0 is returned.  On error, one of the
+ * following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-EINVAL - Invalid number of segments specified
+ *
+ * %-EBUSY - Dirty or active segments are present in the range
+ */
 static int nilfs_sufile_truncate_range(struct inode *sufile,
 				       __u64 start, __u64 end)
 {
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


