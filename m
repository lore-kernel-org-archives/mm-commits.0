From: akpm@linux-foundation.org
Subject: [merged] includecheck-fix-drivers-char-vtc.patch removed from -mm tree
Date: Mon, 17 Aug 2009 13:05:08 -0700
Message-ID: <200908172005.n7HK58kq017950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbZHQUKn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 16:10:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, jaswinderrajput@gmail.com, mm-commits@vger.kernel.org


The patch titled
     includecheck fix: drivers/char/vt.c
has been removed from the -mm tree.  Its filename was
     includecheck-fix-drivers-char-vtc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: includecheck fix: drivers/char/vt.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Fix the following 'make includecheck' warning:

  drivers/char/vt.c: linux/device.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/vt.c~includecheck-fix-drivers-char-vtc drivers/char/vt.c
--- a/drivers/char/vt.c~includecheck-fix-drivers-char-vtc
+++ a/drivers/char/vt.c
@@ -2957,7 +2957,6 @@ int __init vty_init(const struct file_op
 }
 
 #ifndef VT_SINGLE_DRIVER
-#include <linux/device.h>
 
 static struct class *vtconsole_class;
 
_

Patches currently in -mm which might be from jaswinder@kernel.org are

linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
gitignore-usr-initramfs_datacpiobz2-and-usr-initramfs_datacpiolzma.patch
mm-includecheck-fix-for-mm-shmemc.patch
mm-includecheck-fix-for-mm-nommuc.patch
includecheck-fix-documentation-cfag12864b-examplec.patch

