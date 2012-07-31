From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-s3c-replace-include-header-files-from-asm-to-linux.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:52:34 -0700
Message-ID: <20120731185235.159F05C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:37887 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab2GaSwg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:52:36 -0400
Received: by eekd4 with SMTP id d4so295599eek.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:52:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: replace #include header files from asm/* to linux/*
has been removed from the -mm tree.  Its filename was
     rtc-rtc-s3c-replace-include-header-files-from-asm-to-linux.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch

