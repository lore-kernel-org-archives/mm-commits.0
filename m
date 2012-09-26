From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-misc-lis3lv02d-add-generic-dt-matching-code-fix.patch removed from -mm tree
Date: Wed, 26 Sep 2012 13:55:01 -0700
Message-ID: <20120926205501.92C2B1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:44229 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab2IZUzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 16:55:03 -0400
Received: by vbis24 with SMTP id s24so127444vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 13:55:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zonque@gmail.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: misc: lis3: fix undefined reference to lis3lv02d_init_dt
has been removed from the -mm tree.  Its filename was
     drivers-misc-lis3lv02d-add-generic-dt-matching-code-fix.patch

This patch was dropped because it was folded into drivers-misc-lis3lv02d-add-generic-dt-matching-code.patch

------------------------------------------------------
From: Daniel Mack <zonque@gmail.com>
Subject: misc: lis3: fix undefined reference to lis3lv02d_init_dt

Export the symbol to fix linker errors.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/lis3lv02d/lis3lv02d.c~drivers-misc-lis3lv02d-add-generic-dt-matching-code-fix drivers/misc/lis3lv02d/lis3lv02d.c
--- a/drivers/misc/lis3lv02d/lis3lv02d.c~drivers-misc-lis3lv02d-add-generic-dt-matching-code-fix
+++ a/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -1089,6 +1089,7 @@ static int lis3lv02d_init_dt(struct lis3
 	return 0;
 }
 #endif
+EXPORT_SYMBOL_GPL(lis3lv02d_init_dt);
 
 /*
  * Initialise the accelerometer and the various subsystems.
_

Patches currently in -mm which might be from zonque@gmail.com are

linux-next.patch
drivers-misc-lis3lv02d-add-generic-dt-matching-code.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code-fix.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code-fix-fix.patch

