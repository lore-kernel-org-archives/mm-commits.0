From: akpm@linux-foundation.org
Subject: + video-includecheck-fix-msm-mddic.patch added to -mm tree
Date: Thu, 24 Sep 2009 15:17:45 -0700
Message-ID: <200909242217.n8OMHj0h031480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbZIXWTI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 18:19:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, jaswinderrajput@gmail.com


The patch titled
     video: includecheck fix: msm, mddi.c
has been added to the -mm tree.  Its filename is
     video-includecheck-fix-msm-mddic.patch

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
Subject: video: includecheck fix: msm, mddi.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

fix the following 'make includecheck' warning:

  drivers/video/msm/mddi.c: linux/delay.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/msm/mddi.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/msm/mddi.c~video-includecheck-fix-msm-mddic drivers/video/msm/mddi.c
--- a/drivers/video/msm/mddi.c~video-includecheck-fix-msm-mddic
+++ a/drivers/video/msm/mddi.c
@@ -27,8 +27,6 @@
 #include <mach/msm_iomap.h>
 #include <mach/irqs.h>
 #include <mach/board.h>
-#include <linux/delay.h>
