From: akpm@linux-foundation.org
Subject: + viafb-maintainers-entry.patch added to -mm tree
Date: Wed, 27 Aug 2008 20:53:49 -0700
Message-ID: <200808280353.m7S3rnen006028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753932AbYH1DyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 23:54:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JosephChan@via.com.tw, ScottFang@viatech.com.cn, josephchan@via.com.tw


The patch titled
     viafb: MAINTAINERS entry
has been added to the -mm tree.  Its filename is
     viafb-maintainers-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: MAINTAINERS entry
From: <JosephChan@via.com.tw>

Add maintainers for VIA UniChrome(Pro)/Chrome9 Framebuffer driver

Signed-off-by: Joseph Chan <josephchan@via.com.tw>
Signed-off-by: Scott Fang <ScottFang@viatech.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN MAINTAINERS~viafb-maintainers-entry MAINTAINERS
--- a/MAINTAINERS~viafb-maintainers-entry
+++ a/MAINTAINERS
@@ -4485,6 +4485,14 @@ M:	khali@linux-fr.org
 L:	i2c@lm-sensors.org
 S:	Maintained
 
+VIA UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER
+P:	Joseph Chan
+M:	JosephChan@via.com.tw
+P:	Scott Fang
+M:	ScottFang@viatech.com.cn
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+S:	Maintained
+
 VIA VELOCITY NETWORK DRIVER
 P:	Francois Romieu
 M:	romieu@fr.zoreil.com
_

Patches currently in -mm which might be from JosephChan@via.com.tw are

origin.patch
sata_viac-add-support-for-vt8251-fix-the-internal-chips-issue-and.patch
viafb-viafbmodes-viafbtxt.patch
viafb-viafbmodes-viafbtxt-fix.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-makefile-kconfig.patch
viafb-accelc-accelh.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-accelc-accelh-update.patch
viafb-chiph-debugh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-ifacec-ifaceh-ioctlc-ioctlh.patch
viafb-lcdc-lcdh-lcdtblh.patch
viafb-makefile-shareh.patch
viafb-tbl1636c-tbl1636h-tbldpasettingc-tbldpasettingh.patch
viafb-viafbdevc-viafbdevh.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
viafb-viafbdevc-update.patch
viafb-via_i2cc-via_i2ch-viamodec-viamodeh.patch
viafb-via_utilityc-via_utilityh-vt1636c-vt1636h.patch
viafb-maintainers-entry.patch

