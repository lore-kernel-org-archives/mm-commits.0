From: akpm@linux-foundation.org
Subject: - nuke-a-duplicate-include-from-profilec.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:16:46 -0800
Message-ID: <200802082016.m18KGRTH010715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48466 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738AbYBHUos (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:44:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Nuke a duplicate include from profile.c
has been removed from the -mm tree.  Its filename was
     nuke-a-duplicate-include-from-profilec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Nuke a duplicate include from profile.c
From: Jesper Juhl <jesper.juhl@gmail.com>

Remove duplicate inclusion of linux/profile.h from kernel/profile.c

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/profile.c~nuke-a-duplicate-include-from-profilec kernel/profile.c
--- a/kernel/profile.c~nuke-a-duplicate-include-from-profilec
+++ a/kernel/profile.c
@@ -20,7 +20,6 @@
 #include <linux/mm.h>
 #include <linux/cpumask.h>
 #include <linux/cpu.h>
-#include <linux/profile.h>
 #include <linux/highmem.h>
 #include <linux/mutex.h>
 #include <asm/sections.h>
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
