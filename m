From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-scx200-file-pattern.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:58 -0700
Message-ID: <201103232043.p2NKhYV7028883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933464Ab1CWUoM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update SCX200 file pattern
has been removed from the -mm tree.  Its filename was
     maintainers-update-scx200-file-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update SCX200 file pattern
From: Joe Perches <joe@perches.com>

commit 3b3da9d25ae ("x86: Move scx200 to platform") moved it, convert the
pattern too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-scx200-file-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-update-scx200-file-pattern
+++ a/MAINTAINERS
@@ -5507,7 +5507,7 @@ SCx200 CPU SUPPORT
 M:	Jim Cromie <jim.cromie@gmail.com>
 S:	Odd Fixes
 F:	Documentation/i2c/busses/scx200_acb
-F:	arch/x86/kernel/scx200_32.c
+F:	arch/x86/platform/scx200/
 F:	drivers/watchdog/scx200_wdt.c
 F:	drivers/i2c/busses/scx200*
 F:	drivers/mtd/maps/scx200_docflash.c
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch

