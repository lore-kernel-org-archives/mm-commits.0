From: akpm@linux-foundation.org
Subject: + video-includecheck-fix-da8xx-fbc.patch added to -mm tree
Date: Thu, 24 Sep 2009 15:18:05 -0700
Message-ID: <200909242218.n8OMI5Lj032140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbZIXWTp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 18:19:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, jaswinderrajput@gmail.com


The patch titled
     video: includecheck fix: da8xx-fb.c
has been added to the -mm tree.  Its filename is
     video-includecheck-fix-da8xx-fbc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video: includecheck fix: da8xx-fb.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

fix the following 'make includecheck' warning:

  drivers/video/da8xx-fb.c: linux/device.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/da8xx-fb.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/video/da8xx-fb.c~video-includecheck-fix-da8xx-fbc drivers/video/da8xx-fb.c
--- a/drivers/video/da8xx-fb.c~video-includecheck-fix-da8xx-fbc
+++ a/drivers/video/da8xx-fb.c
@@ -26,7 +26,6 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/uaccess.h>
-#include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/clk.h>
 #include <video/da8xx-fb.h>
_

Patches currently in -mm which might be from jaswinder@kernel.org are

origin.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
mm-includecheck-fix-vmallocc.patch
fs-includecheck-fix-proc-kcorec.patch
video-includecheck-fix-msm-mddic.patch
video-includecheck-fix-da8xx-fbc.patch
mtd-nand-fix-htmldocs-warnings.patch

