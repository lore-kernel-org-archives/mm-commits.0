From: akpm@linux-foundation.org
Subject: [folded-merged] staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix.patch removed from -mm tree
Date: Tue, 30 Apr 2013 15:14:04 -0700
Message-ID: <20130430221405.40DE55A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:60603 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3D3WOH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 18:14:07 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so113033qab.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 15:14:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.magenheimer@oracle.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix
has been removed from the -mm tree.  Its filename was
     staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix.patch

This patch was dropped because it was folded into staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix

use_frontswap_selfshrink cannot be __initdata

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zcache/ramster/ramster.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/zcache/ramster/ramster.c~staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix drivers/staging/zcache/ramster/ramster.c
--- a/drivers/staging/zcache/ramster/ramster.c~staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix
+++ a/drivers/staging/zcache/ramster/ramster.c
@@ -773,7 +773,7 @@ static DECLARE_DELAYED_WORK(selfshrink_w
 
 #ifndef CONFIG_RAMSTER_MODULE
 /* Enable/disable with kernel boot option. */
-static bool use_frontswap_selfshrink __initdata = true;
+static bool use_frontswap_selfshrink = true;
 #endif
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-usb-storage-realtek_crc-fix-build.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
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

