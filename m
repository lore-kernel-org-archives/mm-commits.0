From: akpm@linux-foundation.org
Subject: - arch-um-remove-duplicate-includes.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:36:14 -0800
Message-ID: <200802052235.m15MZtfB012653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36563 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762286AbYBEWlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: woodzy@gmail.com, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     arch/um: remove duplicate includes
has been removed from the -mm tree.  Its filename was
     arch-um-remove-duplicate-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/um: remove duplicate includes
From: Lucas Woods <woodzy@gmail.com>

Signed-off-by: Lucas Woods <woodzy@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/sigio.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/um/os-Linux/sigio.c~arch-um-remove-duplicate-includes arch/um/os-Linux/sigio.c
--- a/arch/um/os-Linux/sigio.c~arch-um-remove-duplicate-includes
+++ a/arch/um/os-Linux/sigio.c
@@ -20,7 +20,6 @@
 #include "sigio.h"
 #include "os.h"
 #include "um_malloc.h"
-#include "init.h"
 
 /* Protected by sigio_lock(), also used by sigio_cleanup, which is an
  * exitcall.
_

Patches currently in -mm which might be from woodzy@gmail.com are

origin.patch
git-xtensa.patch
