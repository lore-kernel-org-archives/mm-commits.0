From: akpm@linux-foundation.org
Subject: + arm-fix-kernel-doc-syntax.patch added to -mm tree
Date: Wed, 12 Nov 2008 14:26:38 -0800
Message-ID: <200811122226.mACMQcuI024335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752946AbYKLW1B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 17:27:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     arm: fix kernel-doc syntax
has been added to the -mm tree.  Its filename is
     arm-fix-kernel-doc-syntax.patch

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
Subject: arm: fix kernel-doc syntax
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc notation to use correct syntax.  Even though this should be
moved to where the function is actually implemented...

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/include/mach/reset.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/arm/mach-pxa/include/mach/reset.h~arm-fix-kernel-doc-syntax arch/arm/mach-pxa/include/mach/reset.h
--- a/arch/arm/mach-pxa/include/mach/reset.h~arm-fix-kernel-doc-syntax
+++ a/arch/arm/mach-pxa/include/mach/reset.h
@@ -12,9 +12,8 @@ extern void clear_reset_status(unsigned 
 
 /**
  * init_gpio_reset() - register GPIO as reset generator
- *
- * @gpio - gpio nr
- * @output - set gpio as out/low instead of input during normal work
+ * @gpio: gpio nr
+ * @output: set gpio as out/low instead of input during normal work
  */
 extern int init_gpio_reset(int gpio, int output);
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
doc-add-printk-formatstxt.patch
doc-update-xip-method-info.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
arm-fix-kernel-doc-syntax.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
fusion-remove-excess-kernel-doc-notation.patch
block-remove-excess-kernel-doc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
documentation-move-ioctl-numbertxt-to-doc-ioctl.patch
documentation-move-msi-howtotxt-to-doc-pci.patch
profile-likely-unlikely-macros.patch

