From: akpm@linux-foundation.org
Subject: + ext4-fix-error-ext-number-comments.patch added to -mm tree
Date: Thu, 15 May 2008 16:38:39 -0700
Message-ID: <200805152338.m4FNcdsf016333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298AbYEOXin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 19:38:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shen@cn.fujitsu.com


The patch titled
     ext4: fix error ext number comments
has been added to the -mm tree.  Its filename is
     ext4-fix-error-ext-number-comments.patch

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
Subject: ext4: fix error ext number comments
From: Shen Feng <shen@cn.fujitsu.com>

Change second/third to fourth.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/ext4.h   |    2 +-
 fs/ext4/ext4_i.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext4/ext4.h~ext4-fix-error-ext-number-comments fs/ext4/ext4.h
--- a/fs/ext4/ext4.h~ext4-fix-error-ext-number-comments
+++ a/fs/ext4/ext4.h
@@ -22,7 +22,7 @@
 #include "ext4_i.h"
 
 /*
- * The second extended filesystem constants/structures
+ * The fourth extended filesystem constants/structures
  */
 
 /*
diff -puN fs/ext4/ext4_i.h~ext4-fix-error-ext-number-comments fs/ext4/ext4_i.h
--- a/fs/ext4/ext4_i.h~ext4-fix-error-ext-number-comments
+++ a/fs/ext4/ext4_i.h
@@ -79,7 +79,7 @@ struct ext4_ext_cache {
 };
 
 /*
- * third extended file system inode data in memory
+ * fourth extended file system inode data in memory
  */
 struct ext4_inode_info {
 	__le32	i_data[15];	/* unconverted */
_

Patches currently in -mm which might be from shen@cn.fujitsu.com are

ext4-fix-error-ext-number-comments.patch

