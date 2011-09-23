From: akpm@google.com
Subject: + hp_accel-add-a-new-pnp-id.patch added to -mm tree
Date: Fri, 23 Sep 2011 14:16:58 -0700
Message-ID: <201109232116.p8NLGwgN025935@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:20127 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1IWVRE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Sep 2011 17:17:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, mjg@redhat.com


The patch titled
     Subject: hp_accel: Add a new PNP id
has been added to the -mm tree.  Its filename is
     hp_accel-add-a-new-pnp-id.patch

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
From: Takashi Iwai <tiwai@suse.de>
Subject: hp_accel: Add a new PNP id

New HP laptops assign a new PNP id "HPQ6000" for DriveGuard.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@google.com>
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
Subject: Subject: hp_accel: Add a new PNP id

Patches currently in -mm which might be from tiwai@suse.de are

origin.patch
linux-next.patch
hp_accel-add-a-new-pnp-id.patch

