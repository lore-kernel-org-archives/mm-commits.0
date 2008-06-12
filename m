From: akpm@linux-foundation.org
Subject: - x86-remove-unused-variable-loops-in-arch-x86-boot-a20c.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:36:42 -0700
Message-ID: <200806122036.m5CKagSq005354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755618AbYFLUgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:36:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mkatiyar@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86: remove unused variable 'loops' in arch/x86/boot/a20.c
has been removed from the -mm tree.  Its filename was
     x86-remove-unused-variable-loops-in-arch-x86-boot-a20c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
