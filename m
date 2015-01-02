From: akpm@linux-foundation.org
Subject: + lib-strncpy_from_userc-replace-moduleh-include.patch added to
 -mm tree
Date: Fri, 02 Jan 2015 14:56:53 -0800
Message-ID: <54a72235.pN1/uJ4UTggd3Yy+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbbABW4y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 17:56:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/strncpy_from_user.c: replace module.h include
has been added to the -mm tree.  Its filename is
     lib-strncpy_from_userc-replace-moduleh-include.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-strncpy_from_userc-replace-moduleh-include.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-strncpy_from_userc-replace-moduleh-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/strncpy_from_user.c: replace module.h include

strncpy_from_user.c only needs EXPORT_SYMBOL, so just include compiler.h
and export.h instead of the whole module.h machinery.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/strncpy_from_user.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/strncpy_from_user.c~lib-strncpy_from_userc-replace-moduleh-include lib/strncpy_from_user.c
--- a/lib/strncpy_from_user.c~lib-strncpy_from_userc-replace-moduleh-include
+++ a/lib/strncpy_from_user.c
@@ -1,4 +1,5 @@
-#include <linux/module.h>
+#include <linux/compiler.h>
+#include <linux/export.h>
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-string_get_size-remove-redundant-prefixes.patch
lib-string_get_size-use-32-bit-arithmetic-when-possible.patch
lib-string_get_size-return-void.patch
lib-bitmap-more-signed-unsigned-conversions.patch
linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
lib-bitmap-update-bitmap_onto-to-unsigned.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned.patch
lib-bitmap-simplify-bitmap_pos_to_ord.patch
lib-bitmap-simplify-bitmap_ord_to_pos.patch
lib-bitmap-make-the-bits-parameter-of-bitmap_remap-unsigned.patch
lib-remove-strnicmp.patch
lib-interval_treec-simplify-includes.patch
lib-sortc-use-simpler-includes.patch
lib-dynamic_queue_limitsc-simplify-includes.patch
lib-halfmd4c-simplify-includes.patch
lib-idrc-remove-redundant-include.patch
lib-genallocc-remove-redundant-include.patch
lib-list_sortc-rearrange-includes.patch
lib-md5c-simplify-include.patch
lib-llistc-remove-redundant-include.patch
lib-kobject_ueventc-remove-redundant-include.patch
lib-nlattrc-remove-redundant-include.patch
lib-plistc-remove-redundant-include.patch
lib-radix-treec-change-to-simpler-include.patch
lib-show_memc-remove-redundant-include.patch
lib-sortc-move-include-inside-if-0.patch
lib-stmp_devicec-replace-moduleh-include.patch
lib-strncpy_from_userc-replace-moduleh-include.patch
lib-percpu_idac-remove-redundant-includes.patch
lib-lcmc-replace-include.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch

