From: akpm@linux-foundation.org
Subject: [merged] video-includecheck-fix-msm-mddic.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:04:55 -0700
Message-ID: <200910092204.n99M4trN020305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934712AbZJIWGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:06:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, jaswinderrajput@gmail.com, mm-commits@vger.kernel.org


The patch titled
     video: includecheck fix: msm, mddi.c
has been removed from the -mm tree.  Its filename was
     video-includecheck-fix-msm-mddic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video: includecheck fix: msm, mddi.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

fix the following 'make includecheck' warning:

  drivers/video/msm/mddi.c: linux/delay.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/video/msm/mddi.c~video-includecheck-fix-msm-mddic drivers/video/msm/mddi.c
--- a/drivers/video/msm/mddi.c~video-includecheck-fix-msm-mddic
+++ a/drivers/video/msm/mddi.c
@@ -27,8 +27,6 @@
 #include <mach/msm_iomap.h>
 #include <mach/irqs.h>
 #include <mach/board.h>
-#include <linux/delay.h>
