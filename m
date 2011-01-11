From: akpm@linux-foundation.org
Subject: + memstick-add-support-for-legacy-memorysticks-update.patch added to -mm tree
Date: Tue, 11 Jan 2011 15:44:23 -0800
Message-ID: <201101112344.p0BNiNpU013661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756043Ab1AKXoZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Jan 2011 18:44:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, oakad@yahoo.com


The patch titled
     memstick-add-support-for-legacy-memorysticks-update
has been added to the -mm tree.  Its filename is
     memstick-add-support-for-legacy-memorysticks-update.patch

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
Subject: memstick-add-support-for-legacy-memorysticks-update
From: Maxim Levitsky <maximlevitsky@gmail.com>

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/ms_block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/memstick/core/ms_block.c~memstick-add-support-for-legacy-memorysticks-update drivers/memstick/core/ms_block.c
--- a/drivers/memstick/core/ms_block.c~memstick-add-support-for-legacy-memorysticks-update
+++ a/drivers/memstick/core/ms_block.c
@@ -1354,7 +1354,7 @@ static int msb_ftl_scan(struct msb_data 
 			continue;
 		}
 
-		ms_printk("collision between blocks %d and %d with"
+		ms_printk("collision between blocks %d and %d,"
 		" without stable flag set on both, erasing pba %d",
 				pba, other_block, other_block);
 
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

origin.patch
memstick-core-fix-device_register-error-handling.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
memstick-add-support-for-mspro-specific-data-transfer-method.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader.patch
memstick-add-support-for-legacy-memorysticks.patch
memstick-add-support-for-legacy-memorysticks-update.patch
memstick-add-alex-dubov-to-maintainers-of-the-memstick-core.patch

