From: akpm@linux-foundation.org
Subject: + lib-string_helpers-introduce-generic-string_unescape-fix-fix.patch added to -mm tree
Date: Tue, 30 Apr 2013 14:08:16 -0700
Message-ID: <20130430210816.BF3A15A4278@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:33865 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561Ab3D3VIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 17:08:17 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so106074vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 14:08:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com


The patch titled
     Subject: lib-string_helpers-introduce-generic-string_unescape-fix-fix
has been added to the -mm tree.  Its filename is
     lib-string_helpers-introduce-generic-string_unescape-fix-fix.patch

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
Subject: lib-string_helpers-introduce-generic-string_unescape-fix-fix

export get_random_int() to modules

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/random.c~lib-string_helpers-introduce-generic-string_unescape-fix-fix drivers/char/random.c
--- a/drivers/char/random.c~lib-string_helpers-introduce-generic-string_unescape-fix-fix
+++ a/drivers/char/random.c
@@ -1485,6 +1485,7 @@ unsigned int get_random_int(void)
 
 	return ret;
 }
+EXPORT_SYMBOL(get_random_int);
 
 /*
  * randomize_range() returns a start address such that
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it-fix.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
kernel-smpc-cleanups.patch
lib-string_helpers-introduce-generic-string_unescape-fix.patch
lib-string_helpers-introduce-generic-string_unescape-fix-fix.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
lib-add-weak-__clzsi2-__clzdi2-functions-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch

