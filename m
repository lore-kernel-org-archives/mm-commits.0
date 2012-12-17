From: akpm@linux-foundation.org
Subject: + create-non-empty-arch-x86-include-uapi-asm-files.patch added to -mm tree
Date: Mon, 17 Dec 2012 14:17:15 -0800
Message-ID: <20121217230748.6ADDB200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:38955 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2LQXHv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:07:51 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so351360wgb.3
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:07:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, arnd@arndb.de, davej@redhat.com, dhowells@redhat.com, mtk.manpages@gmail.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de


The patch titled
     Subject: create non-empty arch/x86/include/uapi/asm/ files
has been added to the -mm tree.  Its filename is
     create-non-empty-arch-x86-include-uapi-asm-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: create non-empty arch/x86/include/uapi/asm/ files

patch(1) doesn't create zero-length files, so my kernel didn't compile.

Put something in these files so patch(1) actually creates them.

Cc: David Howells <dhowells@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/uapi/asm/hw_breakpoint.h |    1 +
 arch/x86/include/uapi/asm/setup.h         |    1 +
 2 files changed, 2 insertions(+)

diff -puN /dev/null arch/x86/include/uapi/asm/hw_breakpoint.h
--- /dev/null
+++ a/arch/x86/include/uapi/asm/hw_breakpoint.h
@@ -0,0 +1 @@
+/* */
diff -puN /dev/null arch/x86/include/uapi/asm/setup.h
--- /dev/null
+++ a/arch/x86/include/uapi/asm/setup.h
@@ -0,0 +1 @@
+/* */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
create-non-empty-arch-x86-include-uapi-asm-files.patch
mm-memoryc-suppress-warning.patch

