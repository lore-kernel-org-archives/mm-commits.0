From: akpm@linux-foundation.org
Subject: [merged] hp_accel-add-a-new-pnp-id.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:17:06 -0700
Message-ID: <201111012117.pA1LH64g009973@hpaq3.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:30359 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1KAVRM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:17:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tiwai@suse.de, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hp_accel: Add a new PNP id
has been removed from the -mm tree.  Its filename was
     hp_accel-add-a-new-pnp-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Takashi Iwai <tiwai@suse.de>
Subject: hp_accel: Add a new PNP id

New HP laptops assign a new PNP id "HPQ6000" for DriveGuard.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/hp_accel.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/platform/x86/hp_accel.c~hp_accel-add-a-new-pnp-id drivers/platform/x86/hp_accel.c
--- a/drivers/platform/x86/hp_accel.c~hp_accel-add-a-new-pnp-id
+++ a/drivers/platform/x86/hp_accel.c
@@ -76,6 +76,7 @@ static inline void delayed_sysfs_set(str
 /* For automatic insertion of the module */
 static struct acpi_device_id lis3lv02d_device_ids[] = {
 	{"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */
+	{"HPQ6000", 0}, /* HP Mobile Data Protection System PNP */
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, lis3lv02d_device_ids);
_

Patches currently in -mm which might be from tiwai@suse.de are

origin.patch
linux-next.patch

