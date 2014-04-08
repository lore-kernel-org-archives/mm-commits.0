From: akpm@linux-foundation.org
Subject: [merged] doc-kernel-parameterstxt-add-early_ioremap_debug.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:52:33 -0700
Message-ID: <53446fa1.S7sAg/a9vKVQR9jI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800AbaDHVwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:52:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, dyoung@redhat.com, catalin.marinas@arm.com, borislav.petkov@amd.com, msalter@redhat.com

Subject: [merged] doc-kernel-parameterstxt-add-early_ioremap_debug.patch removed from -mm tree
To: msalter@redhat.com,borislav.petkov@amd.com,catalin.marinas@arm.com,dyoung@redhat.com,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:52:33 -0700


The patch titled
     Subject: doc/kernel-parameters.txt: add early_ioremap_debug
has been removed from the -mm tree.  Its filename was
     doc-kernel-parameterstxt-add-early_ioremap_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: doc/kernel-parameters.txt: add early_ioremap_debug

Add description of early_ioremap_debug kernel parameter.

Signed-off-by: Mark Salter <msalter@redhat.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN Documentation/kernel-parameters.txt~doc-kernel-parameterstxt-add-early_ioremap_debug Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~doc-kernel-parameterstxt-add-early_ioremap_debug
+++ a/Documentation/kernel-parameters.txt
@@ -884,6 +884,11 @@ bytes respectively. Such letter suffixes
 			Enable debug messages at boot time.  See
 			Documentation/dynamic-debug-howto.txt for details.
 
+	early_ioremap_debug [KNL]
+			Enable debug messages in early_ioremap support. This
+			is useful for tracking down temporary early mappings
+			which are not unmapped.
+
 	earlycon=	[KNL] Output early console device and options.
 		uart[8250],io,<addr>[,options]
 		uart[8250],mmio,<addr>[,options]
_

Patches currently in -mm which might be from msalter@redhat.com are

origin.patch

