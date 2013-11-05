From: akpm@linux-foundation.org
Subject: + update-zwane-mwaikambos-e-mail-address.patch added to -mm tree
Date: Tue, 05 Nov 2013 14:20:02 -0800
Message-ID: <52796f12.WLWcbS4mO88rmecu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3KEWUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Nov 2013 17:20:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zwanem@gmail.com, rmk+kernel@arm.linux.org.uk, jdelvare@suse.de

Subject: + update-zwane-mwaikambos-e-mail-address.patch added to -mm tree
To: jdelvare@suse.de,rmk+kernel@arm.linux.org.uk,zwanem@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 05 Nov 2013 14:20:02 -0800


The patch titled
     Subject: Update Zwane Mwaikambo's e-mail address
has been added to the -mm tree.  Its filename is
     update-zwane-mwaikambos-e-mail-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/update-zwane-mwaikambos-e-mail-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/update-zwane-mwaikambos-e-mail-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: Update Zwane Mwaikambo's e-mail address

Zwane Mwaikambo's @arm.linux.org.uk address no longer works.  In February
2013 he asked for his gmail address to be used instead [1] so let's just
do that.

[1] http://marc.info/?l=linux-kernel&m=136079068903214&w=2

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Zwane Mwaikambo <zwanem@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS                       |    2 +-
 Documentation/cpu-hotplug.txt |    2 +-
 MAINTAINERS                   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN CREDITS~update-zwane-mwaikambos-e-mail-address CREDITS
--- a/CREDITS~update-zwane-mwaikambos-e-mail-address
+++ a/CREDITS
@@ -2576,7 +2576,7 @@ S: Toronto, Ontario
 S: Canada
 
 N: Zwane Mwaikambo
-E: zwane@arm.linux.org.uk
+E: zwanem@gmail.com
 D: Various driver hacking
 D: Lowlevel x86 kernel hacking
 D: General debugging
diff -puN Documentation/cpu-hotplug.txt~update-zwane-mwaikambos-e-mail-address Documentation/cpu-hotplug.txt
--- a/Documentation/cpu-hotplug.txt~update-zwane-mwaikambos-e-mail-address
+++ a/Documentation/cpu-hotplug.txt
@@ -5,7 +5,7 @@
 			Rusty Russell <rusty@rustcorp.com.au>
 			Srivatsa Vaddagiri <vatsa@in.ibm.com>
 		i386:
-			Zwane Mwaikambo <zwane@arm.linux.org.uk>
+			Zwane Mwaikambo <zwanem@gmail.com>
 		ppc64:
 			Nathan Lynch <nathanl@austin.ibm.com>
 			Joel Schopp <jschopp@austin.ibm.com>
diff -puN MAINTAINERS~update-zwane-mwaikambos-e-mail-address MAINTAINERS
--- a/MAINTAINERS~update-zwane-mwaikambos-e-mail-address
+++ a/MAINTAINERS
@@ -7360,7 +7360,7 @@ S:	Odd Fixes
 F:	drivers/media/usb/tlg2300/
 
 SC1200 WDT DRIVER
-M:	Zwane Mwaikambo <zwane@arm.linux.org.uk>
+M:	Zwane Mwaikambo <zwanem@gmail.com>
 S:	Maintained
 F:	drivers/watchdog/sc1200wdt.c
 
_

Patches currently in -mm which might be from jdelvare@suse.de are

linux-next.patch
update-zwane-mwaikambos-e-mail-address.patch

