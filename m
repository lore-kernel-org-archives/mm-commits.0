From: akpm@linux-foundation.org
Subject: + acerhdf-add-ao531-and-many-bios-versions-for-1410-1810xx-and-packard-bell-netbooks.patch added to -mm tree
Date: Mon, 21 Jun 2010 14:56:10 -0700
Message-ID: <201006212156.o5LLuAT4007213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932318Ab0FUV47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jun 2010 17:56:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter@piie.net, andi@lisas.de, lenb@kernel.org, mjg@redhat.com, petkovbb@gmail.com


The patch titled
     acerhdf: add AO531 and many BIOS versions for 1410, 1810xx and packard bell netbooks
has been added to the -mm tree.  Its filename is
     acerhdf-add-ao531-and-many-bios-versions-for-1410-1810xx-and-packard-bell-netbooks.patch

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
Subject: acerhdf: add AO531 and many BIOS versions for 1410, 1810xx and packard bell netbooks
From: Peter Feuerer <peter@piie.net>

Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acerhdf.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff -puN drivers/platform/x86/acerhdf.c~acerhdf-add-ao531-and-many-bios-versions-for-1410-1810xx-and-packard-bell-netbooks drivers/platform/x86/acerhdf.c
--- a/drivers/platform/x86/acerhdf.c~acerhdf-add-ao531-and-many-bios-versions-for-1410-1810xx-and-packard-bell-netbooks
+++ a/drivers/platform/x86/acerhdf.c
@@ -52,7 +52,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define DRV_VER "0.5.23"
+#define DRV_VER "0.5.24"
 
 /*
  * According to the Atom N270 datasheet,
@@ -153,12 +153,25 @@ static const struct bios_settings_t bios
 	{"Acer", "AOA150", "v0.3309", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x00} },
 	/* Acer 1410 */
+	{"Acer", "Aspire 1410", "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1410", "v0.3113", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1410", "v0.3115", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1410", "v0.3117", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1410", "v0.3119", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1410", "v0.3120", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1410", "v1.3204", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1410", "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1410", "v1.3308", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1410", "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
 	/* Acer 1810xx */
+	{"Acer", "Aspire 1810TZ", "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v0.3113", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v0.3113", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810TZ", "v0.3115", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810T",  "v0.3115", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v0.3117", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v0.3117", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810TZ", "v0.3119", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810T",  "v0.3119", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810TZ", "v0.3120", 0x55, 0x58, {0x9e, 0x00} },
@@ -167,6 +180,12 @@ static const struct bios_settings_t bios
 	{"Acer", "Aspire 1810T",  "v1.3204", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810TZ", "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810T",  "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v1.3308", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v1.3308", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
+	/* Acer 531 */
+	{"Acer", "AO531h", "v0.3201", 0x55, 0x58, {0x20, 0x00} },
 	/* Gateway */
 	{"Gateway", "AOA110", "v0.3103", 0x55, 0x58, {0x21, 0x00} },
 	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x00} },
@@ -180,7 +199,14 @@ static const struct bios_settings_t bios
 	{"Packard Bell", "AOA150", "v0.3105", 0x55, 0x58, {0x20, 0x00} },
 	{"Packard Bell", "DOTMU",  "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
 	{"Packard Bell", "DOTMU",  "v0.3120", 0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",  "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",  "v0.3113", 0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",  "v0.3115", 0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",  "v0.3117", 0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",  "v0.3119", 0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",  "v1.3204", 0x55, 0x58, {0x9e, 0x00} },
 	{"Packard Bell", "DOTMA",  "v1.3201", 0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMA",  "v1.3302", 0x55, 0x58, {0x9e, 0x00} },
 	/* pewpew-terminator */
 	{"", "", "", 0, 0, {0, 0} }
 };
@@ -672,6 +698,7 @@ MODULE_DESCRIPTION("Aspire One temperatu
 MODULE_ALIAS("dmi:*:*Acer*:pnAOA*:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAspire 1410*:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAspire 1810*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAO531*:");
 MODULE_ALIAS("dmi:*:*Gateway*:pnAOA*:");
 MODULE_ALIAS("dmi:*:*Gateway*:pnLT31*:");
 MODULE_ALIAS("dmi:*:*Packard Bell*:pnAOA*:");
_

Patches currently in -mm which might be from peter@piie.net are

acerhdf-add-new-bios-versions.patch
acerhdf-remove-chk_off-as-it-was-only-needed-for-t31-netbooks.patch
acerhdf-driver-didnt-verify-the-pointers-in-which-it-got-product-information.patch
acerhdf-add-ao531-and-many-bios-versions-for-1410-1810xx-and-packard-bell-netbooks.patch

