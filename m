From: akpm@linux-foundation.org
Subject: + watchdog-hpwdt-use-set_memoryh-header.patch added to -mm tree
Date: Fri, 03 Mar 2017 15:50:24 -0800
Message-ID: <58ba0140.N1W/D6KslhQIwNGI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34632 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752401AbdCDAAy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 19:00:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@redhat.com, airlied@linux.ie, alexander.shishkin@linux.intel.com, arnd@arndb.de, catalin.marinas@arm.com, daniel@iogearbox.net, davem@davemloft.net, heiko.carstens@de.ibm.com, hpa@zytor.com, jeyu@redhat.com, keescook@chromium.org, linux@armlinux.org.uk, linux@roeck-us.net, mark.rutland@arm.com, mingo@redhat.com, schwidefsky@de.ibm.com, tglx@linutronix.de, tiwai@suse.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/watchdog/hpwdt.c: use set_memory.h header
has been added to the -mm tree.  Its filename is
     watchdog-hpwdt-use-set_memoryh-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-hpwdt-use-set_memoryh-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-hpwdt-use-set_memoryh-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <labbott@redhat.com>
Subject: drivers/watchdog/hpwdt.c: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly.

Link: http://lkml.kernel.org/r/1488413706-9739-10-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/hpwdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/watchdog/hpwdt.c~watchdog-hpwdt-use-set_memoryh-header drivers/watchdog/hpwdt.c
--- a/drivers/watchdog/hpwdt.c~watchdog-hpwdt-use-set_memoryh-header
+++ a/drivers/watchdog/hpwdt.c
@@ -34,7 +34,7 @@
 #include <linux/nmi.h>
 #include <linux/kdebug.h>
 #include <linux/notifier.h>
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #endif /* CONFIG_HPWDT_NMI_DECODING */
 #include <asm/nmi.h>
 #include <asm/frame.h>
_

Patches currently in -mm which might be from labbott@redhat.com are

treewide-move-set_memory_-functions-away-from-cacheflushh.patch
arm-use-set_memoryh-header.patch
arm64-use-set_memoryh-header.patch
s390-use-set_memoryh-header.patch
x86-use-set_memoryh-header.patch
agp-use-set_memoryh-header.patch
drm-use-set_memoryh-header.patch
intel_th-use-set_memoryh-header.patch
watchdog-hpwdt-use-set_memoryh-header.patch
bpf-use-set_memoryh-header.patch
module-use-set_memoryh-header.patch
pm-hibernate-use-set_memoryh-header.patch
alsa-hda-use-set_memoryh-header.patch
treewide-decouple-cacheflushh-and-set_memoryh.patch

