From: akpm@linux-foundation.org
Subject: +
 nilfs2-align-block-comments-of-nilfs_sufile_truncate_range-at.patch added
 to -mm tree
Date: Wed, 01 Nov 2017 14:16:19 -0700
Message-ID: <59fa39a3.8HRcYAgFXh9LlW5o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40998 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933194AbdKAVQU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2017 17:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: align block comments of nilfs_sufile_truncate_range() at *
has been added to the -mm tree.  Its filename is
     nilfs2-align-block-comments-of-nilfs_sufile_truncate_range-at.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-align-block-comments-of-nilfs_sufile_truncate_range-at.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-align-block-comments-of-nilfs_sufile_truncate_range-at.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

nilfs2-align-block-comments-of-nilfs_sufile_truncate_range-at.patch
nilfs2-use-octal-for-unreadable-permission-macro.patch

