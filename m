From: akpm@linux-foundation.org
Subject: + includecheck-fix-documentation-cfag12864b-examplec.patch added to -mm tree
Date: Thu, 13 Aug 2009 15:04:11 -0700
Message-ID: <200908132204.n7DM4BGJ006310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbZHMWFp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 18:05:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, jaswinderrajput@gmail.com, randy.dunlap@oracle.com


The patch titled
     includecheck fix: Documentation, cfag12864b-example.c
has been added to the -mm tree.  Its filename is
     includecheck-fix-documentation-cfag12864b-examplec.patch

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
Subject: includecheck fix: Documentation, cfag12864b-example.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

fix the following 'make includecheck' warning:

  Documentation/auxdisplay/cfag12864b-example.c: string.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/auxdisplay/cfag12864b-example.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN Documentation/auxdisplay/cfag12864b-example.c~includecheck-fix-documentation-cfag12864b-examplec Documentation/auxdisplay/cfag12864b-example.c
--- a/Documentation/auxdisplay/cfag12864b-example.c~includecheck-fix-documentation-cfag12864b-examplec
+++ a/Documentation/auxdisplay/cfag12864b-example.c
@@ -194,7 +194,6 @@ static void cfag12864b_blit(void)
  */
 
 #include <stdio.h>
-#include <string.h>
 
 #define EXAMPLES	6
 
_

Patches currently in -mm which might be from jaswinder@kernel.org are

origin.patch
linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
gitignore-usr-initramfs_datacpiobz2-and-usr-initramfs_datacpiolzma.patch
net-cs89x0-includecheck-fix-for-cs89x0c.patch
mm-includecheck-fix-for-mm-shmemc.patch
mm-includecheck-fix-for-mm-nommuc.patch
includecheck-fix-drivers-char-vtc.patch
includecheck-fix-documentation-cfag12864b-examplec.patch

