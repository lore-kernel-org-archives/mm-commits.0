From: akpm@linux-foundation.org
Subject: - cell-draw-spe-helper-penguin-logos-update.patch removed from -mm tree
Date: Tue, 17 Jul 2007 01:56:39 -0700
Message-ID: <200707170856.l6H8ueXk008737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47516 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759792AbXGQI5s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 04:57:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, arnd@arndb.de, benh@kernel.crashing.org, geoffrey.levand@am.sony.com, jsimmons@infradead.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Cell: Draw SPE helper penguin logos (update)
has been removed from the -mm tree.  Its filename was
     cell-draw-spe-helper-penguin-logos-update.patch

This patch was dropped because it was folded into cell-draw-spe-helper-penguin-logos.patch

------------------------------------------------------
Subject: Cell: Draw SPE helper penguin logos (update)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

  - Let FB_LOGO_EXTRA default to y if SPU_BASE is enabled

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Acked-By: James Simmons <jsimmons@infradead.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/logo/Kconfig |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/video/logo/Kconfig~cell-draw-spe-helper-penguin-logos-update drivers/video/logo/Kconfig
--- a/drivers/video/logo/Kconfig~cell-draw-spe-helper-penguin-logos-update
+++ a/drivers/video/logo/Kconfig
@@ -13,6 +13,7 @@ if LOGO
 config FB_LOGO_EXTRA
 	bool
 	depends on FB
+	default y if SPU_BASE
 
 config LOGO_LINUX_MONO
 	bool "Standard black and white Linux logo"
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
fbdev-extract-fb_show_logo_line.patch
fbdev-add-fb_append_extra_logo.patch
fbdev-spe-helper-penguin-logo.patch
cell-draw-spe-helper-penguin-logos.patch
cell-draw-spe-helper-penguin-logos-update.patch
