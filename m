From: akpm@linux-foundation.org
Subject: [folded-merged] fs-fat-remove-unnecessary-includes-fix-2.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 12:08:07 -0700
Message-ID: <55300897.Y+1QoyxmS3k1pSsF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbbDPTII (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 15:08:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, hirofumi@mail.parknet.co.jp, kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fat: put one actually necessary include file back
has been removed from the -mm tree.  Its filename was
     fs-fat-remove-unnecessary-includes-fix-2.patch

This patch was dropped because it was folded into fs-fat-remove-unnecessary-includes.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: fs/fat: put one actually necessary include file back

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/fat/inode.c~fs-fat-remove-unnecessary-includes-fix-2 fs/fat/inode.c
--- a/fs/fat/inode.c~fs-fat-remove-unnecessary-includes-fix-2
+++ a/fs/fat/inode.c
@@ -16,6 +16,7 @@
 #include <linux/vfs.h>
 #include <linux/seq_file.h>
 #include <linux/parser.h>
+#include <linux/uio.h>
 #include <linux/blkdev.h>
 #include <asm/unaligned.h>
 #include "fat.h"
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
fs-fat-remove-unnecessary-includes.patch

