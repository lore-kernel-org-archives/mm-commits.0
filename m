From: akpm@linux-foundation.org
Subject: - eeepc-laptop-enable-bluetooth-for-asus-eee-901.patch removed from -mm tree
Date: Mon, 12 Jan 2009 11:58:16 -0800
Message-ID: <200901121958.n0CJwGML027483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755412AbZALUNa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 15:13:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: santiago@crfreenet.org, corentincj@iksaif.net, lenb@kernel.org, mjg59@srcf.ucam.org, mm-commits@vger.kernel.org


The patch titled
     eeepc-laptop: enable Bluetooth for Asus EEE 901
has been removed from the -mm tree.  Its filename was
     eeepc-laptop-enable-bluetooth-for-asus-eee-901.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eeepc-laptop: enable Bluetooth for Asus EEE 901
From: Ondrej Zajicek <santiago@crfreenet.org>

eeepc-laptop driver has interface for enabling/disabling Bluetooth, but it
does not work.  This patch fixes it.

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/eeepc-laptop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/platform/x86/eeepc-laptop.c~eeepc-laptop-enable-bluetooth-for-asus-eee-901 drivers/platform/x86/eeepc-laptop.c
--- a/drivers/platform/x86/eeepc-laptop.c~eeepc-laptop-enable-bluetooth-for-asus-eee-901
+++ a/drivers/platform/x86/eeepc-laptop.c
@@ -90,7 +90,7 @@ enum {
 };
 
 static const char *cm_getv[] = {
-	"WLDG", NULL, NULL, NULL,
+	"WLDG", "BTHG", NULL, NULL,
 	"CAMG", NULL, NULL, NULL,
 	NULL, "PBLG", NULL, NULL,
 	"CFVG", NULL, NULL, NULL,
@@ -99,7 +99,7 @@ static const char *cm_getv[] = {
 };
 
 static const char *cm_setv[] = {
-	"WLDS", NULL, NULL, NULL,
+	"WLDS", "BTHS", NULL, NULL,
 	"CAMS", NULL, NULL, NULL,
 	"SDSP", "PBLS", "HDPS", NULL,
 	"CFVS", NULL, NULL, NULL,
_

Patches currently in -mm which might be from santiago@crfreenet.org are


