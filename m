From: akpm@linux-foundation.org
Subject: + acerhdf-add-support-for-aspire-1410-bios-v13314.patch added to -mm tree
Date: Tue, 16 Nov 2010 16:21:12 -0800
Message-ID: <201011170021.oAH0LCd3016604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756972Ab0KQAV5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 19:21:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: claycarpenter@gmail.com, mjg@redhat.com, peter@piie.net


The patch titled
     acerhdf: add support for Aspire 1410 BIOS v1.3314
has been added to the -mm tree.  Its filename is
     acerhdf-add-support-for-aspire-1410-bios-v13314.patch

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
Subject: acerhdf: add support for Aspire 1410 BIOS v1.3314
From: Clay Carpenter <claycarpenter@gmail.com>

Add support for Aspire 1410 BIOS v1.3314.  Fixes the following error:

acerhdf: unknown (unsupported) BIOS version Acer/Aspire 1410/v1.3314,
please report, aborting!

Signed-off-by: Clay Carpenter <claycarpenter@gmail.com>
Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acerhdf.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/platform/x86/acerhdf.c~acerhdf-add-support-for-aspire-1410-bios-v13314 drivers/platform/x86/acerhdf.c
--- a/drivers/platform/x86/acerhdf.c~acerhdf-add-support-for-aspire-1410-bios-v13314
+++ a/drivers/platform/x86/acerhdf.c
@@ -163,6 +163,7 @@ static const struct bios_settings_t bios
 	{"Acer", "Aspire 1410", "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1410", "v1.3308", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1410", "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1410", "v1.3314", 0x55, 0x58, {0x9e, 0x00} },
 	/* Acer 1810xx */
 	{"Acer", "Aspire 1810TZ", "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810T",  "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
_

Patches currently in -mm which might be from claycarpenter@gmail.com are

acerhdf-add-support-for-aspire-1410-bios-v13314.patch

