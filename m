From: akpm@linux-foundation.org
Subject: + md-update-md-bitmap-during-resync-fix.patch added to -mm tree
Date: Tue, 11 Dec 2007 22:07:30 -0800
Message-ID: <200712120607.lBC67U34028893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34563 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078AbXLLGIF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 01:08:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: snitzer@gmail.com, neilb@suse.de


The patch titled
     md: Update md bitmap during resync (fix)
has been added to the -mm tree.  Its filename is
     md-update-md-bitmap-during-resync-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: Update md bitmap during resync (fix)
From: "Mike Snitzer" <snitzer@gmail.com>

You forgot to export bitmap_cond_end_sync.

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/md/bitmap.c~md-update-md-bitmap-during-resync-fix drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-update-md-bitmap-during-resync-fix
+++ a/drivers/md/bitmap.c
@@ -1589,3 +1589,4 @@ EXPORT_SYMBOL(bitmap_start_sync);
 EXPORT_SYMBOL(bitmap_end_sync);
 EXPORT_SYMBOL(bitmap_unplug);
 EXPORT_SYMBOL(bitmap_close_sync);
+EXPORT_SYMBOL(bitmap_cond_end_sync);
_

Patches currently in -mm which might be from snitzer@gmail.com are

md-update-md-bitmap-during-resync-fix.patch
