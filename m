From: akpm@linux-foundation.org
Subject: + minix-v3-fix-superblock-definition.patch added to -mm tree
Date: Sat, 17 Feb 2007 18:13:40 -0700
Message-ID: <200702180113.l1I1DfIj007043@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53517 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965519AbXBRBNv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 20:13:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Andries.Brouwer@cwi.nl, cedric.augonnet@gmail.com, danarag@gmail.com


The patch titled
     minix v3: fix superblock definition
has been added to the -mm tree.  Its filename is
     minix-v3-fix-superblock-definition.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: minix v3: fix superblock definition
From: Andries Brouwer <Andries.Brouwer@cwi.nl>

Cc: "Cedric Augonnet" <cedric.augonnet@gmail.com>
Cc: "Daniel Aragones" <danarag@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/minix_fs.h |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/minix_fs.h~minix-v3-fix-superblock-definition include/linux/minix_fs.h
--- a/include/linux/minix_fs.h~minix-v3-fix-superblock-definition
+++ a/include/linux/minix_fs.h
@@ -78,9 +78,8 @@ struct minix_super_block {
  * V3 minix super-block data on disk
  */
 struct minix3_super_block {
-	__u16 s_ninodes;
+	__u32 s_ninodes;
 	__u16 s_nzones;
-	__u16 s_pad0;
 	__u16 s_imap_blocks;
 	__u16 s_zmap_blocks;
 	__u16 s_firstdatazone;
_

Patches currently in -mm which might be from Andries.Brouwer@cwi.nl are

minix-v3-fix-superblock-definition.patch
