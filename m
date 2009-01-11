From: akpm@linux-foundation.org
Subject: - i8042-add-blue-fb5601-to-noloop-execption-table.patch removed from -mm tree
Date: Sun, 11 Jan 2009 00:02:36 -0800
Message-ID: <200901110802.n0B82au4007129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183AbZAKIDK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Jan 2009 03:03:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sbader3@googlemail.com, stefan.bader@canonical.com, mm-commits@vger.kernel.org


The patch titled
     i8042: add Blue FB5601 to noloop exception table
has been removed from the -mm tree.  Its filename was
     i8042-add-blue-fb5601-to-noloop-execption-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -151,6 +151,14 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_PRODUCT_VERSION, "01"),
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

