From: akpm@linux-foundation.org
Subject: - vmi-supports-compat-vdso.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:39:54 -0700
Message-ID: <200704252039.l3PKdsRN012351@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993148AbXDYUkR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:40:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Vmi supports compat vdso
has been removed from the -mm tree.  Its filename was
     vmi-supports-compat-vdso.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Vmi supports compat vdso
From: Zachary Amsden <zach@vmware.com>

Now that the VDSO can be relocated, we can support it in VMI configurations.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/Kconfig~vmi-supports-compat-vdso arch/i386/Kconfig
--- a/arch/i386/Kconfig~vmi-supports-compat-vdso
+++ a/arch/i386/Kconfig
@@ -220,7 +220,7 @@ config PARAVIRT
 
 config VMI
 	bool "VMI Paravirt-ops support"
-	depends on PARAVIRT && !COMPAT_VDSO
+	depends on PARAVIRT
 	help
 	  VMI provides a paravirtualized interface to the VMware ESX server
 	  (it could be used by other hypervisors in theory too, but is not
_

Patches currently in -mm which might be from zach@vmware.com are

fix-buslogic-to-stop-using-check_region.patch
i386-pte-clear-optimization.patch
i386-pte-xchg-optimization.patch
i386-pte-simplify-ops.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
