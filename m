From: akpm@linux-foundation.org
Subject: + avr32-utrace-add-missing-includes.patch added to -mm tree
Date: Fri, 20 Apr 2007 17:11:15 -0700
Message-ID: <200704210011.l3L0BFTw027062@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753014AbXDUAL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 20:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com


The patch titled
     AVR32 utrace: Add missing includes
has been added to the -mm tree.  Its filename is
     avr32-utrace-add-missing-includes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: AVR32 utrace: Add missing includes
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Include linux/tracehook.h and linux/utrace.h

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/ptrace.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN arch/avr32/kernel/ptrace.c~avr32-utrace-add-missing-includes arch/avr32/kernel/ptrace.c
--- a/arch/avr32/kernel/ptrace.c~avr32-utrace-add-missing-includes
+++ a/arch/avr32/kernel/ptrace.c
@@ -14,6 +14,8 @@
 #include <linux/ptrace.h>
 #include <linux/user.h>
 #include <linux/kdebug.h>
+#include <linux/tracehook.h>
+#include <linux/utrace.h>
 
 #include <asm/mmu_context.h>
 #include <asm/ocd.h>
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

git-avr32.patch
avr32-remove-unneeded-cast-in-atomich.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
markers-add-instrumentation-markers-menus-to-avr32.patch
avr32-implement-utrace-support.patch
avr32-utrace-add-missing-includes.patch
