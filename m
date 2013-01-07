From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-drivers-mmc-host-imxmmc.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:26:40 -0800
Message-ID: <20130107192640.A05AF820059@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:43775 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab3AGT0l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:26:41 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so2114094ggm.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:26:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, pisa@cmp.felk.cvut.cz, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove drivers/mmc/host/imxmmc.*
has been removed from the -mm tree.  Its filename was
     maintainers-remove-drivers-mmc-host-imxmmc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: remove drivers/mmc/host/imxmmc.*

This driver was removed by commit 6187fee ("mmc: remove imxmmc driver").

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ------
 1 file changed, 6 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-drivers-mmc-host-imxmmc MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-drivers-mmc-host-imxmmc
+++ a/MAINTAINERS
@@ -5063,12 +5063,6 @@ F:	Documentation/video4linux/meye.txt
 F:	drivers/media/pci/meye/
 F:	include/uapi/linux/meye.h
 
-MOTOROLA IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
-M:	Pavel Pisa <ppisa@pikron.com>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-F:	drivers/mmc/host/imxmmc.*
