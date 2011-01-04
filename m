From: akpm@linux-foundation.org
Subject: + maintainers-update-entries-affecting-via-technologies.patch added to -mm tree
Date: Tue, 04 Jan 2011 13:33:08 -0800
Message-ID: <201101042133.p04LX84T025399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383Ab1ADVdY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 16:33:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: BruceChang@via.com.tw, FlorianSchandinat@gmx.de, HaraldWelte@viatech.com, JosephChan@via.com.tw, brucechang@via.com.tw, geert@linux-m68k.org


The patch titled
     MAINTAINERS: update entries affecting VIA Technologies
has been added to the -mm tree.  Its filename is
     maintainers-update-entries-affecting-via-technologies.patch

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
@@ -6506,13 +6506,12 @@ F:	Documentation/i2c/busses/i2c-viapro
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

maintainers-update-entries-affecting-via-technologies.patch

