From: akpm@linux-foundation.org
Subject: + maintainers-add-entry-for-davinci-video-drivers.patch added to -mm tree
Date: Mon, 19 Nov 2012 13:36:56 -0800
Message-ID: <20121119213657.1057E200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:60113 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab2KSVg7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 16:36:59 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so216516bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 13:36:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: prabhakar.lad@ti.com, manjunath.hadli@ti.com, mchehab@redhat.com


The patch titled
     Subject: MAINTAINERS: add entry for Davinci video drivers
has been added to the -mm tree.  Its filename is
     maintainers-add-entry-for-davinci-video-drivers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

maintainers-add-entry-for-davinci-video-drivers.patch

