From: akpm@linux-foundation.org
Subject: [to-be-updated] lib-add-on-off-support-to-kstrtobool-fix.patch
 removed from -mm tree
Date: Fri, 05 Feb 2016 15:00:12 -0800
Message-ID: <56b5297c.QEFWuubFZYlM2omu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbcBEXAM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2016 18:00:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, andy.shevchenko@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-add-on-off-support-to-kstrtobool fix
has been removed from the -mm tree.  Its filename was
     lib-add-on-off-support-to-kstrtobool-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: lib-add-on-off-support-to-kstrtobool fix

Accidentally dropped description update when shuffling strtobool around.

Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/kstrtox.c~lib-add-on-off-support-to-kstrtobool-fix lib/kstrtox.c
--- a/lib/kstrtox.c~lib-add-on-off-support-to-kstrtobool-fix
+++ a/lib/kstrtox.c
@@ -327,9 +327,9 @@ EXPORT_SYMBOL(kstrtos8);
  * @base: ignored
  * @res: result
  *
- * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
- * Otherwise it will return -EINVAL.  Value pointed to by res is
- * updated upon finding a match.
+ * This routine returns 0 iff the first character is one of 'Yy1Nn0', or
+ * [oO][NnFf] for "on" and "off". Otherwise it will return -EINVAL.  Value
+ * pointed to by res is updated upon finding a match.
  */
 int kstrtobool(const char *s, unsigned int base, bool *res)
 {
_

Patches currently in -mm which might be from keescook@chromium.org are

param-convert-some-on-off-users-to-strtobool.patch

