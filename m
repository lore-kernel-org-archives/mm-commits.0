From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-mfd-f-patterns.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:29:13 -0800
Message-ID: <20120111212913.8C2AF10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:36717 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934068Ab2AKV3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:29:14 -0500
Received: by mail-yx0-f202.google.com with SMTP id m1so7544yen.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:29:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update mfd F: patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-mfd-f-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update mfd F: patterns

commit 8959e74399c ("mfd: Delete ab3550 driver") removed the driver,
update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-mfd-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-mfd-f-patterns
+++ a/MAINTAINERS
@@ -1169,7 +1169,6 @@ L:	linux-arm-kernel@lists.infradead.org 
 S:	Maintained
 F:	arch/arm/mach-ux500/
 F:	drivers/dma/ste_dma40*
-F:	drivers/mfd/ab3550*
 F:	drivers/mfd/abx500*
 F:	drivers/mfd/ab8500*
 F:	drivers/mfd/stmpe*
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

