From: akpm@linux-foundation.org
Subject: - powerpc-fix.patch removed from -mm tree
Date: Wed, 23 May 2007 13:20:45 -0700
Message-ID: <200705232020.l4NKKikP030982@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756433AbXEWUUs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 16:20:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     powerpc fix
has been removed from the -mm tree.  Its filename was
     powerpc-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vmlinux.lds.S |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/powerpc/kernel/vmlinux.lds.S~powerpc-fix arch/powerpc/kernel/vmlinux.lds.S
--- a/arch/powerpc/kernel/vmlinux.lds.S~powerpc-fix
+++ a/arch/powerpc/kernel/vmlinux.lds.S
@@ -34,7 +34,6 @@ SECTIONS
 	/* Text and gots */
 	.text : {
 		_text = .;
-		*(.text.*)
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
do-not-select-macintosh-drivers-by-default.patch
8xx-mpc885ads-pcmcia-support.patch
8xx-mpc885ads-pcmcia-support-fix.patch
8xx-fix-whitespace-and-indentation.patch
dts-kill-hardcoded-phandles.patch
git-libata-all.patch
rework-ptep_set_access_flags-and-fix-sun4c.patch
fallocate-implementation-on-i86-x86_64-and-powerpc.patch
