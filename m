From: akpm@linux-foundation.org
Subject: + fat-follow-rename-pack_hex_byte-to-hex_byte_pack.patch added to -mm tree
Date: Tue, 18 Oct 2011 14:01:54 -0700
Message-ID: <201110182101.p9IL1smX026345@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:14831 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab1JRVCA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2011 17:02:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fat: follow rename pack_hex_byte() to hex_byte_pack()
has been added to the -mm tree.  Its filename is
     fat-follow-rename-pack_hex_byte-to-hex_byte_pack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: fat: follow rename pack_hex_byte() to hex_byte_pack()

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

linux-next.patch
selinuxfs-remove-custome-hex_to_bin.patch
lib-rename-pack_hex_byte-to-hex_byte_pack.patch
kgdb-follow-rename-pack_hex_byte-to-hex_byte_pack.patch
security-follow-rename-pack_hex_byte-to-hex_byte_pack.patch
fat-follow-rename-pack_hex_byte-to-hex_byte_pack.patch
wireless-at76c50x-follow-rename-pack_hex_byte-to-hex_byte_pack.patch

