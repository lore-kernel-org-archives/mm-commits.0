From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-entry-for-davinci-video-drivers.patch removed from -mm tree
Date: Fri, 30 Nov 2012 13:28:48 -0800
Message-ID: <20121130212849.0E4A720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:61726 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab2K3V2u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 16:28:50 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so64992eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 13:28:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prabhakar.lad@ti.com, manjunath.hadli@ti.com, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add entry for Davinci video drivers
has been removed from the -mm tree.  Its filename was
     maintainers-add-entry-for-davinci-video-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lad, Prabhakar <prabhakar.lad@ti.com>
Subject: MAINTAINERS: add entry for Davinci video drivers

Add an entry in MAINTAINERS file for TI Davinci media drivers.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN MAINTAINERS~maintainers-add-entry-for-davinci-video-drivers MAINTAINERS
--- a/MAINTAINERS~maintainers-add-entry-for-davinci-video-drivers
+++ a/MAINTAINERS
@@ -6627,6 +6627,18 @@ S:	Supported
 F:	arch/arm/mach-davinci
 F:	drivers/i2c/busses/i2c-davinci.c
 
+TI DAVINCI SERIES MEDIA DRIVER
+M:	Manjunath Hadli <manjunath.hadli@ti.com>
+M:	Prabhakar Lad <prabhakar.lad@ti.com>
+L:	linux-media@vger.kernel.org
+L:	davinci-linux-open-source@linux.davincidsp.com (moderated for non-subscribers)
+W:	http://linuxtv.org/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
+S:	Supported
+F:	drivers/media/platform/davinci/
+F:	include/media/davinci/
+
 SIS 190 ETHERNET DRIVER
 M:	Francois Romieu <romieu@fr.zoreil.com>
 L:	netdev@vger.kernel.org
_

Patches currently in -mm which might be from prabhakar.lad@ti.com are

linux-next.patch

