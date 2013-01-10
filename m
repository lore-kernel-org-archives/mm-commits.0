From: akpm@linux-foundation.org
Subject: + maintainers-fix-a-status-pattern.patch added to -mm tree
Date: Thu, 10 Jan 2013 13:47:11 -0800
Message-ID: <20130110214712.19AF720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f201.google.com ([74.125.82.201]:64270 "EHLO
	mail-we0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab3AJVrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Jan 2013 16:47:14 -0500
Received: by mail-we0-f201.google.com with SMTP id t11so67316wey.2
        for <mm-commits@vger.kernel.org>; Thu, 10 Jan 2013 13:47:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: MAINTAINERS: fix a status pattern
has been added to the -mm tree.  Its filename is
     maintainers-fix-a-status-pattern.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: MAINTAINERS: fix a status pattern

Change MAINTAINED to Maintained.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-a-status-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-a-status-pattern
+++ a/MAINTAINERS
@@ -668,7 +668,7 @@ F:	arch/arm/
 
 ARM SUB-ARCHITECTURES
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	MAINTAINED
+S:	Maintained
 F:	arch/arm/mach-*/
 F:	arch/arm/plat-*/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

maintainers-fix-arch-arm-plat-omap-include-plat-omap_hwmodh.patch
maintainers-fix-a-status-pattern.patch

