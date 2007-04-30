From: akpm@linux-foundation.org
Subject: - wistron_btns-fix-a-typo-on-the-tm610-definition.patch removed from -mm tree
Date: Mon, 30 Apr 2007 14:44:41 -0700
Message-ID: <200704302144.l3ULif3i015615@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031143AbXD3Vp0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 17:45:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.piel@tremplin-utc.net, dtor@mail.ru, mitr@volny.cz, mm-commits@vger.kernel.org


The patch titled
     wistron_btns: fix a typo on the TM610 definition
has been removed from the -mm tree.  Its filename was
     wistron_btns-fix-a-typo-on-the-tm610-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: wistron_btns: fix a typo on the TM610 definition
From: Eric Piel <eric.piel@tremplin-utc.net>

I did a typo in a previous patch for wistron_btns "add acerhk database". 
This patch fixes this typo that prevented PROG2 key to work.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Miloslav Trmac <mitr@volny.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/wistron_btns.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/misc/wistron_btns.c~wistron_btns-fix-a-typo-on-the-tm610-definition drivers/input/misc/wistron_btns.c
--- a/drivers/input/misc/wistron_btns.c~wistron_btns-fix-a-typo-on-the-tm610-definition
+++ a/drivers/input/misc/wistron_btns.c
@@ -490,7 +490,7 @@ static struct key_entry keymap_acer_trav
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
 	{ KE_KEY, 0x11, {KEY_PROG1} },
-	{ KE_KEY, 0x12, {KEY_PROG3} },
+	{ KE_KEY, 0x12, {KEY_PROG2} },
 	{ KE_KEY, 0x13, {KEY_PROG3} },
 	{ KE_KEY, 0x14, {KEY_MAIL} },
 	{ KE_KEY, 0x15, {KEY_WWW} },
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net are

git-input.patch
wistron_btns-add-led-support.patch
