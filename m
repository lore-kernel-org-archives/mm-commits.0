From: akpm@linux-foundation.org
Subject: + arch-x86-platform-mrst-pmuc-needs-moduleh.patch added to -mm tree
Date: Tue, 02 Aug 2011 16:05:15 -0700
Message-ID: <201108022343.p72Nhd30021794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547Ab1HBXnw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2011 19:43:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, len.brown@intel.com, mingo@redhat.com, tglx@linutronix.de


The patch titled
     arch/x86/platform/mrst/pmu.c needs module.h
has been added to the -mm tree.  Its filename is
     arch-x86-platform-mrst-pmuc-needs-moduleh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/platform/mrst/pmu.c needs module.h
From: Andrew Morton <akpm@linux-foundation.org>

linux-next i386 allmodconfig:

arch/x86/platform/mrst/pmu.c:739: warning: data definition has no type or storage class
arch/x86/platform/mrst/pmu.c:739: warning: type defaults to 'int' in declaration of 'MODULE_DEVICE_TABLE'
arch/x86/platform/mrst/pmu.c:739: warning: parameter names (without types) in function declaration

Cc: Len Brown <len.brown@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/mrst/pmu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/platform/mrst/pmu.c~arch-x86-platform-mrst-pmuc-needs-moduleh arch/x86/platform/mrst/pmu.c
--- a/arch/x86/platform/mrst/pmu.c~arch-x86-platform-mrst-pmuc-needs-moduleh
+++ a/arch/x86/platform/mrst/pmu.c
@@ -21,6 +21,7 @@
 #include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/seq_file.h>
 #include <linux/sfi.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-x86-platform-mrst-pmuc-needs-moduleh.patch
cris-fix-a-build-error-in-kernel-forkc.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
hpet-factor-timer-allocate-from-open.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
pps-new-client-driver-using-gpio-fix.patch

