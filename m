From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-entries-affecting-via-technologies.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:07 -0800
Message-ID: <201101142246.p0EMkwTP004942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab1ANWrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:47:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: BruceChang@via.com.tw, FlorianSchandinat@gmx.de, HaraldWelte@viatech.com, JosephChan@via.com.tw, brucechang@via.com.tw, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update entries affecting VIA Technologies
has been removed from the -mm tree.  Its filename was
     maintainers-update-entries-affecting-via-technologies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update entries affecting VIA Technologies
From: Bruce Chang <BruceChang@via.com.tw>

Since the original maintainer-Joseph Chan (josephchan@via.com.tw) doesn't
handle the Linux driver for VIA now, I would like to request to update the
maintainer for the SD/MMC CARD CONTROLLER DRIVER and VIA
UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER before we find a better one. 

Signed-off-by: Bruce Chang <brucechang@via.com.tw>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-entries-affecting-via-technologies MAINTAINERS
--- a/MAINTAINERS~maintainers-update-entries-affecting-via-technologies
+++ a/MAINTAINERS
@@ -6592,13 +6592,12 @@ F:	Documentation/i2c/busses/i2c-viapro
 F:	drivers/i2c/busses/i2c-viapro.c
 
 VIA SD/MMC CARD CONTROLLER DRIVER
-M:	Joseph Chan <JosephChan@via.com.tw>
+M:	Bruce Chang <brucechang@via.com.tw>
 M:	Harald Welte <HaraldWelte@viatech.com>
 S:	Maintained
 F:	drivers/mmc/host/via-sdmmc.c
 
 VIA UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER
-M:	Joseph Chan <JosephChan@via.com.tw>
 M:	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
 L:	linux-fbdev@vger.kernel.org
 S:	Maintained
_

Patches currently in -mm which might be from BruceChang@via.com.tw are

origin.patch

