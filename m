From: akpm@linux-foundation.org
Subject: + avr32-select-generic-atomic64_t-support.patch added to -mm tree
Date: Thu, 02 Feb 2012 12:27:09 -0800
Message-ID: <20120202202709.85387A00B3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vw0-f74.google.com ([209.85.212.74]:34122 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2BBU1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2012 15:27:11 -0500
Received: by vbbfp1 with SMTP id fp1so357008vbb.1
        for <mm-commits@vger.kernel.org>; Thu, 02 Feb 2012 12:27:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fabio.baltieri@gmail.com, egtvedt@samfundet.no, hskinnemoen@gmail.com


The patch titled
     Subject: avr32: select generic atomic64_t support
has been added to the -mm tree.  Its filename is
     avr32-select-generic-atomic64_t-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: avr32: select generic atomic64_t support

Patches currently in -mm which might be from fabio.baltieri@gmail.com are

avr32-select-generic-atomic64_t-support.patch

