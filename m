From: akpm@linux-foundation.org
Subject: [merged] mb862xxfb-use-config_of-instead-of-config_ppc_of.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:39:29 -0700
Message-ID: <200906171839.n5HIdTi6005460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228AbZFQSkU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:40:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, agust@denx.de, davem@davemloft.net, monstr@monstr.eu, mm-commits@vger.kernel.org


The patch titled
     mb862xxfb: use CONFIG_OF instead of CONFIG_PPC_OF
has been removed from the -mm tree.  Its filename was
     mb862xxfb-use-config_of-instead-of-config_ppc_of.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mb862xxfb: use CONFIG_OF instead of CONFIG_PPC_OF
From: Arnd Bergmann <arnd@arndb.de>

With this change, the driver builds fine on Microblaze, which helps
allyesconfig compile tests.

I did not test sparc, but the change should have the same effect there.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Anatolij Gustschin <agust@denx.de>
Tested-by: Anatolij Gustschin <agust@denx.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mb862xx/mb862xxfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/mb862xx/mb862xxfb.c~mb862xxfb-use-config_of-instead-of-config_ppc_of drivers/video/mb862xx/mb862xxfb.c
--- a/drivers/video/mb862xx/mb862xxfb.c~mb862xxfb-use-config_of-instead-of-config_ppc_of
+++ a/drivers/video/mb862xx/mb862xxfb.c
@@ -19,7 +19,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
-#if defined(CONFIG_PPC_OF)
+#if defined(CONFIG_OF)
 #include <linux/of_platform.h>
 #endif
 #include "mb862xxfb.h"
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
linux-next.patch
ipc-use-__arch_want_ipc_parse_version-in-ipc-utilh.patch
dma-mapping-add-asm-generic-dma-mapping-commonh.patch
dma-mapping-x86-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-add-config_dma_api_debug-support.patch
dma-mapping-dma-debug-fix-compiler-warnings-on-ia64.patch

