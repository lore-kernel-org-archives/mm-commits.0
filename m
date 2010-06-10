From: akpm@linux-foundation.org
Subject: + drivers-hwmon-hdapsc-add-lenovo-thinkpad-t400-to-the-whitelist.patch added to -mm tree
Date: Thu, 10 Jun 2010 14:56:04 -0700
Message-ID: <201006102156.o5ALu4ux025668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302Ab0FJV4i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jun 2010 17:56:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rrs@researchut.com, dtor@mail.ru, frank@f-seidel.de, khali@linux-fr.org, rrs@debian.org


The patch titled
     drivers/hwmon/hdaps.c: add Lenovo Thinkpad T400 to the whitelist
has been added to the -mm tree.  Its filename is
     drivers-hwmon-hdapsc-add-lenovo-thinkpad-t400-to-the-whitelist.patch

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
Subject: drivers/hwmon/hdaps.c: add Lenovo Thinkpad T400 to the whitelist
From: Ritesh Raj Sarraf <rrs@researchut.com>

Add Lenovo Thinkpad T400.  I have done the testing on my laptop.  The
hdaps module detects the device and the hdapsd daemon is able to [un]park
the disk.

Signed-off-by: Ritesh Raj Sarraf <rrs@debian.org>
Cc: Frank Seidel <frank@f-seidel.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hdaps.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/hwmon/hdaps.c~drivers-hwmon-hdapsc-add-lenovo-thinkpad-t400-to-the-whitelist drivers/hwmon/hdaps.c
--- a/drivers/hwmon/hdaps.c~drivers-hwmon-hdapsc-add-lenovo-thinkpad-t400-to-the-whitelist
+++ a/drivers/hwmon/hdaps.c
@@ -522,6 +522,7 @@ static struct dmi_system_id __initdata h
 	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T42p", HDAPS_BOTH_AXES),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T42"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T43"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T400", HDAPS_BOTH_AXES),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T60", HDAPS_BOTH_AXES),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61p", HDAPS_BOTH_AXES),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61", HDAPS_BOTH_AXES),
_

Patches currently in -mm which might be from rrs@researchut.com are

drivers-hwmon-hdapsc-add-lenovo-thinkpad-t400-to-the-whitelist.patch

