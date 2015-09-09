From: akpm@linux-foundation.org
Subject: [folded-merged] parse_integer-convert-mm-fix.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 15:08:35 -0700
Message-ID: <55f0ade3.xczsPUB3uzBG7DjV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbbIIWIf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:08:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: parse_integer: fixup mm/memcontrol.c conversion
has been removed from the -mm tree.  Its filename was
     parse_integer-convert-mm-fix.patch

This patch was dropped because it was folded into parse_integer-convert-mm.patch

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: parse_integer: fixup mm/memcontrol.c conversion

Fix copypasterro: efd => cfd.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~parse_integer-convert-mm-fix mm/memcontrol.c
--- a/mm/memcontrol.c~parse_integer-convert-mm-fix
+++ a/mm/memcontrol.c
@@ -3904,7 +3904,7 @@ static ssize_t memcg_write_event_control
 	buf += ret;
 	if (*buf++ != ' ')
 		return -EINVAL;
-	ret = parse_integer(buf, 10, &efd);
+	ret = parse_integer(buf, 10, &cfd);
 	if (ret < 0)
 		return ret;
 	buf += ret;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

kstrto-accept-0-for-signed-conversion.patch
add-parse_integer-replacement-for-simple_strto.patch
parse_integer-add-runtime-testsuite.patch
parse-integer-rewrite-kstrto.patch
parse_integer-add-checkpatchpl-notice.patch
parse_integer-convert-scanf.patch
scanf-fix-type-range-overflow.patch
parse_integer-convert-lib.patch
parse_integer-convert-mm.patch
parse_integer-convert-fs.patch
parse_integer-convert-fs-cachefiles.patch
parse_integer-convert-ext2-ext3-ext4.patch
parse_integer-convert-fs-ocfs2.patch
parse_integer-convert-fs-9p.patch
parse_integer-convert-fs-exofs.patch
proc-convert-to-kstrto-kstrto_from_user.patch

