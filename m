From: akpm@linux-foundation.org
Subject: [merged] maintainers-fix-ssbi-pattern.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:11 -0700
Message-ID: <53ea6e4f.KNd/eM1ptqa1AXN8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:49877 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbaHLTnM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:12 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so1307240qgd.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fix ssbi pattern
has been removed from the -mm tree.  Its filename was
     maintainers-fix-ssbi-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: fix ssbi pattern

Incorrect pattern used, it's not a directory, it's a file.  Fix it.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-ssbi-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-ssbi-pattern
+++ a/MAINTAINERS
@@ -1178,7 +1178,7 @@ F:	drivers/mmc/host/msm_sdcc.h
 F:	drivers/tty/serial/msm_serial.h
 F:	drivers/tty/serial/msm_serial.c
 F:	drivers/*/pm8???-*
-F:	drivers/mfd/ssbi/
+F:	drivers/mfd/ssbi.c
 F:	include/linux/mfd/pm8xxx/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git
 S:	Maintained
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

