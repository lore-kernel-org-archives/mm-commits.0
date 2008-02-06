From: akpm@linux-foundation.org
Subject: - md-update-md-bitmap-during-resync-fix.patch removed from -mm tree
Date: Tue, 05 Feb 2008 23:32:39 -0800
Message-ID: <200802060732.m167WLGG031854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46897 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759424AbYBFHc6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 02:32:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: snitzer@gmail.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: Update md bitmap during resync (fix)
has been removed from the -mm tree.  Its filename was
     md-update-md-bitmap-during-resync-fix.patch

This patch was dropped because it was folded into md-update-md-bitmap-during-resync.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
md-update-md-bitmap-during-resync.patch
md-update-md-bitmap-during-resync-fix.patch
