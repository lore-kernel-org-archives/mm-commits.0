From: akpm@linux-foundation.org
Subject: [merged] simple_strto-annotate-function-as-obsolete.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:09:00 -0800
Message-ID: <20121218200900.C1883100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:54758 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab2LRUJC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:09:02 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so158561qaq.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:09:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eldad@fogrefinery.com, adobriyan@gmail.com, bfields@fieldses.org, joe@perches.com, rdunlap@xenotime.net, rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     Subject: simple_strto*: annotate function as obsolete
has been removed from the -mm tree.  Its filename was
     simple_strto-annotate-function-as-obsolete.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eldad Zack <eldad@fogrefinery.com>
Subject: simple_strto*: annotate function as obsolete

Update the documentation for simple_strto* to reflect that it has been
obsoleted and advise the usage of kstrto*.

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Joe Perches <joe@perches.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN lib/vsprintf.c~simple_strto-annotate-function-as-obsolete lib/vsprintf.c
--- a/lib/vsprintf.c~simple_strto-annotate-function-as-obsolete
+++ a/lib/vsprintf.c
@@ -38,6 +38,8 @@
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
+ *
+ * This function is obsolete. Please use kstrtoull instead.
  */
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
 {
@@ -61,6 +63,8 @@ EXPORT_SYMBOL(simple_strtoull);
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
+ *
+ * This function is obsolete. Please use kstrtoul instead.
  */
 unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
 {
@@ -73,6 +77,8 @@ EXPORT_SYMBOL(simple_strtoul);
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
+ *
+ * This function is obsolete. Please use kstrtol instead.
  */
 long simple_strtol(const char *cp, char **endp, unsigned int base)
 {
@@ -88,6 +94,8 @@ EXPORT_SYMBOL(simple_strtol);
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
+ *
+ * This function is obsolete. Please use kstrtoll instead.
  */
 long long simple_strtoll(const char *cp, char **endp, unsigned int base)
 {
_

Patches currently in -mm which might be from eldad@fogrefinery.com are

origin.patch
linux-next.patch

