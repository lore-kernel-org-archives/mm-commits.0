From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-nomadik-patterns.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:44:17 -0700
Message-ID: <53ea6e91.+YhNa9nS0SiO0diq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f202.google.com ([209.85.160.202]:38139 "EHLO
	mail-yk0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbaHLToS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:44:18 -0400
Received: by mail-yk0-f202.google.com with SMTP id q9so1309394ykb.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:44:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, linus.walleij@linaro.org, rubini@unipv.it, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update nomadik patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-nomadik-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update nomadik patterns

commit 3a19805920f1 ("pinctrl: nomadik: move all Nomadik drivers to subdir")
move the files, update the patterns

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Rubini <rubini@unipv.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-nomadik-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-nomadik-patterns
+++ a/MAINTAINERS
@@ -1157,6 +1157,7 @@ M:	Linus Walleij <linus.walleij@linaro.o
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-nomadik/
+F:	drivers/pinctrl/nomadik/
 F:	drivers/i2c/busses/i2c-nomadik.c
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-nomadik.git
 
@@ -1434,7 +1435,8 @@ F:	drivers/mfd/abx500*
 F:	drivers/mfd/ab8500*
 F:	drivers/mfd/dbx500*
 F:	drivers/mfd/db8500*
-F:	drivers/pinctrl/pinctrl-nomadik*
+F:	drivers/pinctrl/nomadik/pinctrl-ab*
+F:	drivers/pinctrl/nomadik/pinctrl-nomadik*
 F:	drivers/rtc/rtc-ab8500.c
 F:	drivers/rtc/rtc-pl031.c
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

