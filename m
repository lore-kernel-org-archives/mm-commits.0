From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-pca9633c-remove-unused-adapter-variable.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:56 -0700
Message-ID: <20120326192956.5D56FA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:44853 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZT35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:57 -0400
Received: by yenq2 with SMTP id q2so832106yen.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, p.meerwald@bct-electronic.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-pca9633.c: remove unused 'adapter' variable
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-pca9633c-remove-unused-adapter-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/leds/leds-pca9633.c: remove unused 'adapter' variable

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Peter Meerwald <p.meerwald@bct-electronic.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca9633.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/leds/leds-pca9633.c~drivers-leds-leds-pca9633c-remove-unused-adapter-variable drivers/leds/leds-pca9633.c
--- a/drivers/leds/leds-pca9633.c~drivers-leds-leds-pca9633c-remove-unused-adapter-variable
+++ a/drivers/leds/leds-pca9633.c
@@ -96,11 +96,9 @@ static int __devinit pca9633_probe(struc
 					const struct i2c_device_id *id)
 {
 	struct pca9633_led *pca9633;
-	struct i2c_adapter *adapter;
 	struct led_platform_data *pdata;
 	int i, err;
 
-	adapter = to_i2c_adapter(client->dev.parent);
 	pdata = client->dev.platform_data;
 
 	if (pdata) {
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch

