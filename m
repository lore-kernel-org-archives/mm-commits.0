From: akpm@linux-foundation.org
Subject: + acerhdf-additional-bios-versions.patch added to -mm tree
Date: Thu, 13 Aug 2009 13:59:55 -0700
Message-ID: <200908132059.n7DKxt9F024706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755068AbZHMVCB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 17:02:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter@piie.net, andi@lisas.de, lenb@kernel.org, petkovbb@googlemail.com


The patch titled
     acerhdf: additional BIOS versions
has been added to the -mm tree.  Its filename is
     acerhdf-additional-bios-versions.patch

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
Subject: acerhdf: additional BIOS versions
From: Peter Feuerer <peter@piie.net>

Added BIOS versions:
Acer: AOA110-v0.3307, AOA150-v0.3301, AOA150-v0.3307
Packard Bell: AOA150-v0.3105

Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Borislav Petkov <petkovbb@googlemail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acerhdf.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/platform/x86/acerhdf.c~acerhdf-additional-bios-versions drivers/platform/x86/acerhdf.c
--- a/drivers/platform/x86/acerhdf.c~acerhdf-additional-bios-versions
+++ a/drivers/platform/x86/acerhdf.c
@@ -139,13 +139,16 @@ static const struct bios_settings_t bios
 	{"Acer", "AOA110", "v0.3301", 0x55, 0x58, {0xaf, 0x00} },
 	{"Acer", "AOA110", "v0.3304", 0x55, 0x58, {0xaf, 0x00} },
 	{"Acer", "AOA110", "v0.3305", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "AOA110", "v0.3307", 0x55, 0x58, {0xaf, 0x00} },
 	{"Acer", "AOA110", "v0.3308", 0x55, 0x58, {0x21, 0x00} },
 	{"Acer", "AOA110", "v0.3309", 0x55, 0x58, {0x21, 0x00} },
 	{"Acer", "AOA110", "v0.3310", 0x55, 0x58, {0x21, 0x00} },
 	/* AOA150 */
 	{"Acer", "AOA150", "v0.3114", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3301", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3304", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3305", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3307", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3308", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3309", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x00} },
@@ -154,6 +157,7 @@ static const struct bios_settings_t bios
 	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x00} },
 	{"Packard Bell", "DOA150", "v0.3104", 0x55, 0x58, {0x21, 0x00} },
 	{"Packard Bell", "AOA110", "v0.3105", 0x55, 0x58, {0x21, 0x00} },
+	{"Packard Bell", "AOA150", "v0.3105", 0x55, 0x58, {0x20, 0x00} },
 	/* pewpew-terminator */
 	{"", "", "", 0, 0, {0, 0} }
 };
_

Patches currently in -mm which might be from peter@piie.net are

acerhdf-fix-fan-control-for-aoa150-model.patch
acerhdf-convert-to-dev_pm_ops.patch
acerhdf-additional-bios-versions.patch

