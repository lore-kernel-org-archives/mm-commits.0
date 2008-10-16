From: akpm@linux-foundation.org
Subject: + i8042-add-blue-fb5601-to-noloop-execption-table.patch added to -mm tree
Date: Thu, 16 Oct 2008 14:39:01 -0700
Message-ID: <200810162139.m9GLd1lC024435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972AbYJPVjG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 17:39:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sbader3@googlemail.com, stefan.bader@canonical.com


The patch titled
     i8042: add Blue FB5601 to noloop exception table
has been added to the -mm tree.  Its filename is
     i8042-add-blue-fb5601-to-noloop-execption-table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i8042: add Blue FB5601 to noloop exception table
From: "Stefan Bader" <sbader3@googlemail.com>

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042-x86ia64io.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/input/serio/i8042-x86ia64io.h~i8042-add-blue-fb5601-to-noloop-execption-table drivers/input/serio/i8042-x86ia64io.h
--- a/drivers/input/serio/i8042-x86ia64io.h~i8042-add-blue-fb5601-to-noloop-execption-table
+++ a/drivers/input/serio/i8042-x86ia64io.h
@@ -135,6 +135,14 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_PRODUCT_VERSION, "5a"),
 		},
 	},
+	{
+		.ident = "Blue FB5601",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "blue"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "FB5601"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "M606"),
+		},
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from sbader3@googlemail.com are

i8042-add-blue-fb5601-to-noloop-execption-table.patch

