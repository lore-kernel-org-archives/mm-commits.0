From: akpm@linux-foundation.org
Subject: + ext-update-documentation.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:53:22 -0800
Message-ID: <200702130553.l1D5rMdo023153@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55651 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbXBMFxY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:53:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@gmail.com


The patch titled
     ext[234]: update documentation
has been added to the -mm tree.  Its filename is
     ext-update-documentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext[234]: update documentation
From: "Aneesh Kumar K.V" <aneesh.kumar@gmail.com>

Signed-off-by: "Aneesh Kumar K.V" <aneesh.kumar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/balloc.c |    2 +-
 fs/ext3/balloc.c |    2 +-
 fs/ext4/balloc.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ext2/balloc.c~ext-update-documentation fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~ext-update-documentation
+++ a/fs/ext2/balloc.c
@@ -29,7 +29,7 @@
  * The file system contains group descriptors which are located after the
  * super block.  Each descriptor contains the number of the bitmap block and
  * the free blocks count in the block.  The descriptors are loaded in memory
- * when a file system is mounted (see ext2_read_super).
+ * when a file system is mounted (see ext2_fill_super).
  */
 
 
diff -puN fs/ext3/balloc.c~ext-update-documentation fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext-update-documentation
+++ a/fs/ext3/balloc.c
@@ -32,7 +32,7 @@
  * The file system contains group descriptors which are located after the
  * super block.  Each descriptor contains the number of the bitmap block and
  * the free blocks count in the block.  The descriptors are loaded in memory
- * when a file system is mounted (see ext3_read_super).
+ * when a file system is mounted (see ext3_fill_super).
  */
 
 
diff -puN fs/ext4/balloc.c~ext-update-documentation fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~ext-update-documentation
+++ a/fs/ext4/balloc.c
@@ -50,7 +50,7 @@ void ext4_get_group_no_and_offset(struct
  * The file system contains group descriptors which are located after the
  * super block.  Each descriptor contains the number of the bitmap block and
  * the free blocks count in the block.  The descriptors are loaded in memory
- * when a file system is mounted (see ext4_read_super).
+ * when a file system is mounted (see ext4_fill_super).
  */
 
 
_

Patches currently in -mm which might be from aneesh.kumar@gmail.com are

origin.patch
ext-update-documentation.patch
