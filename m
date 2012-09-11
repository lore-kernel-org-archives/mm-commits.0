From: akpm@linux-foundation.org
Subject: + drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code-fix.patch added to -mm tree
Date: Tue, 11 Sep 2012 15:20:12 -0700
Message-ID: <20120911222012.9A23C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:63971 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2IKWUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 18:20:13 -0400
Received: by qafl39 with SMTP id l39so128484qaf.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 15:20:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zonque@gmail.com, rdunlap@xenotime.net


The patch titled
     Subject: lis3: lis3lv02d_spi.c: include linux/of.h
has been added to the -mm tree.  Its filename is
     drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code-fix.patch

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

origin.patch
linux-next.patch
drivers-misc-lis3lv02d-add-generic-dt-matching-code.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code-fix.patch

