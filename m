From: akpm@linux-foundation.org
Subject: + x86-remove-unused-variable-loops-in-arch-x86-boot-a20c.patch added to -mm tree
Date: Sun, 08 Jun 2008 13:21:14 -0700
Message-ID: <200806082021.m58KLEvJ018850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745AbYFHUV5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 16:21:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mkatiyar@gmail.com, mingo@elte.hu


The patch titled
     x86: remove unused variable 'loops' in arch/x86/boot/a20.c
has been added to the -mm tree.  Its filename is
     x86-remove-unused-variable-loops-in-arch-x86-boot-a20c.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: remove unused variable 'loops' in arch/x86/boot/a20.c
From: "Manish Katiyar" <mkatiyar@gmail.com>

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/a20.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86/boot/a20.c~x86-remove-unused-variable-loops-in-arch-x86-boot-a20c arch/x86/boot/a20.c
--- a/arch/x86/boot/a20.c~x86-remove-unused-variable-loops-in-arch-x86-boot-a20c
+++ a/arch/x86/boot/a20.c
@@ -115,8 +115,6 @@ static void enable_a20_fast(void)
 
 int enable_a20(void)
 {
-	int loops = A20_ENABLE_LOOPS;
