From: akpm@linux-foundation.org
Subject: [obsolete] lib-add-weak-__clzsi2-__clzdi2-functions-fix.patch removed from -mm tree
Date: Tue, 30 Apr 2013 14:46:22 -0700
Message-ID: <20130430214622.8B88A31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:47002 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab3D3VqX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 17:46:23 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so110096ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 14:46:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chanho.min@lge.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-add-weak-__clzsi2-__clzdi2-functions-fix
has been removed from the -mm tree.  Its filename was
     lib-add-weak-__clzsi2-__clzdi2-functions-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-add-weak-__clzsi2-__clzdi2-functions-fix

fix typo __clzdi2i -> __clzdi2

Cc: Chanho Min <chanho.min@lge.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/clz.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/clz.c~lib-add-weak-__clzsi2-__clzdi2-functions-fix lib/clz.c
--- a/lib/clz.c~lib-add-weak-__clzsi2-__clzdi2-functions-fix
+++ a/lib/clz.c
@@ -26,7 +26,7 @@ int __weak __clzdi2(long val)
 }
 EXPORT_SYMBOL(__clzdi2);
 #elif BITS_PER_LONG == 64
-int __weak __clzdi2i(long val)
+int __weak __clzdi2(long val)
 {
 	return BITS_PER_LONG - fls64((u64)val);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-usb-storage-realtek_crc-fix-build.patch
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
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch

