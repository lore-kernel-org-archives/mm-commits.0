From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-adp-gpio-f-patterns.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:29:04 -0800
Message-ID: <20120111212904.9D2B110004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:40829 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934068Ab2AKV3F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:29:05 -0500
Received: by ghrr15 with SMTP id r15so137111ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:29:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, grant.likely@secretlab.ca, michael.hennerich@analog.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update adp gpio F: patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-adp-gpio-f-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update adp gpio F: patterns

Commit c103de240439df ("gpio: reorganize drivers") renamed the files,
update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-adp-gpio-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-adp-gpio-f-patterns
+++ a/MAINTAINERS
@@ -342,7 +342,7 @@ S:	Supported
 F:	drivers/mfd/adp5520.c
 F:	drivers/video/backlight/adp5520_bl.c
 F:	drivers/leds/leds-adp5520.c
-F:	drivers/gpio/adp5520-gpio.c
+F:	drivers/gpio/gpio-adp5520.c
 F:	drivers/input/keyboard/adp5520-keys.c
 
 ADP5588 QWERTY KEYPAD AND IO EXPANDER DRIVER (ADP5588/ADP5587)
@@ -351,7 +351,7 @@ L:	device-drivers-devel@blackfin.uclinux
 W:	http://wiki.analog.com/ADP5588
 S:	Supported
 F:	drivers/input/keyboard/adp5588-keys.c
-F:	drivers/gpio/adp5588-gpio.c
+F:	drivers/gpio/gpio-adp5588.c
 
 ADP8860 BACKLIGHT DRIVER (ADP8860/ADP8861/ADP8863)
 M:	Michael Hennerich <michael.hennerich@analog.com>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
kernelh-neaten-panic-prototype.patch
linkage-remove-unused-noret_and-macro.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
linkage-remove-unused-attrib_noret-macro.patch

