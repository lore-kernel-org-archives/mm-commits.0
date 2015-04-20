From: akpm@linux-foundation.org
Subject: [merged] fs-fat-comment-fix-fat_bits-can-be-also-32.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:19:26 -0700
Message-ID: <5535513e.ffjZRUbTZhU5BlJk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbbDTTNF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fat: comment fix, fat_bits can be also 32
has been removed from the -mm tree.  Its filename was
     fs-fat-comment-fix-fat_bits-can-be-also-32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: fs/fat: comment fix, fat_bits can be also 32

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fat/fat.h~fs-fat-comment-fix-fat_bits-can-be-also-32 fs/fat/fat.h
--- a/fs/fat/fat.h~fs-fat-comment-fix-fat_bits-can-be-also-32
+++ a/fs/fat/fat.h
@@ -63,7 +63,7 @@ struct msdos_sb_info {
 	unsigned short sec_per_clus;  /* sectors/cluster */
 	unsigned short cluster_bits;  /* log2(cluster_size) */
 	unsigned int cluster_size;    /* cluster size */
-	unsigned char fats, fat_bits; /* number of FATs, FAT bits (12 or 16) */
+	unsigned char fats, fat_bits; /* number of FATs, FAT bits (12,16 or 32) */
 	unsigned short fat_start;
 	unsigned long fat_length;     /* FAT start & length (sec.) */
 	unsigned long dir_start;
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

origin.patch
linux-next.patch

