From: akpm@linux-foundation.org
Subject: + maintainers-remove-include-asm-suspend-file-patterns.patch added to -mm tree
Date: Sat, 18 Apr 2009 14:24:24 -0700
Message-ID: <200904182124.n3ILOOfB003990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388AbZDRVbC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Apr 2009 17:31:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     MAINTAINERS: remove include/asm-*/suspend* file patterns
has been added to the -mm tree.  Its filename is
     maintainers-remove-include-asm-suspend-file-patterns.patch

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
Subject: MAINTAINERS: remove include/asm-*/suspend* file patterns
From: Joe Perches <joe@perches.com>

There are no more arches with suspend support using these directories.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 --
 1 file changed, 2 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-include-asm-suspend-file-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-include-asm-suspend-file-patterns
+++ a/MAINTAINERS
@@ -2490,7 +2490,6 @@ F:	kernel/power/
 F:	include/linux/suspend.h
 F:	include/linux/freezer.h
 F:	include/linux/pm.h
-F:	include/asm-*/suspend*.h
 F:	arch/*/include/asm/suspend*.h
 
 HID CORE LAYER
@@ -5327,7 +5326,6 @@ F:	kernel/power/
 F:	include/linux/suspend.h
 F:	include/linux/freezer.h
 F:	include/linux/pm.h
-F:	include/asm-*/suspend.h
 
 SVGA HANDLING
 P:	Martin Mares
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-remove-include-asm-suspend-file-patterns.patch
linux-next.patch

