From: akpm@google.com
Subject: + drivers-bcma-driver_chipcommon_pmuc-needs-exporth.patch added to -mm tree
Date: Tue, 20 Sep 2011 15:41:24 -0700
Message-ID: <201109202241.p8KMfOrZ010307@hpaq6.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:27949 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1ITWll (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2011 18:41:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, linville@tuxdriver.com, zajec5@gmail.com


The patch titled
     Subject: drivers/bcma/driver_chipcommon_pmu.c needs export.h
has been added to the -mm tree.  Its filename is
     drivers-bcma-driver_chipcommon_pmuc-needs-exporth.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: drivers/bcma/driver_chipcommon_pmu.c needs export.h

bcma/driver_chipcommon_pmu.c needs to include <linux/export.h>.

Fixes these warnings:

drivers/bcma/driver_chipcommon_pmu.c:27:1: warning: data definition has no type or storage class
drivers/bcma/driver_chipcommon_pmu.c:27:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/bcma/driver_chipcommon_pmu.c:27:1: warning: parameter names (without types) in function declaration
drivers/bcma/driver_chipcommon_pmu.c:36:1: warning: data definition has no type or storage class
drivers/bcma/driver_chipcommon_pmu.c:36:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/bcma/driver_chipcommon_pmu.c:36:1: warning: parameter names (without types) in function declaration
drivers/bcma/driver_chipcommon_pmu.c:45:1: warning: data definition has no type or storage class
drivers/bcma/driver_chipcommon_pmu.c:45:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/bcma/driver_chipcommon_pmu.c:45:1: warning: parameter names (without types) in function declaration
drivers/bcma/driver_chipcommon_pmu.c:54:1: warning: data definition has no type or storage class
drivers/bcma/driver_chipcommon_pmu.c:54:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/bcma/driver_chipcommon_pmu.c:54:1: warning: parameter names (without types) in function declaration

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Rafal Milecki <zajec5@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/bcma/driver_chipcommon_pmu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/bcma/driver_chipcommon_pmu.c~drivers-bcma-driver_chipcommon_pmuc-needs-exporth drivers/bcma/driver_chipcommon_pmu.c
--- a/drivers/bcma/driver_chipcommon_pmu.c~drivers-bcma-driver_chipcommon_pmuc-needs-exporth
+++ a/drivers/bcma/driver_chipcommon_pmu.c
@@ -10,6 +10,7 @@
 
 #include "bcma_private.h"
 #include <linux/bcma/bcma.h>
+#include <linux/export.h>
 
 static u32 bcma_chipco_pll_read(struct bcma_drv_cc *cc, u32 offset)
 {
_
Subject: Subject: drivers/bcma/driver_chipcommon_pmu.c needs export.h

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
drm-fix-kconfig-unmet-dependency-warning.patch
scsi-qla4xxx-needs-libiscsio.patch
drivers-bcma-driver_chipcommon_pmuc-needs-exporth.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
cross-memory-attach-update.patch
consolidate-config_debug_strict_user_copy_checks-fix.patch
dynamic_debug-fix-undefined-reference-to-__netdev_printk.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
init-add-root=partuuid=uuid-partnroff=%d-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

