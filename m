From: akpm@linux-foundation.org
Subject: [merged] fs-affs-bitmapc-remove-unnecessary-return.patch removed
 from -mm tree
Date: Wed, 18 Feb 2015 11:43:40 -0800
Message-ID: <54e4eb6c.lr1y0OwsKv0biLed%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbbBRTnl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/bitmap.c: remove unnecessary return
has been removed from the -mm tree.  Its filename was
     fs-affs-bitmapc-remove-unnecessary-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/bitmap.c: remove unnecessary return

return is not needed at the end of function.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/bitmap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/affs/bitmap.c~fs-affs-bitmapc-remove-unnecessary-return fs/affs/bitmap.c
--- a/fs/affs/bitmap.c~fs-affs-bitmapc-remove-unnecessary-return
+++ a/fs/affs/bitmap.c
@@ -99,7 +99,6 @@ err_bh_read:
 
 err_range:
 	affs_error(sb, "affs_free_block","Block %u outside partition", block);
-	return;
 }
 
 /*
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch

