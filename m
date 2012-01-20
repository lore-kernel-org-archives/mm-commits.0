From: akpm@linux-foundation.org
Subject: + maintainers-fix-remoteproc-f-typo.patch added to -mm tree
Date: Fri, 20 Jan 2012 14:41:49 -0800
Message-ID: <20120120224150.003155C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:42061 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab2ATWlw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 17:41:52 -0500
Received: by eekb15 with SMTP id b15so40137eek.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 14:41:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, ohad@wizery.com


The patch titled
     Subject: MAINTAINERS: fix REMOTEPROC F: typo
has been added to the -mm tree.  Its filename is
     maintainers-fix-remoteproc-f-typo.patch

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
Subject: MAINTAINERS: fix REMOTEPROC F: typo

remoteproc.txt should have been .h

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-remoteproc-f-typo MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-remoteproc-f-typo
+++ a/MAINTAINERS
@@ -5562,7 +5562,7 @@ M:	Ohad Ben-Cohen <ohad@wizery.com>
 S:	Maintained
 F:	drivers/remoteproc/
 F:	Documentation/remoteproc.txt
-F:	include/linux/remoteproc.txt
+F:	include/linux/remoteproc.h
 
 RFKILL
 M:	Johannes Berg <johannes@sipsolutions.net>
_
Subject: Subject: MAINTAINERS: fix REMOTEPROC F: typo

Patches currently in -mm which might be from joe@perches.com are

maintainers-update-partitions-block-f-patterns.patch
maintainers-remove-imx5-section.patch
maintainers-remove-staging-sections.patch
maintainers-update-lguest-f-patterns.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
maintainers-fix-remoteproc-f-typo.patch

