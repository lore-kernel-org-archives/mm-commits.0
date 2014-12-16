From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 16 Dec 2014 13:38:38 -0800
Message-ID: <5490a65e.Rsod/Fl7hEh563ya%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaLPVij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Dec 2014 16:38:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/serial/pl011.txt |    8 --------
 drivers/Makefile                                   |    3 ---
 drivers/mtd/devices/docg3.c                        |    3 ---
 drivers/watchdog/imx2_wdt.c                        |    3 ---
 init/main.c                                        |    3 ---
 5 files changed, 20 deletions(-)

diff -puN Documentation/devicetree/bindings/serial/pl011.txt~linux-next-git-rejects Documentation/devicetree/bindings/serial/pl011.txt
--- a/Documentation/devicetree/bindings/serial/pl011.txt~linux-next-git-rejects
+++ a/Documentation/devicetree/bindings/serial/pl011.txt
@@ -27,7 +27,6 @@ Optional properties:
 	   When present, may have one or two dma channels.
 	   The first one must be named "rx", the second one
 	   must be named "tx".
-<<<<<<< HEAD
 - auto-poll:
 	   Enables polling when using RX DMA.
 - poll-rate-ms:
@@ -36,13 +35,6 @@ Optional properties:
 - poll-timeout-ms:
 	   Poll timeout when auto-poll is set, default
 	   3000ms.
-=======
-- auto-poll:		Enables polling when using RX DMA.
-- poll-rate-ms:		Rate at which poll occurs when auto-poll is set,
-			default 100ms.
-- poll-timeout-ms:	Poll timeout when auto-poll is set, default
-			3000ms.
->>>>>>> linux-next/akpm-base
 
 See also bindings/arm/primecell.txt
 
diff -puN drivers/Makefile~linux-next-git-rejects drivers/Makefile
--- a/drivers/Makefile~linux-next-git-rejects
+++ a/drivers/Makefile
@@ -161,8 +161,5 @@ obj-$(CONFIG_POWERCAP)		+= powercap/
 obj-$(CONFIG_MCB)		+= mcb/
 obj-$(CONFIG_RAS)		+= ras/
 obj-$(CONFIG_THUNDERBOLT)	+= thunderbolt/
-<<<<<<< HEAD
-=======
 obj-$(CONFIG_ANDROID)		+= android/
->>>>>>> linux-next/akpm-base
 obj-$(CONFIG_CORESIGHT)		+= coresight/
diff -puN drivers/mtd/devices/docg3.c~linux-next-git-rejects drivers/mtd/devices/docg3.c
--- a/drivers/mtd/devices/docg3.c~linux-next-git-rejects
+++ a/drivers/mtd/devices/docg3.c
@@ -2130,10 +2130,7 @@ MODULE_DEVICE_TABLE(of, docg3_dt_ids);
 static struct platform_driver g3_driver = {
 	.driver		= {
 		.name	= "docg3",
-<<<<<<< HEAD
-=======
 		.of_match_table = of_match_ptr(docg3_dt_ids),
->>>>>>> linux-next/akpm-base
 	},
 	.suspend	= docg3_suspend,
 	.resume		= docg3_resume,
diff -puN drivers/watchdog/imx2_wdt.c~linux-next-git-rejects drivers/watchdog/imx2_wdt.c
--- a/drivers/watchdog/imx2_wdt.c~linux-next-git-rejects
+++ a/drivers/watchdog/imx2_wdt.c
@@ -383,10 +383,7 @@ static struct platform_driver imx2_wdt_d
 	.shutdown	= imx2_wdt_shutdown,
 	.driver		= {
 		.name	= DRIVER_NAME,
-<<<<<<< HEAD
-=======
 		.pm     = &imx2_wdt_pm_ops,
->>>>>>> linux-next/akpm-base
 		.of_match_table = imx2_wdt_dt_ids,
 	},
 };
diff -puN init/main.c~linux-next-git-rejects init/main.c
--- a/init/main.c~linux-next-git-rejects
+++ a/init/main.c
@@ -78,11 +78,8 @@
 #include <linux/context_tracking.h>
 #include <linux/random.h>
 #include <linux/list.h>
-<<<<<<< HEAD
-=======
 #include <linux/proc_ns.h>
 #include <linux/fs_struct.h>
->>>>>>> linux-next/akpm-base
 #include <linux/integrity.h>
 
 #include <asm/io.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation.patch
mailmap-update-akpm-osdlorg.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
tools-testing-selftests-makefile-alphasort-the-targets-list.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

