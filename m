From: akpm@linux-foundation.org
Subject: - random-clean-up-checkpatch-complaints-fix.patch removed from -mm tree
Date: Mon, 28 Apr 2008 23:03:14 -0700
Message-ID: <200804290603.m3T63EbC004319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753429AbYD2GDn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 02:03:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, penguin-kernel@i-love.sakura.ne.jp, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     random: revert braindamage that snuck into checkpatch cleanup
has been removed from the -mm tree.  Its filename was
     random-clean-up-checkpatch-complaints-fix.patch

This patch was dropped because it was folded into random-clean-up-checkpatch-complaints.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: revert braindamage that snuck into checkpatch cleanup
From: Matt Mackall <mpm@selenic.com>

Signed-off-by: Matt Mackall <mpm@selenic.com>
Tested-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/random.c~random-clean-up-checkpatch-complaints-fix drivers/char/random.c
--- a/drivers/char/random.c~random-clean-up-checkpatch-complaints-fix
+++ a/drivers/char/random.c
@@ -1328,7 +1328,7 @@ ctl_table random_table[] = {
  * Rotation is separate from addition to prevent recomputation
  */
 #define ROUND(f, a, b, c, d, x, s)	\
-	(a += f(b, c, d) + in[x], a = (a << s) | (a >> (32 - s)))
+	(a += f(b, c, d) + x, a = (a << s) | (a >> (32 - s)))
 #define K1 0
 #define K2 013240474631UL
 #define K3 015666365641UL
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
use-directly-kmalloc-and-kfree-in-init-initramfsc.patch
random-clean-up-checkpatch-complaints.patch
random-clean-up-checkpatch-complaints-fix.patch
random-consolidate-wakeup-logic.patch
random-use-unlocked_ioctl.patch
random-reuse-rand_initialize.patch
random-improve-variable-naming-clear-extract-buffer.patch
random-make-backtracking-attacks-harder.patch
random-remove-cacheline-alignment-for-locks.patch
random-eliminate-redundant-new_rotate-variable.patch
random-remove-some-prefetch-logic.patch
random-simplify-add_ptr-logic.patch
random-make-mixing-interface-byte-oriented.patch
random-simplify-and-rename-credit_entropy_store.patch
random-add-async-notification-support-to-dev-random.patch

