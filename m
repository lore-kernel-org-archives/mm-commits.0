From: akpm@linux-foundation.org
Subject: [folded] gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:49:18 -0700
Message-ID: <200909222149.n8MLnIsC012155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349AbZIVVt4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:49:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, david-b@pacbell.net, dsilvers@simtec.co.uk, ext-jani.1.nikula@nokia.com, mm-commits@vger.kernel.org


The patch titled
     gpio.h: fix warning for GENERIC_GPIO=n
has been removed from the -mm tree.  Its filename was
     gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch

This patch was dropped because it was folded into gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio.h: fix warning for GENERIC_GPIO=n
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build for CONFIG_GENERIC_GPIO=n, which causes this warning:

include/linux/gpio.h:93: warning: 'struct device' declared inside parameter list
include/linux/gpio.h:93: warning: its scope is only this definition or declaration, which is probably not what you want

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Daniel Silverstone <dsilvers@simtec.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gpio.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/gpio.h~gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix include/linux/gpio.h
--- a/include/linux/gpio.h~gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix
+++ a/include/linux/gpio.h
@@ -12,6 +12,8 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 
+struct device;
+
 /*
  * Some platforms don't support the GPIO programming interface.
  *
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
procfs-provide-stack-information-for-threads-v08.patch
kcore-register-vmemmap-range.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch

