From: akpm@linux-foundation.org
Subject: - ps3fb-shrink-default-virtual-frame-buffer-size-from-18-to-9-mib.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:43 -0700
Message-ID: <200707230934.l6N9YhFx016417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759254AbXGWJpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, geoffrey.levand@am.sony.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ps3fb: Shrink default virtual frame buffer size from 18 to 9 MiB
has been removed from the -mm tree.  Its filename was
     ps3fb-shrink-default-virtual-frame-buffer-size-from-18-to-9-mib.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3fb: Shrink default virtual frame buffer size from 18 to 9 MiB
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3fb: Shrink the default virtual frame buffer size from 18 to 9 MiB, as
nobody really uses the double buffering feature and Linux can use an
additional 9 MiB.  It can still be overridden on the kernel command line using
`ps3fb=18M'.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/Kconfig~ps3fb-shrink-default-virtual-frame-buffer-size-from-18-to-9-mib drivers/video/Kconfig
--- a/drivers/video/Kconfig~ps3fb-shrink-default-virtual-frame-buffer-size-from-18-to-9-mib
+++ a/drivers/video/Kconfig
@@ -1803,7 +1803,7 @@ config FB_PS3
 config FB_PS3_DEFAULT_SIZE_M
 	int "PS3 default frame buffer size (in MiB)"
 	depends on FB_PS3
-	default 18
+	default 9
 	---help---
 	  This is the default size (in MiB) of the virtual frame buffer in
 	  the PS3.
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are
