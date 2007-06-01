From: akpm@linux-foundation.org
Subject: + introduce-o_cloexec-parisc-fix.patch added to -mm tree
Date: Thu, 31 May 2007 23:34:57 -0700
Message-ID: <200706010634.l516Yuik004284@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752908AbXFAGft (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 02:35:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyle@parisc-linux.org, drepper@redhat.com, mingo@elte.hu


The patch titled
     Introduce O_CLOEXEC (parisc fix)
has been added to the -mm tree.  Its filename is
     introduce-o_cloexec-parisc-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Introduce O_CLOEXEC (parisc fix)
From: Kyle McMartin <kyle@parisc-linux.org>

Signed-off-by: Kyle McMartin <kyle@parisc-linux.org>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-parisc/fcntl.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-parisc/fcntl.h~introduce-o_cloexec-parisc-fix include/asm-parisc/fcntl.h
--- a/include/asm-parisc/fcntl.h~introduce-o_cloexec-parisc-fix
+++ a/include/asm-parisc/fcntl.h
@@ -14,6 +14,7 @@
 #define O_DSYNC		01000000 /* HPUX only */
 #define O_RSYNC		02000000 /* HPUX only */
 #define O_NOATIME	04000000
+#define O_CLOEXEC	08000000 /* set close_on_exec */
 
 #define O_DIRECTORY	00010000 /* must be a directory */
 #define O_NOFOLLOW	00000200 /* don't follow links */
_

Patches currently in -mm which might be from kyle@parisc-linux.org are

origin.patch
git-parisc.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
introduce-o_cloexec-parisc-fix.patch
