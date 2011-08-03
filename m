From: akpm@linux-foundation.org
Subject: + fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix.patch added to -mm tree
Date: Wed, 03 Aug 2011 10:22:47 -0700
Message-ID: <201108031720.p73HKHRR001930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669Ab1HCRU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 13:20:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, akinobu.mita@gmail.com, rdunlap@xenotime.net, sfr@canb.auug.org.au


The patch titled
     fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix
has been added to the -mm tree.  Its filename is
     fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix.patch

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
Subject: fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix
From: Andrew Morton <akpm@linux-foundation.org>

remove extraneous semicolon, per Randy

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/fault-inject.h~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix include/linux/fault-inject.h
--- a/include/linux/fault-inject.h~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix
+++ a/include/linux/fault-inject.h
@@ -47,7 +47,7 @@ struct dentry *fault_create_debugfs_attr
 #else /* CONFIG_FAULT_INJECTION_DEBUG_FS */
 
 static inline struct dentry *fault_create_debugfs_attr(const char *name,
-			struct dentry *parent, struct fault_attr *attr);
+			struct dentry *parent, struct fault_attr *attr)
 {
 	return ERR_PTR(-ENODEV);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-mrst-pmuc-needs-moduleh.patch
drivers-acpi-apei-ghesc-fix-32-bit-build.patch
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
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

