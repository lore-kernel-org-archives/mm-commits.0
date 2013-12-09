From: akpm@linux-foundation.org
Subject: [merged] drivers-char-i8kc-add-dell-xpls-l421x.patch removed from -mm tree
Date: Mon, 09 Dec 2013 13:53:49 -0800
Message-ID: <52a63bed.8eQxy8ybq1Z0XUdB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022Ab3LIVxu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 16:53:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, leho@kraav.com, greg@kroah.com, alan@linux.intel.com

Subject: [merged] drivers-char-i8kc-add-dell-xpls-l421x.patch removed from -mm tree
To: alan@linux.intel.com,greg@kroah.com,leho@kraav.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 13:53:49 -0800


The patch titled
     Subject: drivers/char/i8k.c: add Dell XPLS L421X
has been removed from the -mm tree.  Its filename was
     drivers-char-i8kc-add-dell-xpls-l421x.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: drivers/char/i8k.c: add Dell XPLS L421X

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=60772

Signed-off-by: Alan Cox <alan@linux.intel.com>
Reported-by: Leho Kraav <leho@kraav.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/i8k.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/char/i8k.c~drivers-char-i8kc-add-dell-xpls-l421x drivers/char/i8k.c
--- a/drivers/char/i8k.c~drivers-char-i8kc-add-dell-xpls-l421x
+++ a/drivers/char/i8k.c
@@ -664,6 +664,13 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro"),
 		},
 	},
+	{
+		.ident = "Dell XPS421",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "XPS L421X"),
+		},
+	},
         { }
 };
 
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch

