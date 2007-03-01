From: akpm@linux-foundation.org
Subject: - linux-sysdevh-needs-to-include-linux-moduleh.patch removed from -mm tree
Date: Wed, 28 Feb 2007 16:57:48 -0800
Message-ID: <200703010059.l210xLZh032589@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50108 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932867AbXCABCh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 20:02:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     <linux/sysdev.h> needs to include <linux/module.h>
has been removed from the -mm tree.  Its filename was
     linux-sysdevh-needs-to-include-linux-moduleh.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: <linux/sysdev.h> needs to include <linux/module.h>
From: Ralf Baechle <ralf@linux-mips.org>

sysdev.h uses THIS_MODULE so should include <linux/module.h>.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysdev.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/sysdev.h~linux-sysdevh-needs-to-include-linux-moduleh include/linux/sysdev.h
--- a/include/linux/sysdev.h~linux-sysdevh-needs-to-include-linux-moduleh
+++ a/include/linux/sysdev.h
@@ -22,6 +22,7 @@
 #define _SYSDEV_H_
 
 #include <linux/kobject.h>
+#include <linux/module.h>
 #include <linux/pm.h>
 
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

linux-sysdevh-needs-to-include-linux-moduleh.patch
serial-driver-pmc-msp71xx.patch
rm9000-serial-driver.patch
rm9000-serial-driver-tidy.patch
simplify-the-stacktrace-code.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
local_t-mips-extension.patch
local_t-mips-extension-fix.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
