From: akpm@linux-foundation.org
Subject: [merged] acerhdf-additional-bios-versions.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:03:43 -0700
Message-ID: <200909232003.n8NK3hfZ019769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753954AbZIWUFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:05:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter@piie.net, andi@lisas.de, lenb@kernel.org, petkovbb@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     acerhdf: additional BIOS versions
has been removed from the -mm tree.  Its filename was
     acerhdf-additional-bios-versions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

