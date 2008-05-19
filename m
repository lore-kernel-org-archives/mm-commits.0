From: akpm@linux-foundation.org
Subject: + x86-remove-duplicate-declaration-of-unknown_nmi_panic.patch added to -mm tree
Date: Mon, 19 May 2008 14:23:44 -0700
Message-ID: <200805192123.m4JLNiGO021246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757979AbYESVXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 17:23:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp


The patch titled
     x86: remove duplicate declaration of unknown_nmi_panic
has been added to the -mm tree.  Its filename is
     x86-remove-duplicate-declaration-of-unknown_nmi_panic.patch

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
Subject: x86: remove duplicate declaration of unknown_nmi_panic
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/nmi.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/asm-x86/nmi.h~x86-remove-duplicate-declaration-of-unknown_nmi_panic include/asm-x86/nmi.h
--- a/include/asm-x86/nmi.h~x86-remove-duplicate-declaration-of-unknown_nmi_panic
+++ a/include/asm-x86/nmi.h
@@ -46,7 +46,6 @@ extern void nmi_watchdog_default(void);
 
 extern int check_nmi_watchdog(void);
 extern int nmi_watchdog_enabled;
-extern int unknown_nmi_panic;
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
 extern int avail_to_resrv_perfctr_nmi(unsigned int);
 extern int reserve_perfctr_nmi(unsigned int);
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

x86-remove-duplicate-declaration-of-unknown_nmi_panic.patch

