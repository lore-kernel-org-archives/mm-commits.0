From: akpm@linux-foundation.org
Subject: + maintainers-remove-alessandro.patch added to -mm tree
Date: Thu, 12 Apr 2012 13:29:22 -0700
Message-ID: <20120412202922.DCA9BA011A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:33522 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965990Ab2DLU3Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Apr 2012 16:29:25 -0400
Received: by eaaq10 with SMTP id q10so108921eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Apr 2012 13:29:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rubini@cvml.unipv.it, rubini@ipvvis.unipv.it


The patch titled
     Subject: MAINTAINERS: remove Alessandro
has been added to the -mm tree.  Its filename is
     maintainers-remove-alessandro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alessandro Rubini <rubini@cvml.unipv.it>
Subject: MAINTAINERS: remove Alessandro

I'm definitely not up to date on the subject matter any more
and haven't been able to comment on the messages on the topic.

Signed-off-by: Alessandro Rubini <rubini@ipvvis.unipv.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ------
 1 file changed, 6 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-alessandro MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-alessandro
+++ a/MAINTAINERS
@@ -4463,12 +4463,6 @@ L:	linux-arm-kernel@lists.infradead.org 
 S:	Maintained
 F:	drivers/mmc/host/imxmmc.*
 
-MOUSE AND MISC DEVICES [GENERAL]
-M:	Alessandro Rubini <rubini@ipvvis.unipv.it>
-S:	Maintained
-F:	drivers/input/mouse/
-F:	include/linux/gpio_mouse.h
