From: akpm@linux-foundation.org
Subject: [folded-merged]
 allow-kdump-with-crash_kexec_post_notifiers-fix.patch removed from -mm tree
Date: Tue, 02 Aug 2016 13:46:02 -0700
Message-ID: <57a1068a.hC3gIQlV2fyxgnbs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbcHBUqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 16:46:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ptesarik@suse.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: allow-kdump-with-crash_kexec_post_notifiers-fix
has been removed from the -mm tree.  Its filename was
     allow-kdump-with-crash_kexec_post_notifiers-fix.patch

This patch was dropped because it was folded into allow-kdump-with-crash_kexec_post_notifiers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: allow-kdump-with-crash_kexec_post_notifiers-fix

build fix: unconditionally include kexec.h

Cc: Petr Tesarik <ptesarik@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/enlighten.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/x86/xen/enlighten.c~allow-kdump-with-crash_kexec_post_notifiers-fix arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c~allow-kdump-with-crash_kexec_post_notifiers-fix
+++ a/arch/x86/xen/enlighten.c
@@ -34,9 +34,7 @@
 #include <linux/edd.h>
 #include <linux/frame.h>
 
-#ifdef CONFIG_KEXEC_CORE
 #include <linux/kexec.h>
-#endif
 
 #include <xen/xen.h>
 #include <xen/events.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

allow-kdump-with-crash_kexec_post_notifiers.patch
kexec-add-restriction-on-kexec_load-segment-sizes-fix.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch

