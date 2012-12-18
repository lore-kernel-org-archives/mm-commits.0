From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-lp855x-backlight-driver-entry.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:05:52 -0800
Message-ID: <20121218200553.6102320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f201.google.com ([209.85.217.201]:63529 "EHLO
	mail-lb0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2LRUF4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:05:56 -0500
Received: by mail-lb0-f201.google.com with SMTP id m4so69592lbo.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:05:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, milo.kim@ti.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add LP855x backlight driver entry
has been removed from the -mm tree.  Its filename was
     maintainers-add-lp855x-backlight-driver-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: MAINTAINERS: add LP855x backlight driver entry

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-add-lp855x-backlight-driver-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-add-lp855x-backlight-driver-entry
+++ a/MAINTAINERS
@@ -7545,6 +7545,13 @@ S:	Maintained
 F:	sound/soc/codecs/lm49453*
 F:	sound/soc/codecs/isabelle*
 
+TI LP855x BACKLIGHT DRIVER
+M:	Milo Kim <milo.kim@ti.com>
+S:	Maintained
+F:	Documentation/backlight/lp855x-driver.txt
+F:	drivers/video/backlight/lp855x_bl.c
+F:	include/linux/platform_data/lp855x.h
+
 TI TWL4030 SERIES SOC CODEC DRIVER
 M:	Peter Ujfalusi <peter.ujfalusi@ti.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch

