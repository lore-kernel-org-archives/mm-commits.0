From: akpm@linux-foundation.org
Subject: + kvm-fix-virtualization-menu-help-text.patch added to -mm tree
Date: Sun, 23 Sep 2007 02:17:18 -0700
Message-ID: <200709230917.l8N9HIfA004559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42415 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753931AbXIWJR7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 23 Sep 2007 05:17:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, jengelh@computergmbh.de, rusty@rustcorp.com.au


The patch titled
     KVM: Fix virtualization menu help text
has been added to the -mm tree.  Its filename is
     kvm-fix-virtualization-menu-help-text.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Fix virtualization menu help text
From: Avi Kivity <avi@qumranet.com>

An August 18 patch from Jan Engelhardt (06bfb7e) added help text for the
virtualization menu.  Unfortunately the text is misleading, as "guest
drivers" are usually interpreted to mean "drivers running inside the
guest", which is not the case for kvm.

Cc: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/Kconfig~kvm-fix-virtualization-menu-help-text drivers/kvm/Kconfig
--- a/drivers/kvm/Kconfig~kvm-fix-virtualization-menu-help-text
+++ a/drivers/kvm/Kconfig
@@ -6,7 +6,8 @@ menuconfig VIRTUALIZATION
 	depends on X86
 	default y
 	---help---
-	  Say Y here to get to see options for virtualization guest drivers.
+	  Say Y here to get to see options for using your Linux host to run other
+	  operating systems inside virtual machines (guests).
 	  This option alone does not add any kernel code.
 
 	  If you say N, all options in this submenu will be skipped and disabled.
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-fix-virtualization-menu-help-text.patch
git-kvm.patch
time-simplify-smp_call_function_single-call-sequence.patch
move-preempt_notifiers-into-an-always-included-kconfig.patch
