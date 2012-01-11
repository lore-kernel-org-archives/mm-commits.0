From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-sdhci-f-patterns.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:29:16 -0800
Message-ID: <20120111212916.A87511E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:48989 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934068Ab2AKV3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:29:17 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so134376ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:29:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, cbouatmailru@gmail.com, cjb@laptop.org, shawn.guo@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update sdhci F: patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-sdhci-f-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update sdhci F: patterns

commit 38576af1f8c ("mmc: sdhci: make sdhci-of device drivers self
registered") moved the files around.  Update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Chris Ball <cjb@laptop.org>
Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-sdhci-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-sdhci-f-patterns
+++ a/MAINTAINERS
@@ -5791,13 +5791,14 @@ L:	linux-mmc@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git
 S:	Maintained
 F:	drivers/mmc/host/sdhci.*
+F:	drivers/mmc/host/sdhci-pltfm.[ch]
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE, OPEN FIRMWARE BINDINGS (SDHCI-OF)
 M:	Anton Vorontsov <avorontsov@ru.mvista.com>
 L:	linuxppc-dev@lists.ozlabs.org
 L:	linux-mmc@vger.kernel.org
 S:	Maintained
-F:	drivers/mmc/host/sdhci-of.*
+F:	drivers/mmc/host/sdhci-pltfm.[ch]
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) SAMSUNG DRIVER
 M:	Ben Dooks <ben-linux@fluff.org>
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

