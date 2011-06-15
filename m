From: akpm@linux-foundation.org
Subject: + maintainers-add-entry-for-legacy-eeprom-driver.patch added to -mm tree
Date: Tue, 14 Jun 2011 18:24:41 -0700
Message-ID: <201106150123.p5F1Lw7h031878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751624Ab1FOB0B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jun 2011 21:26:01 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p5F1NhpG010716
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 14 Jun 2011 18:23:43 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org


The patch titled
     MAINTAINERS: add entry for legacy eeprom driver
has been added to the -mm tree.  Its filename is
     maintainers-add-entry-for-legacy-eeprom-driver.patch

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
Subject: MAINTAINERS: add entry for legacy eeprom driver
From: Jean Delvare <khali@linux-fr.org>

I shall maintain the legacy eeprom driver, until we finally get rid of it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~maintainers-add-entry-for-legacy-eeprom-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-add-entry-for-legacy-eeprom-driver
+++ a/MAINTAINERS
@@ -3820,6 +3820,12 @@ S:	Maintained
 F:	drivers/leds/
 F:	include/linux/leds.h
 
+LEGACY EEPROM DRIVER
+M:	Jean Delvare <khali@linux-fr.org>
+S:	Maintained
+F:	Documentation/misc-devices/eeprom
+F:	drivers/misc/eeprom/eeprom.c
+
 LEGO USB Tower driver
 M:	Juergen Stuber <starblue@users.sourceforge.net>
 L:	legousb-devel@lists.sourceforge.net
_

Patches currently in -mm which might be from khali@linux-fr.org are

maintainers-add-entry-for-legacy-eeprom-driver.patch
linux-next.patch
thermal-hide-config_thermal_hwmon.patch
thermal-split-hwmon-lookup-to-a-separate-function.patch
thermal-make-thermal_hwmon-implementation-fully-internal.patch
drivers-firmware-dmi_scanc-make-dmi_name_in_vendors-more-focused.patch

