From: akpm@linux-foundation.org
Subject: [merged] fat-follow-rename-pack_hex_byte-to-hex_byte_pack.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:16:38 -0700
Message-ID: <201111012116.pA1LGcKb016088@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16816 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab1KAVQo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:16:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: follow rename pack_hex_byte() to hex_byte_pack()
has been removed from the -mm tree.  Its filename was
     fat-follow-rename-pack_hex_byte-to-hex_byte_pack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: fat: follow rename pack_hex_byte() to hex_byte_pack()

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/fat/dir.c~fat-follow-rename-pack_hex_byte-to-hex_byte_pack fs/fat/dir.c
--- a/fs/fat/dir.c~fat-follow-rename-pack_hex_byte-to-hex_byte_pack
+++ a/fs/fat/dir.c
@@ -156,8 +156,8 @@ static int uni16_to_x8(struct super_bloc
 		} else {
 			if (uni_xlate == 1) {
 				*op++ = ':';
-				op = pack_hex_byte(op, ec >> 8);
-				op = pack_hex_byte(op, ec);
+				op = hex_byte_pack(op, ec >> 8);
+				op = hex_byte_pack(op, ec);
 				len -= 5;
 			} else {
 				*op++ = '?';
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch
selinuxfs-remove-custome-hex_to_bin.patch

