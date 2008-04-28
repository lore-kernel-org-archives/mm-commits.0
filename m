From: akpm@linux-foundation.org
Subject: - bf54x-framebuffer-driver-bf542-does-not-have-eppi0-so-dont-allow-the-lq034-driver-for-now.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:46 -0700
Message-ID: <200804282159.m3SLxkf8018616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965484AbYD1V74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     BF54x Framebuffer Driver: BF542 does not have EPPI0, so dont allow the LQ034 driver for now
has been removed from the -mm tree.  Its filename was
     bf54x-framebuffer-driver-bf542-does-not-have-eppi0-so-dont-allow-the-lq034-driver-for-now.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: BF54x Framebuffer Driver: BF542 does not have EPPI0, so dont allow the LQ034 driver for now
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/Kconfig~bf54x-framebuffer-driver-bf542-does-not-have-eppi0-so-dont-allow-the-lq034-driver-for-now drivers/video/Kconfig
--- a/drivers/video/Kconfig~bf54x-framebuffer-driver-bf542-does-not-have-eppi0-so-dont-allow-the-lq034-driver-for-now
+++ a/drivers/video/Kconfig
@@ -580,7 +580,7 @@ config FB_VGA16
 
 config FB_BF54X_LQ043
 	tristate "SHARP LQ043 TFT LCD (BF548 EZKIT)"
-	depends on FB && (BF54x)
+	depends on FB && (BF54x) && !BF542
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
git-watchdog.patch
procfs-task-exe-symlink-fix-2.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
blackfin-use-kbuildh-instead-of-defining-macros-in-asm-macrosc.patch

