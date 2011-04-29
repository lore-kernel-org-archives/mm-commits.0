From: akpm@linux-foundation.org
Subject: [merged] uml-fix-hppfs-build.patch removed from -mm tree
Date: Fri, 29 Apr 2011 12:46:58 -0700
Message-ID: <201104291941.p3TJfTje011453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760914Ab1D2Tqh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Apr 2011 15:46:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, danner.simon@gmail.com, hch@infradead.org, jdike@addtoit.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     uml: fix hppfs build
has been removed from the -mm tree.  Its filename was
     uml-fix-hppfs-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix hppfs build
From: Randy Dunlap <randy.dunlap@oracle.com>

Make HoneyPot ProcFS depend on CONFIG_PROC_FS so that it will build. 
Recommended by Christoph Hellwig.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=33692

Reported-by: Simon Danner <danner.simon@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.um |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/Kconfig.um~uml-fix-hppfs-build arch/um/Kconfig.um
--- a/arch/um/Kconfig.um~uml-fix-hppfs-build
+++ a/arch/um/Kconfig.um
@@ -47,7 +47,7 @@ config HOSTFS
 
 config HPPFS
 	tristate "HoneyPot ProcFS (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on EXPERIMENTAL && PROC_FS
 	help
 	  hppfs (HoneyPot ProcFS) is a filesystem which allows UML /proc
 	  entries to be overridden, removed, or fabricated from the host.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
drivers-leds-leds-pca9532c-add-gpio-capability.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

