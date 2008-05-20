From: akpm@linux-foundation.org
Subject: - x86-remove-duplicate-declaration-of-unknown_nmi_panic.patch removed from -mm tree
Date: Tue, 20 May 2008 14:14:00 -0700
Message-ID: <200805202114.m4KLE0aI011421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760431AbYETVOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 17:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     x86: remove duplicate declaration of unknown_nmi_panic
has been removed from the -mm tree.  Its filename was
     x86-remove-duplicate-declaration-of-unknown_nmi_panic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

