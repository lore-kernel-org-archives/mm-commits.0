From: akpm@linux-foundation.org
Subject: + maintainers-update-lguest-f-patterns.patch added to -mm tree
Date: Fri, 20 Jan 2012 14:41:04 -0800
Message-ID: <20120120224105.2EC7C10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:49028 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab2ATWlF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 17:41:05 -0500
Received: by yenr8 with SMTP id r8so93296yen.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 14:41:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, dave@gnu.org


The patch titled
     Subject: MAINTAINERS: update lguest F: patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-lguest-f-patterns.patch

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
Subject: MAINTAINERS: update lguest F: patterns

commit 07fe9977b623 ("lguest: move the lguest tool to the tools
directory") moved the files, update the patterns.  Sort F: patterns
alphabetically too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Davidlohr Bueso <dave@gnu.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-lguest-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-lguest-f-patterns
+++ a/MAINTAINERS
@@ -3972,11 +3972,11 @@ M:	Rusty Russell <rusty@rustcorp.com.au>
 L:	lguest@lists.ozlabs.org
 W:	http://lguest.ozlabs.org/
 S:	Odd Fixes
-F:	Documentation/virtual/lguest/
+F:	arch/x86/include/asm/lguest*.h
 F:	arch/x86/lguest/
 F:	drivers/lguest/
 F:	include/linux/lguest*.h
-F:	arch/x86/include/asm/lguest*.h
+F:	tools/lguest/
 
 LINUX FOR IBM pSERIES (RS/6000)
 M:	Paul Mackerras <paulus@au.ibm.com>
_
Subject: Subject: MAINTAINERS: update lguest F: patterns

Patches currently in -mm which might be from joe@perches.com are

maintainers-update-partitions-block-f-patterns.patch
maintainers-remove-imx5-section.patch
maintainers-remove-staging-sections.patch
maintainers-update-lguest-f-patterns.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch

