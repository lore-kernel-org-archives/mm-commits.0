From: akpm@linux-foundation.org
Subject: + drivers-char-i8kc-add-dell-xpls-l421x.patch added to -mm tree
Date: Tue, 03 Dec 2013 13:56:56 -0800
Message-ID: <529e53a8.xTHa+yWkud6QPAdK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54663 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab3LCV45 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 16:56:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, leho@kraav.com, greg@kroah.com, alan@linux.intel.com

Subject: + drivers-char-i8kc-add-dell-xpls-l421x.patch added to -mm tree
To: alan@linux.intel.com,greg@kroah.com,leho@kraav.com
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 13:56:56 -0800


The patch titled
     Subject: drivers/char/i8k.c: add Dell XPLS L421X
has been added to the -mm tree.  Its filename is
     drivers-char-i8kc-add-dell-xpls-l421x.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-char-i8kc-add-dell-xpls-l421x.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-char-i8kc-add-dell-xpls-l421x.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
drivers-char-i8kc-add-dell-xpls-l421x.patch

