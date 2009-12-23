From: akpm@linux-foundation.org
Subject: [merged] lib-stringc-fix-kernel-doc-warnings.patch removed from -mm tree
Date: Wed, 23 Dec 2009 12:58:23 -0800
Message-ID: <200912232058.nBNKwNjk021163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754695AbZLWU6i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Dec 2009 15:58:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     lib/string.c: fix kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     lib-stringc-fix-kernel-doc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/string.c: fix kernel-doc warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings (@arg name) in string.c::skip_spaces().

Warning(lib/string.c:347): No description found for parameter 'str'
Warning(lib/string.c:347): Excess function parameter 's' description in 'skip_spaces'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/string.c~lib-stringc-fix-kernel-doc-warnings lib/string.c
--- a/lib/string.c~lib-stringc-fix-kernel-doc-warnings
+++ a/lib/string.c
@@ -338,10 +338,10 @@ EXPORT_SYMBOL(strnchr);
 #endif
 
 /**
- * skip_spaces - Removes leading whitespace from @s.
- * @s: The string to be stripped.
+ * skip_spaces - Removes leading whitespace from @str.
+ * @str: The string to be stripped.
  *
- * Returns a pointer to the first non-whitespace character in @s.
+ * Returns a pointer to the first non-whitespace character in @str.
  */
 char *skip_spaces(const char *str)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
docs-large-update-to-ioctl-numbertxt.patch
documentation-update-mmiotracetxt.patch
documentation-update-tracepoint-analysistxt.patch
documentation-update-ftrace-designtxt.patch
documentation-update-ring-buffer-designtxt.patch
linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

