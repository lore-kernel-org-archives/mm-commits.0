From: akpm@linux-foundation.org
Subject: [merged] update-zwane-mwaikambos-e-mail-address.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:40:26 -0800
Message-ID: <5283e3ba.RKypQQ3aU8LqRHkO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3KMUk1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zwanem@gmail.com, rmk+kernel@arm.linux.org.uk, jdelvare@suse.de

Subject: [merged] update-zwane-mwaikambos-e-mail-address.patch removed from -mm tree
To: jdelvare@suse.de,rmk+kernel@arm.linux.org.uk,zwanem@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:26 -0800


The patch titled
     Subject: MAINTAINERS: update Zwane Mwaikambo's e-mail address
has been removed from the -mm tree.  Its filename was
     update-zwane-mwaikambos-e-mail-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: MAINTAINERS: update Zwane Mwaikambo's e-mail address

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
@@ -7319,7 +7319,7 @@ S:	Odd Fixes
 F:	drivers/media/usb/tlg2300/
 
 SC1200 WDT DRIVER
-M:	Zwane Mwaikambo <zwane@arm.linux.org.uk>
+M:	Zwane Mwaikambo <zwanem@gmail.com>
 S:	Maintained
 F:	drivers/watchdog/sc1200wdt.c
 
_

Patches currently in -mm which might be from jdelvare@suse.de are

origin.patch
linux-next.patch

