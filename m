From: akpm@linux-foundation.org
Subject: + rtc-add-dallas-ds2404-driver-fix.patch added to -mm tree
Date: Tue, 14 Aug 2012 16:04:37 -0700
Message-ID: <20120814230438.623F01E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:56742 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab2HNXMt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Aug 2012 19:12:49 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so733742obb.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2012 16:12:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, svens@stackframe.org


The patch titled
     Subject: rtc-add-dallas-ds2404-driver-fix
has been added to the -mm tree.  Its filename is
     rtc-add-dallas-ds2404-driver-fix.patch

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
Subject: rtc-add-dallas-ds2404-driver-fix

drivers/rtc/rtc-ds2404.c:23:1: warning: "DEBUG" redefined <command-line>:
warning: this is the location of the previous definition

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sven Schnelle <svens@stackframe.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds2404.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/rtc/rtc-ds2404.c~rtc-add-dallas-ds2404-driver-fix drivers/rtc/rtc-ds2404.c
--- a/drivers/rtc/rtc-ds2404.c~rtc-add-dallas-ds2404-driver-fix
+++ a/drivers/rtc/rtc-ds2404.c
@@ -20,8 +20,6 @@
 
 #include <linux/io.h>
 
-#define DEBUG
-
 #define DS2404_STATUS_REG 0x200
 #define DS2404_CONTROL_REG 0x201
 #define DS2404_RTC_REG 0x202
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm-slab_commonc-fix-warning.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
rbtree-performance-and-correctness-test-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

