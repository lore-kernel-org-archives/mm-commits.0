From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-bt8xx-gpio-f-patterns.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:29:07 -0800
Message-ID: <20120111212907.AEF2E10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:36717 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934068Ab2AKV3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:29:08 -0500
Received: by yenm1 with SMTP id m1so7544yen.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:29:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, grant.likely@secretlab.ca, m@bues.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update bt8xx gpio F: patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-bt8xx-gpio-f-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update bt8xx gpio F: patterns

Commit c103de240439d ("gpio: reorganize drivers") renamed the file, update
the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Michael Buesch <m@bues.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-bt8xx-gpio-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-bt8xx-gpio-f-patterns
+++ a/MAINTAINERS
@@ -1618,7 +1618,7 @@ BT8XXGPIO DRIVER
 M:	Michael Buesch <m@bues.ch>
 W:	http://bu3sch.de/btgpio.php
 S:	Maintained
-F:	drivers/gpio/bt8xxgpio.c
+F:	drivers/gpio/gpio-bt8xx.c
 
 BTRFS FILE SYSTEM
 M:	Chris Mason <chris.mason@oracle.com>
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

