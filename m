From: akpm@linux-foundation.org
Subject: [to-be-updated]
 compiler-gcch-added-new-macro-for-gcc-attribute.patch removed from -mm tree
Date: Wed, 25 Jan 2017 14:56:38 -0800
Message-ID: <58892d26.GkWmBIb8SvUV79ef%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47154 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751255AbdAYW4j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2017 17:56:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gidisrael@gmail.com, geert@linux-m68k.org, gerg@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-gcc.h: add new macro for gcc attribute
has been removed from the -mm tree.  Its filename was
     compiler-gcch-added-new-macro-for-gcc-attribute.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Gideon Israel Dsouza <gidisrael@gmail.com>
Subject: compiler-gcc.h: add new macro for gcc attribute

Add __mode(x) into compiler-gcc.h.  The next patch cleans up the m68k
subsystem and it requires a new macro to wrap __attribute__ ((mode (...)))

Link: http://lkml.kernel.org/r/1485260068-2495-1-git-send-email-gidisrael@gmail.com
Signed-off-by: Gideon Israel Dsouza <gidisrael@gmail.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/compiler-gcc.h~compiler-gcch-added-new-macro-for-gcc-attribute include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~compiler-gcch-added-new-macro-for-gcc-attribute
+++ a/include/linux/compiler-gcc.h
@@ -121,6 +121,7 @@
 #define __attribute_const__	__attribute__((__const__))
 #define __maybe_unused		__attribute__((unused))
 #define __always_unused		__attribute__((unused))
+#define __mode                  __attribute__((mode(x)))
 
 /* gcc version specific checks */
 
_

Patches currently in -mm which might be from gidisrael@gmail.com are

m68k-replaced-gcc-specific-macros-with-ones-from-compilerh.patch

