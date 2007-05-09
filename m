From: akpm@linux-foundation.org
Subject: - w1-printk-format-warning.patch removed from -mm tree
Date: Tue, 08 May 2007 19:51:51 -0700
Message-ID: <200705090251.l492ppOq009509@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032191AbXEICwA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:52:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     W1 printk format warning fix
has been removed from the -mm tree.  Its filename was
     w1-printk-format-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: W1 printk format warning fix
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/w1/w1.c~w1-printk-format-warning drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-printk-format-warning
+++ a/drivers/w1/w1.c
@@ -459,7 +459,7 @@ static int __w1_attach_slave_device(stru
 		 (unsigned long long) sl->reg_num.id);
 
 	dev_dbg(&sl->dev, "%s: registering %s as %p.\n", __func__,
-		&sl->dev.bus_id[0]);
+		&sl->dev.bus_id[0], sl);
 
 	err = device_register(&sl->dev);
 	if (err < 0) {
_

Patches currently in -mm which might be from johnpol@2ka.mipt.ru are

origin.patch
git-battery.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-w1.patch
