From: akpm@linux-foundation.org
Subject: + fs-fat-comment-fix-fat_bits-can-be-also-32.patch added to -mm
 tree
Date: Wed, 18 Feb 2015 12:19:56 -0800
Message-ID: <54e4f3ec.9cSmlULC3faqo4XD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbbBRUT5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 15:19:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fat: comment fix, fat_bits can be also 32
has been added to the -mm tree.  Its filename is
     fs-fat-comment-fix-fat_bits-can-be-also-32.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-fat-comment-fix-fat_bits-can-be-also-32.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-fat-comment-fix-fat_bits-can-be-also-32.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
fs-fat-remove-unnecessary-defintion.patch
fs-fat-remove-unnecessary-includes.patch
fs-fat-comment-fix-fat_bits-can-be-also-32.patch

