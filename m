From: akpm@linux-foundation.org
Subject: + pcf50633_charger-fix-typo.patch added to -mm tree
Date: Mon, 02 Feb 2009 14:42:15 -0800
Message-ID: <200902022242.n12MgFW4003349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753983AbZBBWns (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 17:43:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balajirrao@openmoko.org, andy@openmoko.com, cbou@mail.ru


The patch titled
     pcf50633_charger: fix typo
has been added to the -mm tree.  Its filename is
     pcf50633_charger-fix-typo.patch

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
Subject: pcf50633_charger: fix typo
From: Balaji Rao <balajirrao@openmoko.org>

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Anton Vorontsov <cbou@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/pcf50633-charger.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/power/pcf50633-charger.c~pcf50633_charger-fix-typo drivers/power/pcf50633-charger.c
--- a/drivers/power/pcf50633-charger.c~pcf50633_charger-fix-typo
+++ a/drivers/power/pcf50633-charger.c
@@ -199,7 +199,8 @@ static int adapter_get_property(struct p
 			enum power_supply_property psp,
 			union power_supply_propval *val)
 {
-	struct pcf50633_mbc *mbc = container_of(psy, struct pcf50633_mbc, usb);
+	struct pcf50633_mbc *mbc = container_of(psy,
+				struct pcf50633_mbc, adapter);
 	int ret = 0;
 
 	switch (psp) {
_

Patches currently in -mm which might be from balajirrao@openmoko.org are

linux-next.patch
pcf50633_charger-fix-typo.patch
pcf50633_charger-remove-mbc_set_status.patch
mfd-pcf50633-terminate-i2c_device_id-list.patch

