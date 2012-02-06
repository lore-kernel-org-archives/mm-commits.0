From: akpm@linux-foundation.org
Subject: + platform-x86-intel_mid_thermal-add-msic_thermal-alias.patch added to -mm tree
Date: Mon, 06 Feb 2012 13:01:06 -0800
Message-ID: <20120206210106.E4D14A016E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:50005 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab2BFVBI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 16:01:08 -0500
Received: by ggnp1 with SMTP id p1so615679ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 13:01:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mika.westerberg@linux.intel.com, alan@linux.intel.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, mingo@elte.hu, mjg@redhat.com, tglx@linutronix.de


The patch titled
     Subject: platform-x86: intel_mid_thermal: add msic_thermal alias
has been added to the -mm tree.  Its filename is
     platform-x86-intel_mid_thermal-add-msic_thermal-alias.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: platform-x86: intel_mid_thermal: add msic_thermal alias

Patches currently in -mm which might be from mika.westerberg@linux.intel.com are

linux-next.patch
platform-x86-intel_mid_thermal-add-msic_thermal-alias.patch
platform-x86-intel_mid_thermal-convert-to-use-intel-msic-api.patch
platform-x86-intel_mid_thermal-turn-off-thermistor-voltage-by-default.patch
intel_mid_powerbtn-use-msic-read-write-instead-of-ipc_scu.patch

