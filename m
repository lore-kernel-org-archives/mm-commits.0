From: akpm@linux-foundation.org
Subject: + lib-decompressc-fix-initconst.patch added to -mm tree
Date: Tue, 23 Apr 2013 15:01:35 -0700
Message-ID: <20130423220135.6792D31C0AC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:44306 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333Ab3DWWBg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Apr 2013 18:01:36 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so125366qcr.4
        for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2013 15:01:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org


The patch titled
     Subject: lib/decompress.c: fix initconst
has been added to the -mm tree.  Its filename is
     lib-decompressc-fix-initconst.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -42,7 +42,7 @@ struct compress_format {
 	decompress_fn decompressor;
 };
 
-static const struct compress_format compressed_formats[] __initdata = {
+static const struct compress_format compressed_formats[] __initconst = {
 	{ {037, 0213}, "gzip", gunzip },
 	{ {037, 0236}, "gzip", gunzip },
 	{ {0x42, 0x5a}, "bzip2", bunzip2 },
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
hwpoison-check-dirty-flag-to-match-against-clean-page.patch
vm-adjust-ifdef-for-tiny_rcu.patch
mm-merging-memory-blocks-resets-mempolicy.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch
argv_split-teach-it-to-handle-mutable-strings.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix-2.patch
set_task_comm-kill-the-pointless-memset-wmb.patch
lib-decompressc-fix-initconst.patch

