From: akpm@linux-foundation.org
Subject: + lib-string_helpers-fix-indentation-in-few-places.patch added to -mm tree
Date: Thu, 21 Jan 2016 14:37:59 -0800
Message-ID: <56a15dc7.K4mGFK5QFiQpg9XC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbcAUWiA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:38:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, elliott@hpe.com, hpa@zytor.com, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string_helpers: fix indentation in few places
has been added to the -mm tree.  Its filename is
     lib-string_helpers-fix-indentation-in-few-places.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string_helpers-fix-indentation-in-few-places.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string_helpers-fix-indentation-in-few-places.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/string_helpers: fix indentation in few places

Fix the indentation of label and put snprintf() to one line.

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Robert Elliott <elliott@hpe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN lib/string_helpers.c~lib-string_helpers-fix-indentation-in-few-places lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_helpers-fix-indentation-in-few-places
+++ a/lib/string_helpers.c
@@ -117,14 +117,13 @@ void string_get_size(u64 size, u64 blk_s
 		tmp[j+1] = '\0';
 	}
 
- out:
+out:
 	if (i >= STRING_UNITS_2_NUM)
 		unit = "UNK";
 	else
 		unit = units_str[units][i];
 
-	snprintf(buf, len, "%u%s %s", (u32)size,
-		 tmp, unit);
+	snprintf(buf, len, "%u%s %s", (u32)size, tmp, unit);
 }
 EXPORT_SYMBOL(string_get_size);
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string_helpers-export-string_units_210-for-others.patch
lib-string_helpers-fix-indentation-in-few-places.patch
x86-efi-use-proper-units-in-efi_find_mirror.patch

