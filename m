From: akpm@linux-foundation.org
Subject: [merged] platform-x86-intel_mid_thermal-add-msic_thermal-alias.patch removed from -mm tree
Date: Thu, 08 Mar 2012 11:17:23 -0800
Message-ID: <20120308191723.7934BA06CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:60634 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957Ab2CHTRY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 14:17:24 -0500
Received: by mail-yx0-f202.google.com with SMTP id q2so103720yen.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 11:17:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mika.westerberg@linux.intel.com, alan@linux.intel.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, mingo@elte.hu, mjg@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: platform-x86: intel_mid_thermal: add msic_thermal alias
has been removed from the -mm tree.  Its filename was
     platform-x86-intel_mid_thermal-add-msic_thermal-alias.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: platform-x86: intel_mid_thermal: add msic_thermal alias

This device is called "msic_thermal" instead of "msic_sensor" on actual
boards so rename it.

[alan@linux.intel.com: updated to rename rather than add an entry as er discussion with Mika & Durgadoss R]
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/intel_mid_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/platform/x86/intel_mid_thermal.c~platform-x86-intel_mid_thermal-add-msic_thermal-alias drivers/platform/x86/intel_mid_thermal.c
--- a/drivers/platform/x86/intel_mid_thermal.c~platform-x86-intel_mid_thermal-add-msic_thermal-alias
+++ a/drivers/platform/x86/intel_mid_thermal.c
@@ -546,7 +546,7 @@ static int mid_thermal_remove(struct pla
 	return configure_adc(0);
 }
 
-#define DRIVER_NAME "msic_sensor"
+#define DRIVER_NAME "msic_thermal"
 
 static const struct platform_device_id therm_id_table[] = {
 	{ DRIVER_NAME, 1 },
_

Patches currently in -mm which might be from mika.westerberg@linux.intel.com are

linux-next.patch

