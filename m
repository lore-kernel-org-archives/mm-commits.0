From: akpm@linux-foundation.org
Subject: [merged] includecheck-fix-documentation-cfag12864b-examplec.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:33:42 -0700
Message-ID: <200909241933.n8OJXgk6029314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754214AbZIXTfE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:35:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, jaswinderrajput@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     includecheck fix: Documentation, cfag12864b-example.c
has been removed from the -mm tree.  Its filename was
     includecheck-fix-documentation-cfag12864b-examplec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch

