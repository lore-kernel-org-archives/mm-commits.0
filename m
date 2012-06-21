From: akpm@linux-foundation.org
Subject: + hfsplus-amend-debugging-print.patch added to -mm tree
Date: Thu, 21 Jun 2012 12:42:32 -0700
Message-ID: <20120621194232.4AB50A0329@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:53856 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab2FUTme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:42:34 -0400
Received: by wibhn6 with SMTP id hn6so64028wib.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:42:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.bityutskiy@linux.intel.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfsplus: amend debugging print
has been added to the -mm tree.  Its filename is
     hfsplus-amend-debugging-print.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: hfsplus: amend debugging print

Print correct function name in the debugging print of the
'hfsplus_sync_fs()' function.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfsplus/super.c~hfsplus-amend-debugging-print fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-amend-debugging-print
+++ a/fs/hfsplus/super.c
@@ -171,7 +171,7 @@ static int hfsplus_sync_fs(struct super_
 	if (!wait)
 		return 0;
 
-	dprint(DBG_SUPER, "hfsplus_write_super\n");
+	dprint(DBG_SUPER, "hfsplus_sync_fs\n");
 
 	sb->s_dirt = 0;
 
_
Subject: Subject: hfsplus: amend debugging print

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch
hfs-push-lock_super-down.patch
hfs-get-rid-of-lock_super.patch
hfs-remove-extra-mdb-write-on-unmount.patch
hfs-simplify-a-bit-checking-for-r-o.patch
hfs-introduce-vfs-superblock-object-back-reference.patch
hfs-get-rid-of-hfs_sync_super.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
hfsplus-make-hfsplus_sync_fs-static.patch
hfsplus-amend-debugging-print.patch
hfsplus-remove-useless-check.patch
hfsplus-get-rid-of-write_super.patch

