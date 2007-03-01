From: akpm@linux-foundation.org
Subject: + linux-sysdevh-needs-to-include-linux-moduleh.patch added to -mm tree
Date: Thu, 01 Mar 2007 15:10:53 -0800
Message-ID: <200703012310.l21NAr8g025459@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53278 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161142AbXCAXOP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 18:14:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, ak@suse.de


The patch titled
     <linux/sysdev.h> needs to include <linux/module.h>
has been added to the -mm tree.  Its filename is
     linux-sysdevh-needs-to-include-linux-moduleh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: <linux/sysdev.h> needs to include <linux/module.h>
From: Ralf Baechle <ralf@linux-mips.org>

sysdev.h uses THIS_MODULE so should include <linux/module.h>.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysdev.h |    1 +
 1 files changed, 1 insertion(+)

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

serial-driver-pmc-msp71xx.patch
rm9000-serial-driver.patch
rm9000-serial-driver-tidy.patch
x86_64-fix-ia32_binfmtc-build-error.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
simplify-the-stacktrace-code.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
local_t-mips-extension.patch
local_t-mips-extension-fix.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
