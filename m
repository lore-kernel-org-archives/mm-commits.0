From: akpm@linux-foundation.org
Subject: + maintainers-update-file-patterns-for-wolfson-microelectronics-pmic-drivers.patch added to -mm tree
Date: Tue, 08 Dec 2009 15:25:35 -0800
Message-ID: <200912082325.nB8NPZCY004960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935905AbZLHXZe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 18:25:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, broonie@opensource.wolfsonmicro.com


The patch titled
     MAINTAINERS: Update file patterns for WOLFSON MICROELECTRONICS PMIC DRIVERS
has been added to the -mm tree.  Its filename is
     maintainers-update-file-patterns-for-wolfson-microelectronics-pmic-drivers.patch

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
Subject: MAINTAINERS: Update file patterns for WOLFSON MICROELECTRONICS PMIC DRIVERS
From: Joe Perches <joe@perches.com>

One of the includes pointed to a non-existent directory
Add Documentation/hwmon/wm83??
Add sound/soc/codecs/wm(8350|8400).h files

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-update-file-patterns-for-wolfson-microelectronics-pmic-drivers MAINTAINERS
--- a/MAINTAINERS~maintainers-update-file-patterns-for-wolfson-microelectronics-pmic-drivers
+++ a/MAINTAINERS
@@ -6018,6 +6018,7 @@ M:	Mark Brown <broonie@opensource.wolfso
 T:	git git://opensource.wolfsonmicro.com/linux-2.6-audioplus
 W:	http://opensource.wolfsonmicro.com/node/8
 S:	Supported
+F:	Documentation/hwmon/wm83??
 F:	drivers/leds/leds-wm83*.c
 F:	drivers/mfd/wm8*.c
 F:	drivers/power/wm83*.c
@@ -6027,9 +6028,9 @@ F:	drivers/video/backlight/wm83*_bl.c
 F:	drivers/watchdog/wm83*_wdt.c
 F:	include/linux/mfd/wm831x/
 F:	include/linux/mfd/wm8350/
-F:	include/linux/mfd/wm8400/
-F:	sound/soc/codecs/wm8350.c
-F:	sound/soc/codecs/wm8400.c
+F:	include/linux/mfd/wm8400*
+F:	sound/soc/codecs/wm8350.*
+F:	sound/soc/codecs/wm8400.*
 
 X.25 NETWORK LAYER
 M:	Henner Eisen <eis@baty.hanse.de>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patch
kernelh-remove-initialization-of-bool-in-printk_once.patch
kernelh-add-printk_ratelimited-and-pr_level_rl.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
scripts-get_maintainerpl-support-multiple-vcss-add-mercurial.patch
maintainers-rename-palm-treo-section-and-file-patterns.patch
maintainers-remove-file-pattern-from-kernel-virtual-machine-kvm-for-amd-v.patch
maintainers-update-file-patterns-for-wolfson-microelectronics-pmic-drivers.patch
lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
fs-xfs-xfs_log_recoverc-use-%pu-to-print-uuids.patch
randomc-use-%pu-to-print-uuids.patch
drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch
drivers-md-mdc-use-%pu-to-print-uuids.patch
fs-gfs2-sysc-use-%pub-to-print-uuids.patch
fs-ubifs-use-%pub-to-print-uuids.patch
efih-use-%pul-to-print-uuids.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch
parport_pcc-use-correct-length-in-strncmp.patch

