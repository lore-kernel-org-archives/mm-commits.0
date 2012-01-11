From: akpm@linux-foundation.org
Subject: [merged] maintainers-serial-blackfin-update-f-pattern.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:29:32 -0800
Message-ID: <20120111212933.05B5A200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38500 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab2AKV3f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:29:35 -0500
Received: by eekd41 with SMTP id d41so44287eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:29:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, sonic.zhang@analog.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: serial:blackfin: update F: pattern
has been removed from the -mm tree.  Its filename was
     maintainers-serial-blackfin-update-f-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: serial:blackfin: update F: pattern

commit 0c6967b5a0 ("serial:blackfin: rename Blackfin serial driver to
bfin_uart.c") renamed the file, update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-serial-blackfin-update-f-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-serial-blackfin-update-f-pattern
+++ a/MAINTAINERS
@@ -1487,7 +1487,7 @@ M:	Sonic Zhang <sonic.zhang@analog.com>
 L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
-F:	drivers/tty/serial/bfin_5xx.c
+F:	drivers/tty/serial/bfin_uart.c
 
 BLACKFIN WATCHDOG DRIVER
 M:	Mike Frysinger <vapier.adi@gmail.com>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
kernelh-neaten-panic-prototype.patch
linkage-remove-unused-noret_and-macro.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
linkage-remove-unused-attrib_noret-macro.patch

