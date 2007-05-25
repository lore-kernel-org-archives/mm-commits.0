From: akpm@linux-foundation.org
Subject: + fix-vmic-compilation.patch added to -mm tree
Date: Thu, 24 May 2007 17:08:57 -0700
Message-ID: <200705250008.l4P08vVL006897@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751077AbXEYAJh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 20:09:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     Fix vmi.c compilation
has been added to the -mm tree.  Its filename is
     fix-vmic-compilation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix vmi.c compilation
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/i386/kernel/vmi.c~fix-vmic-compilation arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~fix-vmic-compilation
+++ a/arch/i386/kernel/vmi.c
@@ -27,6 +27,7 @@
 #include <linux/bootmem.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/sched.h>
 #include <asm/vmi.h>
 #include <asm/io.h>
 #include <asm/fixmap.h>
_

Patches currently in -mm which might be from adobriyan@sw.ru are

fix-vmic-compilation.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-cleanup.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
