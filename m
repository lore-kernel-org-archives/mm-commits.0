From: akpm@linux-foundation.org
Subject: + gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander.patch added to -mm tree
Date: Tue, 29 Apr 2008 17:08:18 -0700
Message-ID: <200804300008.m3U08IdE017255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102AbYD3AI5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 20:08:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.newton@gmail.com, david-b@pacbell.net, eric.miao@marvell.com, will.newton@imgtec.com


The patch titled
     gpio: pca953x: add support for pca9555 I2C I/O expander
has been added to the -mm tree.  Its filename is
     gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: pca953x: add support for pca9555 I2C I/O expander
From: "Will Newton" <will.newton@gmail.com>

Add support for pca9555 I2C I/O expander.  As the comment suggests this part
is software compatible with the pca9539.

Signed-off-by: Will Newton <will.newton@imgtec.com>
Cc: "eric miao" <eric.miao@marvell.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpio/pca953x.c~gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander
+++ a/drivers/gpio/pca953x.c
@@ -36,6 +36,7 @@ static const struct pca953x_desc pca953x
 	{ "pca9537", 4, },
 	{ "pca9538", 8, },
 	{ "pca9539", 16, },
+	{ "pca9555", 16, },
 	/* REVISIT several pca955x parts should work here too */
 };
 
_

Patches currently in -mm which might be from will.newton@gmail.com are

gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander.patch

