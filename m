From: akpm@linux-foundation.org
Subject: + maintainers-remove-staging-sections.patch added to -mm tree
Date: Fri, 20 Jan 2012 14:41:00 -0800
Message-ID: <20120120224101.9C0945C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:33977 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab2ATWlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 17:41:03 -0500
Received: by mail-ee0-f74.google.com with SMTP id b15so40121eek.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 14:41:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, mchehab@redhat.com


The patch titled
     Subject: MAINTAINERS: remove staging sections
has been added to the -mm tree.  Its filename is
     maintainers-remove-staging-sections.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: remove staging sections

Two commits moved files from staging to drivers/media/

commit d6ce55de3abcc ("[media] move cx25821 out of staging")
commit be30497085080 ("[media] move tm6000 to drivers/media/video")

Remove the sections.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 -----
 1 file changed, 5 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-staging-sections MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-staging-sections
+++ a/MAINTAINERS
@@ -6382,11 +6382,6 @@ M:	Omar Ramirez Luna <omar.ramirez@ti.co
 S:	Odd Fixes
 F:	drivers/staging/tidspbridge/
 
-STAGING - TRIDENT TVMASTER TMxxxx USB VIDEO CAPTURE DRIVERS
-L:	linux-media@vger.kernel.org
-S:	Odd Fixes
-F:	drivers/staging/tm6000/
