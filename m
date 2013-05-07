From: akpm@linux-foundation.org
Subject: [merged] lib-decompressc-fix-initconst.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:14 -0700
Message-ID: <20130507175114.6C1BE5A451C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:45847 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EGRvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:15 -0400
Received: by mail-gh0-f202.google.com with SMTP id g24so74665ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/decompress.c: fix initconst
has been removed from the -mm tree.  Its filename was
     lib-decompressc-fix-initconst.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <andi@firstfloor.org>
Subject: lib/decompress.c: fix initconst

Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/decompress.c~lib-decompressc-fix-initconst lib/decompress.c
--- a/lib/decompress.c~lib-decompressc-fix-initconst
+++ a/lib/decompress.c
@@ -38,7 +38,7 @@ struct compress_format {
 	decompress_fn decompressor;
 };
 
-static const struct compress_format compressed_formats[] __initdata = {
+static const struct compress_format compressed_formats[] __initconst = {
 	{ {037, 0213}, "gzip", gunzip },
 	{ {037, 0236}, "gzip", gunzip },
 	{ {0x42, 0x5a}, "bzip2", bunzip2 },
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

