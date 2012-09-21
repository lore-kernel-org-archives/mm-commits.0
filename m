From: akpm@linux-foundation.org
Subject: + drivers-misc-lis3lv02d-add-generic-dt-matching-code-fix.patch added to -mm tree
Date: Fri, 21 Sep 2012 14:39:04 -0700
Message-ID: <20120921213905.24EDF100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:63820 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087Ab2IUVjG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Sep 2012 17:39:06 -0400
Received: by yenr11 with SMTP id r11so123229yen.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Sep 2012 14:39:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zonque@gmail.com, rdunlap@xenotime.net


The patch titled
     Subject: misc: lis3: fix undefined reference to lis3lv02d_init_dt
has been added to the -mm tree.  Its filename is
     drivers-misc-lis3lv02d-add-generic-dt-matching-code-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-misc-lis3lv02d-add-generic-dt-matching-code-fix.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code-fix.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code-fix-fix.patch

