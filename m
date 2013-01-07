From: akpm@linux-foundation.org
Subject: [merged] maintainers-fix-drivers-media-platform-atmel-isic.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:26:09 -0800
Message-ID: <20130107192609.A6B8F100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:40605 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab3AGT0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:26:10 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so2114166vcd.1
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:26:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, josh.wu@atmel.com, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fix drivers/media/platform/atmel-isi.c
has been removed from the -mm tree.  Its filename was
     maintainers-fix-drivers-media-platform-atmel-isic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: fix drivers/media/platform/atmel-isi.c

This file was moved to drivers/media/platform/soc_camera/atmel-isi.c by
commit b47ff4a ("[media] move soc_camera to its own directory").

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Josh Wu <josh.wu@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-drivers-media-platform-atmel-isic MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-drivers-media-platform-atmel-isic
+++ a/MAINTAINERS
@@ -1408,7 +1408,7 @@ ATMEL ISI DRIVER
 M:	Josh Wu <josh.wu@atmel.com>
 L:	linux-media@vger.kernel.org
 S:	Supported
-F:	drivers/media/platform/atmel-isi.c
+F:	drivers/media/platform/soc_camera/atmel-isi.c
 F:	include/media/atmel-isi.h
 
 ATMEL LCDFB DRIVER
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
linux-next.patch

