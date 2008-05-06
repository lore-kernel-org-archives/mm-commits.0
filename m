From: akpm@linux-foundation.org
Subject: + uml-remove-unused-header.patch added to -mm tree
Date: Tue, 06 May 2008 13:49:25 -0700
Message-ID: <200805062049.m46KnPrg026579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762935AbYEFUtn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:49:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, bunk@kernel.org, jdike@linux.intel.com, xiyou.wangcong@gmail.com


The patch titled
     uml: remove unused header
has been added to the -mm tree.  Its filename is
     uml-remove-unused-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: remove unused header
From: Jeff Dike <jdike@addtoit.com>


This patch removes the unused and broken (the normal asm/keyboard.h
files no longer exists) include/asm-um/keyboard.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/keyboard.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN include/asm-um/keyboard.h~uml-remove-unused-header /dev/null
--- a/include/asm-um/keyboard.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __UM_KEYBOARD_H
-#define __UM_KEYBOARD_H
-
-#include "asm/arch/keyboard.h"
-
-#endif
_

Patches currently in -mm which might be from jdike@addtoit.com are

linux-next.patch
uml-fix-inconsistence-due-to-tty_operation-change.patch
uml-redo-host-capability-detection-and-disabling.patch
uml-tidy-stub-management-code.patch
uml-style-fixes.patch
uml-random-driver-fixes.patch
uml-random-driver-style-fixes.patch
uml-hppfs-fixes.patch
uml-move-hppfs_kernc-to-hppfsc.patch
uml-tidy-ptrace-interface.patch
uml-fix-errno-return.patch
uml-track-and-make-up-lost-ticks.patch
uml-fix-build-when-slob-is-enabled.patch
uml-remove-unused-header.patch
uml-fix-bad-ntp-interaction-with-clock.patch
uml-use-__spin_lock_unlocked.patch
uml-physical-memory-shouldnt-include-initial-stack.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch

