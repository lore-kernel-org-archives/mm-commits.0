From: akpm@linux-foundation.org
Subject: + powerpc-fix.patch added to -mm tree
Date: Tue, 22 May 2007 20:51:35 -0700
Message-ID: <200705230351.l4N3pY31016170@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43578 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755935AbXEWDvi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 23:51:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org


The patch titled
     powerpc fix
has been added to the -mm tree.  Its filename is
     powerpc-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

powerpc-fix.patch
do-not-select-macintosh-drivers-by-default.patch
8xx-mpc885ads-pcmcia-support.patch
8xx-mpc885ads-pcmcia-support-fix.patch
8xx-fix-whitespace-and-indentation.patch
dts-kill-hardcoded-phandles.patch
git-libata-all.patch
fallocate-implementation-on-i86-x86_64-and-powerpc.patch
