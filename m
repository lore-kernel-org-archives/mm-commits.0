From: akpm@linux-foundation.org
Subject: + doc-kernel-parameterstxt-add-early_ioremap_debug.patch added to -mm tree
Date: Thu, 13 Mar 2014 13:52:04 -0700
Message-ID: <53221a74.sYxmP1PKOsDqMzIf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbaCMUwF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Mar 2014 16:52:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, dyoung@redhat.com, catalin.marinas@arm.com, borislav.petkov@amd.com, msalter@redhat.com

Subject: + doc-kernel-parameterstxt-add-early_ioremap_debug.patch added to -mm tree
To: msalter@redhat.com,borislav.petkov@amd.com,catalin.marinas@arm.com,dyoung@redhat.com,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de,will.deacon@arm.com
From: akpm@linux-foundation.org
Date: Thu, 13 Mar 2014 13:52:04 -0700


The patch titled
     Subject: doc/kernel-parameters.txt: add early_ioremap_debug
has been added to the -mm tree.  Its filename is
     doc-kernel-parameterstxt-add-early_ioremap_debug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/doc-kernel-parameterstxt-add-early_ioremap_debug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/doc-kernel-parameterstxt-add-early_ioremap_debug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -870,6 +870,11 @@ bytes respectively. Such letter suffixes
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

arm-use-generic-fixmaph.patch
x86-mm-sparse-warning-fix-for-early_memremap.patch
mm-create-generic-early_ioremap-support.patch
x86-use-generic-early_ioremap.patch
arm64-initialize-pgprot-info-earlier-in-boot.patch
arm64-add-early_ioremap-support.patch
doc-kernel-parameterstxt-add-early_ioremap_debug.patch

