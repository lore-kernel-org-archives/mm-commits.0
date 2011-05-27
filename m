From: akpm@linux-foundation.org
Subject: + lib-bitmapc-fix-kernel-doc-notation.patch added to -mm tree
Date: Fri, 27 May 2011 14:44:37 -0700
Message-ID: <201105272144.p4RLibK0023139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752795Ab1E0VpH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 17:45:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     lib/bitmap.c: fix kernel-doc notation
has been added to the -mm tree.  Its filename is
     lib-bitmapc-fix-kernel-doc-notation.patch

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
Subject: lib/bitmap.c: fix kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new kernel-doc warnings in lib/bitmap.c:

Warning(lib/bitmap.c:596): No description found for parameter 'buf'
Warning(lib/bitmap.c:596): Excess function parameter 'bp' description in '__bitmap_parselist'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/bitmap.c~lib-bitmapc-fix-kernel-doc-notation lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-fix-kernel-doc-notation
+++ a/lib/bitmap.c
@@ -572,7 +572,7 @@ EXPORT_SYMBOL(bitmap_scnlistprintf);
 
 /**
  * __bitmap_parselist - convert list format ASCII string to bitmap
- * @bp: read nul-terminated user string from this buffer
+ * @buf: read nul-terminated user string from this buffer
  * @buflen: buffer size in bytes.  If string is smaller than this
  *    then it must be terminated with a \0.
  * @is_user: location of buffer, 0 indicates kernel space
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
mm-memoryc-fix-kernel-doc-notation.patch
lib-bitmapc-fix-kernel-doc-notation.patch
linux-next.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

