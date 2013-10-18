From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-tps65910c-remove-unnecessary-include.patch
 added to -mm tree
Date: Fri, 18 Oct 2013 14:11:36 -0700
Message-ID: <5261a408.jsCniGrNsrOKwIXa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3JRVLh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Oct 2013 17:11:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, badarkhe.manish@gmail.com

Subject: + drivers-rtc-rtc-tps65910c-remove-unnecessary-include.patch added to -mm tree
To: badarkhe.manish@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 18 Oct 2013 14:11:36 -0700


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: remove unnecessary include
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-tps65910c-remove-unnecessary-include.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-tps65910c-remove-unnecessary-include.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-tps65910c-remove-unnecessary-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Manish Badarkhe <badarkhe.manish@gmail.com>
Subject: drivers/rtc/rtc-tps65910.c: remove unnecessary include

Currently, driver includes 'pm_runtime.h' which is not used anywhere in
code hence remove this unnecessory inclusion.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps65910.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-remove-unnecessary-include drivers/rtc/rtc-tps65910.c
--- a/drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-remove-unnecessary-include
+++ a/drivers/rtc/rtc-tps65910.c
@@ -22,7 +22,6 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 #include <linux/platform_device.h>
-#include <linux/pm_runtime.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/tps65910.h>
 
_

Patches currently in -mm which might be from badarkhe.manish@gmail.com are

drivers-rtc-rtc-tps65910c-remove-unnecessary-include.patch

