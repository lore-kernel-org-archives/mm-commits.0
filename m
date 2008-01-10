From: akpm@linux-foundation.org
Subject: - atmel_lcdfb-email-update.patch removed from -mm tree
Date: Wed, 09 Jan 2008 22:34:32 -0800
Message-ID: <200801100634.m0A6YCaj009035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38702 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751620AbYAJGeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 01:34:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_lcdfb: email update
has been removed from the -mm tree.  Its filename was
     atmel_lcdfb-email-update.patch

This patch was dropped because it was folded into maintainers-email-update-and-add-missing-entry.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb: email update
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Module author email update.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-email-update drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-email-update
+++ a/drivers/video/atmel_lcdfb.c
@@ -801,5 +801,5 @@ module_init(atmel_lcdfb_init);
 module_exit(atmel_lcdfb_exit);
 
 MODULE_DESCRIPTION("AT91/AT32 LCD Controller framebuffer driver");
-MODULE_AUTHOR("Nicolas Ferre <nicolas.ferre@rfo.atmel.com>");
+MODULE_AUTHOR("Nicolas Ferre <nicolas.ferre@atmel.com>");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

maintainers-email-update-and-add-missing-entry.patch
atmel_lcdfb-email-update.patch
git-arm.patch
