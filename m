From: akpm@linux-foundation.org
Subject: - maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:54:13 -0800
Message-ID: <200802050253.m152rsZr031543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58944 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753343AbYBECyj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:54:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jgarzik@pobox.com, mid@zigamorph.net, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: remove Adam Fritzler, update his email address in other sources
has been removed from the -mm tree.  Its filename was
     maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: remove Adam Fritzler, update his email address in other sources
From: Joe Perches <joe@perches.com>

Adam said

> I am no longer actively involved. If you can mark me as a former point
> of contact, that's fine, or you can just delete the entry. My name is
> still in the source, but with the old address. It'd great if the
> address in source was updated. 

(http://www.gossamer-threads.com/lists/linux/kernel/855361)

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Adam Fritzler <mid@zigamorph.net>
Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS                          |    3 +++
 MAINTAINERS                      |    7 -------
 drivers/net/eexpress.c           |    2 +-
 drivers/net/tokenring/abyss.c    |    2 +-
 drivers/net/tokenring/abyss.h    |    2 +-
 drivers/net/tokenring/madgemc.c  |    2 +-
 drivers/net/tokenring/madgemc.h  |    2 +-
 drivers/net/tokenring/proteon.c  |    2 +-
 drivers/net/tokenring/skisa.c    |    2 +-
 drivers/net/tokenring/tms380tr.c |    2 +-
 drivers/net/tokenring/tms380tr.h |    2 +-
 drivers/net/tokenring/tmspci.c   |    2 +-
 drivers/scsi/aha1542.c           |    2 +-
 13 files changed, 14 insertions(+), 18 deletions(-)

diff -puN CREDITS~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources CREDITS
--- a/CREDITS~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources
+++ a/CREDITS
@@ -1124,6 +1124,9 @@ S: 1150 Ringwood Court
 S: San Jose, California 95131
 S: USA
 
+N: Adam Fritzler
+E: mid@zigamorph.net
+
 N: Fernando Fuganti
 E: fuganti@conectiva.com.br
 E: fuganti@netbank.com.br
diff -puN MAINTAINERS~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources
+++ a/MAINTAINERS
@@ -3871,13 +3871,6 @@ W:	http://www.kernel.org/pub/linux/kerne
 T:	git kernel.org:/pub/scm/linux/kernel/git/bunk/trivial.git
 S:	Maintained
 
-TMS380 TOKEN-RING NETWORK DRIVER
-P:	Adam Fritzler
-M:	mid@auk.cx
-L:	linux-tr@linuxtr.net
-W:	http://www.auk.cx/tms380tr/
-S:	Maintained
-
 TULIP NETWORK DRIVER
 L:	tulip-users@lists.sourceforge.net
 W:	http://sourceforge.net/projects/tulip/
diff -puN drivers/net/eexpress.c~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources drivers/net/eexpress.c
--- a/drivers/net/eexpress.c~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources
+++ a/drivers/net/eexpress.c
@@ -9,7 +9,7 @@
  * Many modifications, and currently maintained, by
  *  Philip Blundell <philb@gnu.org>
  * Added the Compaq LTE  Alan Cox <alan@redhat.com>
- * Added MCA support Adam Fritzler <mid@auk.cx>
+ * Added MCA support Adam Fritzler
  *
  * Note - this driver is experimental still - it has problems on faster
  * machines. Someone needs to sit down and go through it line by line with
diff -puN drivers/net/tokenring/abyss.c~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources drivers/net/tokenring/abyss.c
--- a/drivers/net/tokenring/abyss.c~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources
+++ a/drivers/net/tokenring/abyss.c
@@ -10,7 +10,7 @@
  *      - Madge Smart 16/4 PCI Mk2
  *
  *  Maintainer(s):
- *    AF	Adam Fritzler		mid@auk.cx
+ *    AF	Adam Fritzler
  *
  *  Modification History:
  *	30-Dec-99	AF	Split off from the tms380tr driver.
diff -puN drivers/net/tokenring/abyss.h~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources drivers/net/tokenring/abyss.h
--- a/drivers/net/tokenring/abyss.h~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources
+++ a/drivers/net/tokenring/abyss.h
@@ -2,7 +2,7 @@
  * abyss.h: Header for the abyss tms380tr module
  *
  * Authors:
- * - Adam Fritzler <mid@auk.cx>
+ * - Adam Fritzler
  */
 
 #ifndef __LINUX_MADGETR_H
diff -puN drivers/net/tokenring/madgemc.c~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources drivers/net/tokenring/madgemc.c
--- a/drivers/net/tokenring/madgemc.c~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources
+++ a/drivers/net/tokenring/madgemc.c
@@ -11,7 +11,7 @@
  *	- Madge Smart 16/4 Ringnode MC32 (??)
  *
  *  Maintainer(s):
- *    AF	Adam Fritzler		mid@auk.cx
+ *    AF	Adam Fritzler
  *
  *  Modification History:
  *	16-Jan-00	AF	Created
diff -puN drivers/net/tokenring/madgemc.h~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources drivers/net/tokenring/madgemc.h
--- a/drivers/net/tokenring/madgemc.h~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources
+++ a/drivers/net/tokenring/madgemc.h
@@ -2,7 +2,7 @@
  * madgemc.h: Header for the madgemc tms380tr module
  *
  * Authors:
- * - Adam Fritzler <mid@auk.cx>
+ * - Adam Fritzler
  */
 
 #ifndef __LINUX_MADGEMC_H
diff -puN drivers/net/tokenring/proteon.c~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources drivers/net/tokenring/proteon.c
--- a/drivers/net/tokenring/proteon.c~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources
+++ a/drivers/net/tokenring/proteon.c
@@ -12,7 +12,7 @@
  *	- Proteon 1392, 1392+
  *
  *  Maintainer(s):
- *    AF        Adam Fritzler           mid@auk.cx
+ *    AF        Adam Fritzler
  *    JF	Jochen Friedrich	jochen@scram.de
  *
  *  Modification History:
diff -puN drivers/net/tokenring/skisa.c~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources drivers/net/tokenring/skisa.c
--- a/drivers/net/tokenring/skisa.c~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources
+++ a/drivers/net/tokenring/skisa.c
@@ -13,7 +13,7 @@
  *	- SysKonnect TR4/16(+) ISA	(SK-4190)
  *
  *  Maintainer(s):
- *    AF        Adam Fritzler           mid@auk.cx
+ *    AF        Adam Fritzler
  *    JF	Jochen Friedrich	jochen@scram.de
  *
  *  Modification History:
diff -puN drivers/net/tokenring/tms380tr.c~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources drivers/net/tokenring/tms380tr.c
--- a/drivers/net/tokenring/tms380tr.c~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources
+++ a/drivers/net/tokenring/tms380tr.c
@@ -30,7 +30,7 @@
  *  Maintainer(s):
  *    JS	Jay Schulist		jschlst@samba.org
  *    CG	Christoph Goos		cgoos@syskonnect.de
- *    AF	Adam Fritzler		mid@auk.cx
+ *    AF	Adam Fritzler
  *    MLP       Mike Phillips           phillim@amtrak.com
  *    JF	Jochen Friedrich	jochen@scram.de
  *     
diff -puN drivers/net/tokenring/tms380tr.h~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources drivers/net/tokenring/tms380tr.h
--- a/drivers/net/tokenring/tms380tr.h~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources
+++ a/drivers/net/tokenring/tms380tr.h
@@ -3,7 +3,7 @@
  *
  * Authors:
  * - Christoph Goos <cgoos@syskonnect.de>
- * - Adam Fritzler <mid@auk.cx>
+ * - Adam Fritzler
  */
 
 #ifndef __LINUX_TMS380TR_H
diff -puN drivers/net/tokenring/tmspci.c~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources drivers/net/tokenring/tmspci.c
--- a/drivers/net/tokenring/tmspci.c~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources
+++ a/drivers/net/tokenring/tmspci.c
@@ -14,7 +14,7 @@
  *      - 3Com 3C339 Token Link Velocity
  *
  *  Maintainer(s):
- *    AF	Adam Fritzler		mid@auk.cx
+ *    AF	Adam Fritzler
  *
  *  Modification History:
  *	30-Dec-99	AF	Split off from the tms380tr driver.
diff -puN drivers/scsi/aha1542.c~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources drivers/scsi/aha1542.c
--- a/drivers/scsi/aha1542.c~maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources
+++ a/drivers/scsi/aha1542.c
@@ -21,7 +21,7 @@
  *  Modified by Chris Faulhaber <jedgar@fxp.org>
  *        Added module command-line options
  *        19-Jul-99
- *  Modified by Adam Fritzler <mid@auk.cx>
+ *  Modified by Adam Fritzler
  *        Added proper detection of the AHA-1640 (MCA version of AHA-1540)
  */
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
uml-add-missing-space.patch
uml-style-fixes-in-arch-um-kernel.patch
git-cpufreq.patch
git-hwmon.patch
git-kvm.patch
git-unionfs.patch
printk_ratelimit-functions-should-use-config_printk.patch
