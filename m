From: akpm@linux-foundation.org
Subject: [merged] video-includecheck-fix-da8xx-fbc.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:04:57 -0700
Message-ID: <200910092204.n99M4vTD020326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934709AbZJIWGn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:06:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, jaswinderrajput@gmail.com, mm-commits@vger.kernel.org


The patch titled
     video: includecheck fix: da8xx-fb.c
has been removed from the -mm tree.  Its filename was
     video-includecheck-fix-da8xx-fbc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video: includecheck fix: da8xx-fb.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

fix the following 'make includecheck' warning:

  drivers/video/da8xx-fb.c: linux/device.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
xtensa-includecheck-fix-vectorss.patch
sched-fix-htmldocs-schedc.patch

