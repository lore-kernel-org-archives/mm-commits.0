From: akpm@linux-foundation.org
Subject: [folded-merged]
 signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 15:39:49 -0700
Message-ID: <543c54b5.LzTpuM+mZPZTziPd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaJMWjt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:39:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.fix
has been removed from the -mm tree.  Its filename was
     signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch

This patch was dropped because it was folded into signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.fix

Fixes signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
which caused the build failure on powerpc.

Add missing "include <linux/bug.h>" which defines BUILD_BUG()
used by that patch.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/signal.h~signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix include/linux/signal.h
--- a/include/linux/signal.h~signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix
+++ a/include/linux/signal.h
@@ -2,6 +2,7 @@
 #define _LINUX_SIGNAL_H
 
 #include <linux/list.h>
+#include <linux/bug.h>
 #include <uapi/linux/signal.h>
 
 struct task_struct;
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
try-to-use-automatic-variable-in-kexec-purgatory-makefile.patch
watchdog-control-hard-lockup-detection-default-fix-2.patch

