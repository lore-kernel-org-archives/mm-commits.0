From: akpm@linux-foundation.org
Subject: + fs-includecheck-fix-proc-kcorec.patch added to -mm tree
Date: Thu, 24 Sep 2009 15:17:16 -0700
Message-ID: <200909242217.n8OMHGY4030518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752420AbZIXWSm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 18:18:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, jaswinderrajput@gmail.com


The patch titled
     fs: includecheck fix: proc, kcore.c
has been added to the -mm tree.  Its filename is
     fs-includecheck-fix-proc-kcorec.patch

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
Subject: fs: includecheck fix: proc, kcore.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

fix the following 'make includecheck' warning:

  fs/proc/kcore.c: linux/mm.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/proc/kcore.c~fs-includecheck-fix-proc-kcorec fs/proc/kcore.c
--- a/fs/proc/kcore.c~fs-includecheck-fix-proc-kcorec
+++ a/fs/proc/kcore.c
@@ -23,7 +23,6 @@
 #include <asm/io.h>
 #include <linux/list.h>
 #include <linux/ioport.h>
-#include <linux/mm.h>
 #include <linux/memory.h>
 #include <asm/sections.h>
 
_

Patches currently in -mm which might be from jaswinder@kernel.org are

origin.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
mm-includecheck-fix-vmallocc.patch
fs-includecheck-fix-proc-kcorec.patch
mtd-nand-fix-htmldocs-warnings.patch

