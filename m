From: akpm@linux-foundation.org
Subject: [patch 59/94] nilfs2: align block comments of
 nilfs_sufile_truncate_range() at *
Date: Fri, 17 Nov 2017 15:29:43 -0800
Message-ID: <20171117232943.4bk6TNfpn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55888 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966938AbdKQX3o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:29:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
