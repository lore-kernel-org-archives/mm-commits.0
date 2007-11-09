From: akpm@linux-foundation.org
Subject: - sh-remove-dead-config-symbol-from-sh-code.patch removed from -mm tree
Date: Fri, 09 Nov 2007 11:13:17 -0800
Message-ID: <200711091913.lA9JDHHP027998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44673 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755184AbXKITNW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 14:13:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olsajiri@gmail.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     sh: remove dead config symbol from SH code
has been removed from the -mm tree.  Its filename was
     sh-remove-dead-config-symbol-from-sh-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sh: remove dead config symbol from SH code
From: Jiri Olsa <olsajiri@gmail.com>

Remove dead config symbols from SH code.

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-sh/cpu-sh3/timer.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN include/asm-sh/cpu-sh3/timer.h~sh-remove-dead-config-symbol-from-sh-code include/asm-sh/cpu-sh3/timer.h
--- a/include/asm-sh/cpu-sh3/timer.h~sh-remove-dead-config-symbol-from-sh-code
+++ a/include/asm-sh/cpu-sh3/timer.h
@@ -23,8 +23,7 @@
  * ---------------------------------------------------------------------------
  */
 
-#if  !defined(CONFIG_CPU_SUBTYPE_SH7720) && \
-     !defined(CONFIG_CPU_SUBTYPE_SH7727)
+#if  !defined(CONFIG_CPU_SUBTYPE_SH7720)
 #define TMU_TOCR	0xfffffe90	/* Byte access */
 #endif
 
@@ -58,8 +57,7 @@
 #define TMU2_TCOR	0xfffffeac	/* Long access */
 #define TMU2_TCNT	0xfffffeb0	/* Long access */
 #define TMU2_TCR	0xfffffeb4	/* Word access */
-#if !defined(CONFIG_CPU_SUBTYPE_SH7720) && \
-    !defined(CONFIG_CPU_SUBTYPE_SH7727)
+#if !defined(CONFIG_CPU_SUBTYPE_SH7720)
 #define TMU2_TCPR2	0xfffffeb8	/* Long access */
 #endif
 #endif
_

Patches currently in -mm which might be from olsajiri@gmail.com are

git-net.patch
drivers-serial-s3c2410c-remove-dead-config-symbols.patch
git-sh.patch
frv-remove-dead-config-symbol-from-frv-code.patch
