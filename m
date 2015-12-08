From: akpm@linux-foundation.org
Subject: + printk-formatstxt-remove-unimplemented-%pt.patch added to -mm
 tree
Date: Tue, 08 Dec 2015 12:52:11 -0800
Message-ID: <566742fb.V+ZoSUX6nI7qwKgi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbbLHUwM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 15:52:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-formats.txt: remove unimplemented %pT
has been added to the -mm tree.  Its filename is
     printk-formatstxt-remove-unimplemented-%pt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-formatstxt-remove-unimplemented-%25pt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-formatstxt-remove-unimplemented-%25pt.patch

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
Subject: printk-formats.txt: remove unimplemented %pT

%pT for task->comm has been proposed (several times, I think), but is not
actually implemented.  Remove it from printk-formats.txt and add it back
if/when it gets implemented.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN Documentation/printk-formats.txt~printk-formatstxt-remove-unimplemented-%pt Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~printk-formatstxt-remove-unimplemented-%pt
+++ a/Documentation/printk-formats.txt
@@ -314,15 +314,6 @@ Network device features:
 
 	Passed by reference.
 
-Command from struct task_struct
-
-	%pT	ls
-
-	For printing executable name excluding path from struct
-	task_struct.
-
-	Passed by reference.
-
 If you add other %p extensions, please extend lib/test_printf.c with
 one or more test cases, if at all feasible.
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-vsprintfc-pull-out-padding-code-from-dentry_name.patch
lib-vsprintfc-move-string-below-widen_string.patch
lib-vsprintfc-eliminate-potential-race-in-string.patch
lib-vsprintfc-expand-field_width-to-24-bits.patch
lib-vsprintfc-help-gcc-make-number-smaller.patch
lib-vsprintfc-warn-about-too-large-precisions-and-field-widths.patch
lib-kasprintfc-add-sanity-check-to-kvasprintf.patch
lib-test_printfc-dont-bug.patch
lib-test_printfc-check-for-out-of-bound-writes.patch
lib-test_printfc-test-precision-quirks.patch
lib-test_printfc-add-a-few-number-tests.patch
lib-test_printfc-account-for-kvasprintf-tests.patch
lib-test_printfc-add-test-for-large-bitmaps.patch
lib-test_printfc-test-dentry-printing.patch
printk-formatstxt-remove-unimplemented-%pt.patch
powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch

