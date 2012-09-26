From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code-fix.patch removed from -mm tree
Date: Wed, 26 Sep 2012 13:55:24 -0700
Message-ID: <20120926205525.25B34100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:37168 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2IZUz0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 16:55:26 -0400
Received: by vcbfy27 with SMTP id fy27so127187vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 13:55:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zonque@gmail.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: lis3: lis3lv02d_spi.c: include linux/of.h
has been removed from the -mm tree.  Its filename was
     drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code-fix.patch

This patch was dropped because it was folded into drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code.patch

------------------------------------------------------
From: Daniel Mack <zonque@gmail.com>
Subject: lis3: lis3lv02d_spi.c: include linux/of.h

This include is needed to define of_match:ptr() for !CONFIG_OF &&
1CONFIG_DTC.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d_spi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/lis3lv02d/lis3lv02d_spi.c~drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code-fix drivers/misc/lis3lv02d/lis3lv02d_spi.c
--- a/drivers/misc/lis3lv02d/lis3lv02d_spi.c~drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code-fix
+++ a/drivers/misc/lis3lv02d/lis3lv02d_spi.c
@@ -17,6 +17,7 @@
 #include <linux/workqueue.h>
 #include <linux/spi/spi.h>
 #include <linux/pm.h>
+#include <linux/of.h>
 #include <linux/of_platform.h>
 
 #include "lis3lv02d.h"
_

Patches currently in -mm which might be from zonque@gmail.com are

linux-next.patch
drivers-misc-lis3lv02d-add-generic-dt-matching-code.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code-fix-fix.patch

