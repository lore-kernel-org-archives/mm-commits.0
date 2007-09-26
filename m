From: akpm@linux-foundation.org
Subject: + dvb-fix-kconfig-help-text.patch added to -mm tree
Date: Wed, 26 Sep 2007 09:56:18 -0700
Message-ID: <200709261656.l8QGuIhS025985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32960 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518AbXIZQ4b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 12:56:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: uwe.bugla@gmx.de, mchehab@infradead.org


The patch titled
     dvb: Fix kconfig help text
has been added to the -mm tree.  Its filename is
     dvb-fix-kconfig-help-text.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dvb: Fix kconfig help text
From: Uwe Bugla <uwe.bugla@gmx.de>

This patch corrects some broken English in Kconfig.

Signed-off-by: Uwe Bugla <uwe.bugla@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/media/dvb/frontends/Kconfig~dvb-fix-kconfig-help-text drivers/media/dvb/frontends/Kconfig
--- a/drivers/media/dvb/frontends/Kconfig~dvb-fix-kconfig-help-text
+++ a/drivers/media/dvb/frontends/Kconfig
@@ -299,8 +299,9 @@ config DVB_PLL
 	depends on DVB_CORE && I2C
 	default m if DVB_FE_CUSTOMISE
 	help
-	  This module driver a number of tuners based on PLL chips with a
-	  common I2C interface. Say Y when you want to support these tuners.
+	  This module driver is needed by a couple of tuners based on PLL chips
+	  with a common I2C interface. Say Y when you want to support these
+	  tuners.
 
 config DVB_TDA826X
 	tristate "Philips TDA826X silicon tuner"
_

Patches currently in -mm which might be from uwe.bugla@gmx.de are

acpi-suppress-uninitialized-var-warning.patch
dvb-fix-kconfig-help-text.patch
asm-i386-ioh-fix-constness.patch
