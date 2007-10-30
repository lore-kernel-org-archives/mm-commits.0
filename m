From: akpm@linux-foundation.org
Subject: - x86-select-paravirt-when-paravirt_guest-on.patch removed from -mm tree
Date: Mon, 29 Oct 2007 22:02:25 -0700
Message-ID: <200710300502.l9U52PUk009964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43942 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526AbXJ3FDK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 01:03:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gcosta@redhat.com, jeremy@goop.org, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     x86: select PARAVIRT when PARAVIRT_GUEST on
has been removed from the -mm tree.  Its filename was
     x86-select-paravirt-when-paravirt_guest-on.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: x86: select PARAVIRT when PARAVIRT_GUEST on
From: Glauber de Oliveira Costa <gcosta@redhat.com>

Commit d3d1c4bdf16bd154d9f27f34fca28edca90465eb introduces a new config knob
that, according to its changelog, should select CONFIG_PARAVIRT.

However, this is not being done atm.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig.i386 |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/Kconfig.i386~x86-select-paravirt-when-paravirt_guest-on arch/x86/Kconfig.i386
--- a/arch/x86/Kconfig.i386~x86-select-paravirt-when-paravirt_guest-on
+++ a/arch/x86/Kconfig.i386
@@ -252,6 +252,7 @@ config PARAVIRT
 
 menuconfig PARAVIRT_GUEST
 	bool "Paravirtualized guest support"
+	select PARAVIRT
 	help
 	  Say Y here to get to see options related to running Linux under
 	  various hypervisors.  This option alone does not add any kernel code.
_

Patches currently in -mm which might be from gcosta@redhat.com are

mm-sparse-vmemmapc-make-sure-init_mm-is-included.patch
git-kvm.patch
x86-select-paravirt-when-paravirt_guest-on.patch
