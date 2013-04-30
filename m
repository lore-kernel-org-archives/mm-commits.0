From: akpm@linux-foundation.org
Subject: [merged] fs-fix-comment-of-generic_file_llseek.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:44:18 -0700
Message-ID: <20130430184418.73D5C31C2B9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:36792 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735Ab3D3SoT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:44:19 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so84493vbe.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:44:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tom.leiming@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/read_write.c: fix generic_file_llseek() comment
has been removed from the -mm tree.  Its filename was
     fs-fix-comment-of-generic_file_llseek.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ming Lei <tom.leiming@gmail.com>
Subject: fs/read_write.c: fix generic_file_llseek() comment

Commit ef3d0fd2 ("vfs: do (nearly) lockless generic_file_llseek") has
removed i_mutex from generic_file_llseek, so update the comment
accordingly.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/read_write.c~fs-fix-comment-of-generic_file_llseek fs/read_write.c
--- a/fs/read_write.c~fs-fix-comment-of-generic_file_llseek
+++ a/fs/read_write.c
@@ -128,7 +128,7 @@ EXPORT_SYMBOL(generic_file_llseek_size);
  *
  * This is a generic implemenation of ->llseek useable for all normal local
  * filesystems.  It just updates the file offset to the value specified by
- * @offset and @whence under i_mutex.
+ * @offset and @whence.
  */
 loff_t generic_file_llseek(struct file *file, loff_t offset, int whence)
 {
_

Patches currently in -mm which might be from tom.leiming@gmail.com are

origin.patch

