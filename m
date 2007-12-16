From: akpm@linux-foundation.org
Subject: + ik8-add-dell-uk-6400-inspiron-model-mm061.patch added to -mm tree
Date: Sun, 16 Dec 2007 03:25:30 -0800
Message-ID: <200712161125.lBGBPUXr025466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60221 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932269AbXLPLZe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Dec 2007 06:25:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nick@ukfsn.org


The patch titled
     ik8: add Dell UK 6400 Inspiron model (MM061)
has been added to the -mm tree.  Its filename is
     ik8-add-dell-uk-6400-inspiron-model-mm061.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ik8-add-dell-uk-6400-inspiron-model-mm061.patch
