From: akpm@linux-foundation.org
Subject: - extended-crashkernel-command-line-comment-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:30:54 -0700
Message-ID: <200710190430.l9J4UsWs015173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50457 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966579AbXJSEa7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:30:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, mm-commits@vger.kernel.org


The patch titled
     extended-crashkernel-command-line comment fix
has been removed from the -mm tree.  Its filename was
     extended-crashkernel-command-line-comment-fix.patch

This patch was dropped because it was folded into extended-crashkernel-command-line.patch

------------------------------------------------------
Subject: extended-crashkernel-command-line comment fix
From: Bernhard Walle <bwalle@suse.de>

Only use 'offset' and not 'base' for the address where the reserved area
starts.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/kexec.c~extended-crashkernel-command-line-comment-fix kernel/kexec.c
--- a/kernel/kexec.c~extended-crashkernel-command-line-comment-fix
+++ a/kernel/kexec.c
@@ -1157,7 +1157,7 @@ module_init(crash_notes_memory_init)
 /*
  * This function parses command lines in the format
  *
- *   crashkernel=<ramsize-range>:<size>[,...][@<base>]
+ *   crashkernel=ramsize-range:size[,...][@offset]
  *
  * The function returns 0 on success and -EINVAL on failure.
  */
@@ -1222,7 +1222,7 @@ static int __init parse_crashkernel_mem(
 /*
  * That function parses "simple" (old) crashkernel command lines like
  *
- * 	crashkernel=size[@base]
+ * 	crashkernel=size[@offset]
  *
  * It returns 0 on success and -EINVAL on failure.
  */
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
extended-crashkernel-command-line.patch
extended-crashkernel-command-line-comment-fix.patch
extended-crashkernel-command-line-improve-error-handling-in-parse_crashkernel_mem.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-i386-update.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-x86_64-update.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
use-extended-crashkernel-command-line-on-ia64-update.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-ppc64-update.patch
use-extended-crashkernel-command-line-on-sh.patch
use-extended-crashkernel-command-line-on-sh-update.patch
add-documentation-for-extended-crashkernel-syntax.patch
add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch
