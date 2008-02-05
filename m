From: akpm@linux-foundation.org
Subject: - uml-spelling-fix.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:53:47 -0800
Message-ID: <200802050253.m152rSNm031505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36307 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752703AbYBECyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:54:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: spelling fix
has been removed from the -mm tree.  Its filename was
     uml-spelling-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: spelling fix
From: Joe Perches <joe@perches.com>

Spelling fix

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-x86_64/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/sys-x86_64/signal.c~uml-spelling-fix arch/um/sys-x86_64/signal.c
--- a/arch/um/sys-x86_64/signal.c~uml-spelling-fix
+++ a/arch/um/sys-x86_64/signal.c
@@ -112,7 +112,7 @@ static int copy_sc_to_user(struct sigcon
 	err |= PUTREG(regs, RSI, to, si);
 	err |= PUTREG(regs, RBP, to, bp);
 	/*
-	 * Must use orignal RSP, which is passed in, rather than what's in
+	 * Must use original RSP, which is passed in, rather than what's in
 	 * the pt_regs, because that's already been updated to point at the
 	 * signal frame.
 	 */
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
uml-add-missing-space.patch
uml-style-fixes-in-arch-um-kernel.patch
git-cpufreq.patch
git-hwmon.patch
git-kvm.patch
git-unionfs.patch
printk_ratelimit-functions-should-use-config_printk.patch
