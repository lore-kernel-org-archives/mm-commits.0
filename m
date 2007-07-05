From: akpm@linux-foundation.org
Subject: + use-data_data-in-cris.patch added to -mm tree
Date: Thu, 05 Jul 2007 13:23:48 -0700
Message-ID: <200707052023.l65KNmsF017220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48055 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757033AbXGEUYG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 16:24:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, dev-etrax@axis.com, starvik@axis.com


The patch titled
     cris: use DATA_DATA
has been added to the -mm tree.  Its filename is
     use-data_data-in-cris.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cris: use DATA_DATA
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: <starvik@axis.com>
Cc: <dev-etrax@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/vmlinux.lds.S |    2 +-
 arch/cris/arch-v32/vmlinux.lds.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/cris/arch-v10/vmlinux.lds.S~use-data_data-in-cris arch/cris/arch-v10/vmlinux.lds.S
--- a/arch/cris/arch-v10/vmlinux.lds.S~use-data_data-in-cris
+++ a/arch/cris/arch-v10/vmlinux.lds.S
@@ -44,7 +44,7 @@ SECTIONS
 	___data_start = . ;
 	__Sdata = . ;
 	.data : {                     /* Data */
-		*(.data)
+		DATA_DATA
 	}
 	__edata = . ;                 /* End of data section */
 	_edata = . ;
diff -puN arch/cris/arch-v32/vmlinux.lds.S~use-data_data-in-cris arch/cris/arch-v32/vmlinux.lds.S
--- a/arch/cris/arch-v32/vmlinux.lds.S~use-data_data-in-cris
+++ a/arch/cris/arch-v32/vmlinux.lds.S
@@ -49,7 +49,7 @@ SECTIONS
 	___data_start = . ;
 	__Sdata = . ;
 	.data : {                     /* Data */
-		*(.data)
+		DATA_DATA
 	}
 	__edata = . ;		/* End of data section. */
 	_edata = . ;
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-promc-remove-undef-printk.patch
i386-text-edit-lock.patch
i386-text-edit-lock-alternative-instructions.patch
i386-text-edit-lock-kprobes.patch
immediate-values-global-modules-list-and-module-mutex.patch
immediate-value-architecture-independent-code.patch
immediate-values-non-optimized-architectures.patch
immediate-value-add-kconfig-menus.patch
immediate-values-kprobe-header-fix.patch
immediate-value-i386-optimization.patch
immediate-value-powerpc-optimization.patch
immediate-value-documentation.patch
f00f-bug-fixup-for-i386-use-immediate-values.patch
scheduler-profiling-use-immediate-values.patch
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
