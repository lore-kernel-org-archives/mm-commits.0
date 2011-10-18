From: akpm@linux-foundation.org
Subject: + drivers-misc-ad525x_dpot-i2cc-add-i2c-support-for-ad5161.patch added to -mm tree
Date: Tue, 18 Oct 2011 15:44:51 -0700
Message-ID: <201110182244.p9IMipKA023527@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:6240 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab1JRWpF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2011 18:45:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacmet@sunsite.dk, michael.hennerich@analog.com, vapier@gentoo.org


The patch titled
     Subject: drivers/misc/ad525x_dpot-i2c.c: add i2c support for AD5161
has been added to the -mm tree.  Its filename is
     drivers-misc-ad525x_dpot-i2cc-add-i2c-support-for-ad5161.patch

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
From: Peter Korsgaard <jacmet@sunsite.dk>
Subject: drivers/misc/ad525x_dpot-i2c.c: add i2c support for AD5161

Commit 6c536e4ce8e ("ad525x_dpot: add support for SPI parts") added
support for the AD5161 through SPI, but the device supports both I2C and
SPI (depending on the DIS pin), so add it to -i2c as well.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ad525x_dpot-i2c.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/ad525x_dpot-i2c.c~drivers-misc-ad525x_dpot-i2cc-add-i2c-support-for-ad5161 drivers/misc/ad525x_dpot-i2c.c
--- a/drivers/misc/ad525x_dpot-i2c.c~drivers-misc-ad525x_dpot-i2cc-add-i2c-support-for-ad5161
+++ a/drivers/misc/ad525x_dpot-i2c.c
@@ -98,6 +98,7 @@ static const struct i2c_device_id ad_dpo
 	{"ad5282", AD5282_ID},
 	{"adn2860", ADN2860_ID},
 	{"ad5273", AD5273_ID},
+	{"ad5161", AD5161_ID},
 	{"ad5171", AD5171_ID},
 	{"ad5170", AD5170_ID},
 	{"ad5172", AD5172_ID},
_
Subject: Subject: drivers/misc/ad525x_dpot-i2c.c: add i2c support for AD5161

Patches currently in -mm which might be from jacmet@sunsite.dk are

linux-next.patch
drivers-misc-ad525x_dpot-i2cc-add-i2c-support-for-ad5161.patch

