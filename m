From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-s-maintained-to-clkdev-and-clk-sections.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:46 -0700
Message-ID: <20120326192846.610E4A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:39289 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2CZT2r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:47 -0400
Received: by mail-wi0-f202.google.com with SMTP id hj13so233174wib.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add "S: Maintained" to clkdev and clk sections
has been removed from the -mm tree.  Its filename was
     maintainers-add-s-maintained-to-clkdev-and-clk-sections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: add "S: Maintained" to clkdev and clk sections

Russell King seems to be maintaining these.  Might as well mark them with
the appropriate S: entry

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~maintainers-add-s-maintained-to-clkdev-and-clk-sections MAINTAINERS
--- a/MAINTAINERS~maintainers-add-s-maintained-to-clkdev-and-clk-sections
+++ a/MAINTAINERS
@@ -716,6 +716,7 @@ S:	Maintained
 ARM/CLKDEV SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
 F:	arch/arm/include/asm/clkdev.h
 F:	drivers/clk/clkdev.c
 
@@ -1842,6 +1843,7 @@ F:	include/linux/cleancache.h
 
 CLK API
 M:	Russell King <linux@arm.linux.org.uk>
+S:	Maintained
 F:	include/linux/clk.h
 
 CISCO FCOE HBA DRIVER
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fix-remoteproc-f-typo.patch
checkpatch-suggest-pr_level-over-printkkern_level.patch

