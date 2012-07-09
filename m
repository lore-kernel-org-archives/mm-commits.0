From: akpm@linux-foundation.org
Subject: + rtc-rtc-s3c-replace-include-header-files-from-asm-to-linux.patch added to -mm tree
Date: Mon, 09 Jul 2012 16:31:12 -0700
Message-ID: <20120709233113.279415C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:44168 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2GIXbP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2012 19:31:15 -0400
Received: by wibhr14 with SMTP id hr14so182619wib.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jul 2012 16:31:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: replace #include header files from asm/* to linux/*
has been added to the -mm tree.  Its filename is
     rtc-rtc-s3c-replace-include-header-files-from-asm-to-linux.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-s3c.c: replace #include header files from asm/* to linux/*

Fixes the following checkpatch warnings:
WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
WARNING: Use #include <linux/io.h> instead of <asm/io.h>

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-replace-include-header-files-from-asm-to-linux drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-replace-include-header-files-from-asm-to-linux
+++ a/drivers/rtc/rtc-s3c.c
@@ -26,10 +26,10 @@
 #include <linux/log2.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #include <mach/hardware.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
 #include <asm/irq.h>
 #include <plat/regs-rtc.h>
 
_
Subject: Subject: drivers/rtc/rtc-s3c.c: replace #include header files from asm/* to linux/*

Patches currently in -mm which might be from sachin.kamat@linaro.org are

linux-next.patch
rtc-rtc-s3c-replace-include-header-files-from-asm-to-linux.patch

