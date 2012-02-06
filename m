From: akpm@linux-foundation.org
Subject: [merged] avr32-select-generic-atomic64_t-support.patch removed from -mm tree
Date: Mon, 06 Feb 2012 12:31:21 -0800
Message-ID: <20120206203121.68937A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:42747 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab2BFUbW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 15:31:22 -0500
Received: by mail-ee0-f74.google.com with SMTP id b15so211736eek.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 12:31:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabio.baltieri@gmail.com, egtvedt@samfundet.no, hskinnemoen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: avr32: select generic atomic64_t support
has been removed from the -mm tree.  Its filename was
     avr32-select-generic-atomic64_t-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: avr32: select generic atomic64_t support

Enable use of the generic atomic64 implementation on AVR32 platforms. 
Without this the kernel fails to build as the architecture does not
provide its version.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/avr32/Kconfig~avr32-select-generic-atomic64_t-support arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~avr32-select-generic-atomic64_t-support
+++ a/arch/avr32/Kconfig
@@ -8,6 +8,7 @@ config AVR32
 	select HAVE_KPROBES
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
+	select GENERIC_ATOMIC64
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
_

Patches currently in -mm which might be from fabio.baltieri@gmail.com are

origin.patch

