From: akpm@linux-foundation.org
Subject: [folded-merged] lib-string_helpers-introduce-generic-string_unescape-fix.patch removed from -mm tree
Date: Tue, 30 Apr 2013 15:14:38 -0700
Message-ID: <20130430221438.C7FDF31C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:41917 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760674Ab3D3WOk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 18:14:40 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so113995vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 15:14:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-string_helpers-introduce-generic-string_unescape-fix
has been removed from the -mm tree.  Its filename was
     lib-string_helpers-introduce-generic-string_unescape-fix.patch

This patch was dropped because it was folded into lib-string_helpers-introduce-generic-string_unescape.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-string_helpers-introduce-generic-string_unescape-fix

clarify comment

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string_helpers.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/string_helpers.h~lib-string_helpers-introduce-generic-string_unescape-fix include/linux/string_helpers.h
--- a/include/linux/string_helpers.h~lib-string_helpers-introduce-generic-string_unescape-fix
+++ a/include/linux/string_helpers.h
@@ -47,8 +47,8 @@ int string_get_size(u64 size, enum strin
  * Returns amount of characters processed to the destination buffer excluding
  * trailing '\0'.
  *
- * Due to size of output will be the same or smaller the translation could be
- * done in place.
+ * Because the size of the output will be the same as or less than the size of
+ * the input, the transformation may be performed in place.
  *
  * Caller must provide valid source and destination pointers. Be aware that
  * destination buffer will always be NULL-terminated. Source string must be
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-usb-storage-realtek_crc-fix-build.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
kernel-smpc-cleanups.patch
lib-string_helpers-introduce-generic-string_unescape.patch
lib-string_helpers-introduce-generic-string_unescape-fix-fix.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch

