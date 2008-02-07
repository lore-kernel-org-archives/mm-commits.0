From: akpm@linux-foundation.org
Subject: - ik8-add-dell-uk-6400-inspiron-model-mm061.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:29:32 -0800
Message-ID: <200802070029.m170TDMp007257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42467 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934284AbYBGAmF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:42:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nick@ukfsn.org, mm-commits@vger.kernel.org


The patch titled
     ik8: add Dell UK 6400 Inspiron model (MM061)
has been removed from the -mm tree.  Its filename was
     ik8-add-dell-uk-6400-inspiron-model-mm061.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ik8: add Dell UK 6400 Inspiron model (MM061)
From: "Nick Warne" <nick@ukfsn.org>

Add the Dell UK 6400 Inspiron model (MM061) to allow the i8k module to load
correctly without using 'force=1'

Signed-off-by: "Nick Warne" <nick@ukfsn.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/i8k.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/char/i8k.c~ik8-add-dell-uk-6400-inspiron-model-mm061 drivers/char/i8k.c
--- a/drivers/char/i8k.c~ik8-add-dell-uk-6400-inspiron-model-mm061
+++ a/drivers/char/i8k.c
@@ -439,6 +439,13 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude"),
 		},
 	},
+	{	/* UK Inspiron 6400  */
+		.ident = "Dell Inspiron 3",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MM061"),
+		},
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from nick@ukfsn.org are

origin.patch
