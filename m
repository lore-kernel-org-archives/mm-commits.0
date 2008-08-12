From: akpm@linux-foundation.org
Subject: + reiserfs-removed-duplicated-include.patch added to -mm tree
Date: Mon, 11 Aug 2008 17:36:50 -0700
Message-ID: <200808120036.m7C0aoHP030472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbYHLAg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 20:36:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyi.huang@gmail.com, jack@suse.cz


The patch titled
     reiserfs: removed duplicated #include
has been added to the -mm tree.  Its filename is
     reiserfs-removed-duplicated-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: removed duplicated #include
From: Huang Weiyi <weiyi.huang@gmail.com>

Removed duplicated #include <linux/quotaops.h> in
fs/reiserfs/super.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/reiserfs/super.c~reiserfs-removed-duplicated-include fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiserfs-removed-duplicated-include
+++ a/fs/reiserfs/super.c
@@ -27,7 +27,6 @@
 #include <linux/mnt_namespace.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
-#include <linux/quotaops.h>
 
 struct file_system_type reiserfs_fs_type;
 
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

mm-sparsec-removed-duplicated-include.patch
drivers-char-rtcc-removed-duplicated-include.patch
reiserfs-removed-duplicated-include.patch
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch

