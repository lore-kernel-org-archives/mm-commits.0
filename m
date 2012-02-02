From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-max8925c-fix-max8925_rtc_read_alarm-return-value-error.patch added to -mm tree
Date: Wed, 01 Feb 2012 16:05:04 -0800
Message-ID: <20120202000505.2D6ACA0110@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:51457 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab2BBAFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 19:05:06 -0500
Received: by qcsp5 with SMTP id p5so227709qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 16:05:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kliu5@marvell.com, a.zummo@towertech.it, haojian.zhuang@marvell.com


The patch titled
     Subject: drivers/rtc/rtc-max8925.c: fix max8925_rtc_read_alarm() return value error
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-max8925c-fix-max8925_rtc_read_alarm-return-value-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kevin Liu <kliu5@marvell.com>
Subject: drivers/rtc/rtc-max8925.c: fix max8925_rtc_read_alarm() return value error

max8925_rtc_read_alarm should always return 0 with success

Signed-off-by: Kevin Liu <kliu5@marvell.com>
Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max8925.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-max8925.c~drivers-rtc-rtc-max8925c-fix-max8925_rtc_read_alarm-return-value-error drivers/rtc/rtc-max8925.c
--- a/drivers/rtc/rtc-max8925.c~drivers-rtc-rtc-max8925c-fix-max8925_rtc_read_alarm-return-value-error
+++ a/drivers/rtc/rtc-max8925.c
@@ -204,6 +204,7 @@ static int max8925_rtc_read_alarm(struct
 		alrm->pending = 1;
 	else
 		alrm->pending = 0;
+	return 0;
 out:
 	return ret;
 }
_
Subject: Subject: drivers/rtc/rtc-max8925.c: fix max8925_rtc_read_alarm() return value error

Patches currently in -mm which might be from kliu5@marvell.com are

drivers-rtc-rtc-max8925c-fix-max8925_rtc_read_alarm-return-value-error.patch
drivers-rtc-rtc-max8925c-fix-alarm-enabled-mistake-in-max8925_rtc_read_alarm-max8925_rtc_set_alarm.patch

