From: akpm@linux-foundation.org
Subject: [merged] acerhdf-add-support-for-aspire-1410-bios-v13314.patch removed from -mm tree
Date: Fri, 27 Apr 2012 12:35:16 -0700
Message-ID: <20120427193516.78E29A02CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:61838 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760569Ab2D0TfR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 15:35:17 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so121090qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 12:35:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: claycarpenter@gmail.com, mjg@redhat.com, peter@piie.net, mm-commits@vger.kernel.org


The patch titled
     Subject: acerhdf: add support for Aspire 1410 BIOS v1.3314
has been removed from the -mm tree.  Its filename was
     acerhdf-add-support-for-aspire-1410-bios-v13314.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Clay Carpenter <claycarpenter@gmail.com>
Subject: acerhdf: add support for Aspire 1410 BIOS v1.3314

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
@@ -161,6 +161,7 @@ static const struct bios_settings_t bios
 	{"Acer", "Aspire 1410", "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1410", "v1.3308", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1410", "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1410", "v1.3314", 0x55, 0x58, {0x9e, 0x00} },
 	/* Acer 1810xx */
 	{"Acer", "Aspire 1810TZ", "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810T",  "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
_

Patches currently in -mm which might be from claycarpenter@gmail.com are

origin.patch

