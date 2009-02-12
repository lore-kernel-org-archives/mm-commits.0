From: akpm@linux-foundation.org
Subject: [failures] pcf50633_charger-fix-typo.patch removed from -mm tree
Date: Wed, 11 Feb 2009 17:17:37 -0800
Message-ID: <200902120117.n1C1Hbbo028056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754333AbZBLBSh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 20:18:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balajirrao@openmoko.org, andy@openmoko.com, cbou@mail.ru, mm-commits@vger.kernel.org


The patch titled
     pcf50633_charger: fix typo
has been removed from the -mm tree.  Its filename was
     pcf50633_charger-fix-typo.patch

This patch was dropped because it had testing failures

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
@@ -267,7 +267,8 @@ static int usb_get_property(struct power
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
mfd-pcf50633-terminate-i2c_device_id-list.patch

